defmodule Letzell.Favorites.Favorite do
  use Ecto.Schema
  import Ecto.Changeset
  alias Letzell.Accounts.User
  alias Letzell.Listings.Listing
  alias Letzell.Favorites.Favorite
  alias Letzell.Schema

  @primary_key {:id, :binary_id, autogenerate: true}
  schema "favorites" do
    field(:status, :string, default: "added")
    belongs_to(:listing, Listing, type: :binary_id)
    belongs_to(:user, User, foreign_key: :user_id, type: :binary_id)

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(%Favorite{} = favorite, attrs) do
    favorite
    |> cast(attrs, [:status])
    |> validate_required([:status])
    |> foreign_key_constraint(:user_id)
    |> foreign_key_constraint(:listing_id)
    |> unique_constraint(:listing_id, name: :favorites_listing_id_user_id_index)
  end

  def remove_changeset(favorite, attrs) do
    favorite
    |> cast(attrs, [:status])
    |> validate_required([:status])
  end
end
