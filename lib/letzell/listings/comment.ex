defmodule Letzell.Listings.Comment do
  use Ecto.Schema
  import Ecto.Changeset
  alias Letzell.Listings.{Comment, Listing}
  alias Letzell.Accounts.User
  alias Letzell.Schema

  @primary_key {:id, :binary_id, autogenerate: true}
  schema "listing_comments" do
    field(:body, :string)
    belongs_to(:listing, Listing, type: :binary_id)
    belongs_to(:author, User, foreign_key: :user_id, type: :binary_id)

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(%Comment{} = comment, attrs) do
    comment
    |> cast(attrs, [:body])
    |> validate_required([:body])
    |> foreign_key_constraint(:listing_id)
    |> foreign_key_constraint(:user_id)
  end
end
