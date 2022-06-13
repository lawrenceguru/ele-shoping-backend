defmodule Letzell.Accounts.User do
  use Ecto.Schema
  import Ecto.Changeset
  alias Letzell.Accounts.User
  alias Letzell.Reviews.Review
  alias Letzell.Recipes.Recipe
  alias Letzell.Listings.Listing
  alias Letzell.Favorites.Favorite
  alias Letzell.Schema

  @primary_key {:id, :binary_id, autogenerate: true}

  schema "users" do
    field(:email, Letzell.Encrypted.Binary)
    field(:first_name, Letzell.Encrypted.Binary)
    field(:last_name, Letzell.Encrypted.Binary)
    field(:user_name, :string)
    field(:user_type, :string, default: "user")
    field :avatar_url, :string

    field(:primary_phone, Letzell.Encrypted.Binary)
    field(:secondary_phone, Letzell.Encrypted.Binary)
    field(:fax_number, Letzell.Encrypted.Binary)
    field(:postal_code, Letzell.Encrypted.Binary)

    field(:profile_details, Letzell.Encrypted.Map)
    field(:photo_urls, {:array, :string}, default: [])

    field(:email_hash, Cloak.Ecto.SHA256)
    field(:first_name_hash, Cloak.Ecto.SHA256)
    field(:last_name_hash, Cloak.Ecto.SHA256)
    field(:postal_code_hash, Cloak.Ecto.SHA256)

    # field(:password, :string, virtual: true)
    # field(:password_confirmation, :string, virtual: true)
    # field(:password_hash, :string)
    field(:access_token, :string)

    field(:current_sign_in_at, :utc_datetime)
    field(:last_sign_in_at, :utc_datetime)
    field(:sign_in_count, :integer, default: 0)
    field(:current_sign_in_ip, :string)
    field(:last_sign_in_ip, :string)

    field(:confirmation_code, :string)
    field(:inputed_code, :string, virtual: true)
    field(:confirmed_at, :utc_datetime)
    field(:confirmation_sent_at, :utc_datetime)

    has_many :recipes, Recipe
    has_many :listings, Listing
    has_many :reviews, Review
    has_many :favorites, Favorite
    timestamps(type: :utc_datetime)
  end

  def changeset(%User{} = user, attrs) do
    attrs = attrs |> Map.delete(:password)

    user
    |> cast(attrs, [:first_name, :last_name, :email, :primary_phone, :secondary_phone, :fax_number, :postal_code])
    |> validate_required([:first_name, :last_name, :email])
    |> validate_format(:email, ~r/@/)
    |> put_hashed_fields()
    |> unique_constraint(:email, name: :users_email_index, message: "Email already registered")
  end

  def changeset(%User{} = user, attrs, :tracked_fields) do
    user
    |> cast(attrs, [:current_sign_in_at, :last_sign_in_at, :current_sign_in_ip, :last_sign_in_ip, :sign_in_count])
  end

  def changeset(%User{} = user, attrs, :profile_fields) do
    user
    |> changeset(attrs)
    |> cast(attrs, [:profile_details])

    # |> cast_embed(attrs, :profile_details)
  end

  def changeset(%User{} = user, attrs, :preference_fields) do
    user
    |> cast(attrs, [:preference_fields])
  end

  def changeset(%User{} = user, attrs, :password) do
    user
    |> cast(attrs, [:first_name, :last_name, :user_type, :email, :primary_phone, :secondary_phone, :fax_number, :postal_code])
    |> validate_required([:first_name, :last_name, :email])
    # |> cast(attrs, [:first_name, :last_name, :user_type, :email, :password, :password_confirmation])
    # |> validate_required([:first_name, :last_name, :email, :password, :password_confirmation])
    |> put_hashed_fields()
    # |> validate_length(:password, min: 6)
    # |> validate_confirmation(:password, message: "Ne correspond pas")
    |> validate_format(:email, ~r/^[^\s]+@[^\s]+$/, message: "must have the @ sign and no spaces")
    # |> unique_constraint(:email, name: :users_email_index, message: "Email is already registered.")
    |> unique_constraint(:email_hash, name: :users_email_hash_index)
    # |> put_pass_hash()
    |> populate_username()
  end

  defp put_hashed_fields(changeset) do
    changeset
    |> put_change(:email_hash, String.downcase(get_field(changeset, :email)))
    |> put_change(:first_name_hash, get_field(changeset, :first_name))
    |> put_change(:last_name_hash, get_field(changeset, :last_name))
    |> put_change(:postal_code_hash, get_field(changeset, :postal_code))
  end

  defp populate_username(changeset) do
    put_change(changeset, :user_name, generate_username())
  end

  def generate_username() do
    min = String.to_integer("1000000", 36)
    max = String.to_integer("ZZZZZZZ", 36)

    max
    |> Kernel.-(min)
    |> :rand.uniform()
    |> Kernel.+(min)
    |> Integer.to_string(36)
  end

  # @spec put_pass_hash(Ecto.Changeset.t()) :: Ecto.Changeset.t() | no_return
  # defp put_pass_hash(changeset) do
  #   case changeset do
  #     %Ecto.Changeset{valid?: true, changes: %{password: pass}} ->
  #       put_change(changeset, :password_hash, Pbkdf2.hash_pwd_salt(pass))

  #     _ ->
  #       changeset
  #   end
  # end
end
