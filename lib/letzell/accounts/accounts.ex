defmodule Letzell.Accounts do
  import Ecto.Query, warn: false
  import Ecto.Changeset, only: [put_assoc: 3]
  alias Letzell.Repo
  alias Letzell.Accounts.User
  alias Letzell.Reviews.Review

  def get_user(id), do: Repo.get(User, id)

  def create_user(attrs) do
    %User{}
    |> User.changeset(attrs, :password)
    |> Repo.insert()
  end

  def update_user(%User{} = user, attrs) do
    user
    |> User.changeset(attrs)
    |> Repo.update()
  end

  def change_password(%User{} = user, %{password: password, password_confirmation: password_confirmation}) do
    user
    |> User.changeset(%{password: password, password_confirmation: password_confirmation}, :password)
    |> Repo.update()
  end

  def cancel_account(%User{} = user) do
    user |> Repo.delete()
  end

  @doc """
  Generate an access token and associates it with the user
  """
  @spec generate_access_token(User.t()) :: {:ok, String.t(), User.t()}
  def generate_access_token(user) do
    access_token = generate_token(user)
    user_modified = Ecto.Changeset.change(user, access_token: access_token)
    {:ok, user} = Repo.update(user_modified)
    {:ok, access_token, user}
  end

  @spec generate_token(User.t()) :: String.t()
  defp generate_token(user) do
    128 |> :crypto.strong_rand_bytes() |> Base.encode64()
  end

  @spec revoke_access_token(User.t()) :: {:ok, User.t()} | {:error, any()}
  def revoke_access_token(user) do
    user_modified = Ecto.Changeset.change(user, access_token: nil)
    {:ok, _user} = Repo.update(user_modified)
  end

  @doc """
  Authenticate user with email and password
  """
  @spec authenticate(User.t(), String.t()) :: {:ok, User.t()} | {:error, String.t()}
  def authenticate(nil), do: {:error, "Email is not valid"}
  def authenticate(_email, nil), do: {:error, "Password is not valid"}

  def authenticate(email) do
    user = User |> Repo.get_by(email_hash: String.downcase(email))

    case user do
      nil -> {:error, "Email is not in our system. You can use the signup to register an account"}
      _ -> {:ok, user}
    end
  end

  @spec check_password(User.t(), String.t()) :: boolean()
  defp check_password(user, password) do
    case user do
      nil -> false
      _ -> Pbkdf2.verify_pass(password, user.password_hash)
    end
  end

  @doc """
  Update tracked fields
  """
  @spec update_tracked_fields(User.t(), String.t()) :: {:ok, User.t()} | {:error, any()}
  def update_tracked_fields(%User{} = user, remote_ip) do
    attrs = %{
      current_sign_in_at: Timex.now(),
      last_sign_in_at: user.current_sign_in_at,
      current_sign_in_ip: remote_ip,
      sign_in_count: user.sign_in_count + 1
    }

    attrs =
      case user.current_sign_in_ip != remote_ip do
        true -> Map.put(attrs, :last_sign_in_ip, user.current_sign_in_ip)
        _ -> attrs
      end

    user
    |> User.changeset(attrs, :tracked_fields)
    |> Repo.update()
  end

  @spec update_profile_fields(User.t(), String.t()) :: {:ok, User.t()} | {:error, any()}
  def update_profile_fields(%User{} = user, params) do
    attrs = %{
      profile_details: params
    }

    user
    |> User.changeset(attrs, :profile_fields)
    |> Repo.update()
  end

  @spec update_preference_fields(User.t(), String.t()) :: {:ok, User.t()} | {:error, any()}
  def update_preference_fields(%User{} = user, params) do
    attrs = %{
      preference_details: params
    }

    user
    |> User.changeset(attrs, :preference_fields)
    |> Repo.update()
  end

  @doc """
  Get user by email
  """
  @spec user_by_email(String.t()) :: {:ok, any()} | {:error, Ecto.Query}
  def user_by_email(email) do
    User
    |> Ecto.Query.where(email_hash: ^String.downcase(email))
    |> Repo.fetch()
  end

  def data() do
    Dataloader.Ecto.new(Repo, query: &query/2)
  end

  def query(queryable, _) do
    queryable
  end
end
