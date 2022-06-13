defmodule LetzellWeb.Mutations.AuthMutations do
  use Absinthe.Schema.Notation

  import LetzellWeb.Helpers.ValidationMessageHelpers

  alias LetzellWeb.Schema.Middleware
  alias LetzellWeb.Email
  alias Letzell.{Accounts, Confirmations, Mailer}

  object :auth_mutations do
    @desc "Sign in"
    field :sign_in, :user_payload do
      arg(:email, :string)
      # arg(:password, :string)

      resolve(fn args, %{context: context} ->
        # with {:ok, user} <- Accounts.authenticate(args[:email], args[:password]),
        with {:ok, user} <- Accounts.authenticate(args[:email]),
        # with {:ok, user} <- Accounts.user_by_email(args[:email]),
             true <- Confirmations.confirmed?(user),
            #  {:ok, token, _} <- Accounts.generate_access_token(user) do
            {:ok, _code, user_with_code} <- Confirmations.generate_confirmation_code(user),
            %Bamboo.Email{} = welcome_email <- Email.welcome(user_with_code) do
            user |> Accounts.update_tracked_fields(context[:remote_ip])
            Mailer.deliver_now(welcome_email)

          # {:ok, %{token: token, profile_completed: nil}}
          {:ok, user_with_code}
        else
          {:error, :no_yet_confirmed, user_with_new_code} ->
            user_with_new_code |> Email.new_confirmation_code() |> Mailer.deliver_now()
            {:ok, message(:no_yet_confirmed, "The account must be validated.")}

          {:error, %Ecto.Query{}} ->
            {:error, generic_message("Email ou mot de passe invalide.")}
          {:error, msg} ->
            {:ok, generic_message(msg)}

          :error ->
            {:error, generic_message("Email ou mot de passe invalide.")}
        end
      end)
    end

    @desc "Revoke token"
    field :revoke_token, :boolean_payload do
      middleware(Middleware.Authorize)

      resolve(fn _, %{context: context} ->
        context[:current_user]
        |> Accounts.revoke_access_token()

        {:ok, true}
      end)
    end
  end
end
