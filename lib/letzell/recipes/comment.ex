defmodule Letzell.Recipes.Comment do
  use Ecto.Schema
  import Ecto.Changeset
  alias Letzell.Recipes.{Comment, Recipe}
  alias Letzell.Accounts.User
  alias Letzell.Schema

  @primary_key {:id, :binary_id, autogenerate: true}
  schema "comments" do
    field(:body, :string)
    belongs_to(:recipe, Recipe, type: :binary_id)
    belongs_to(:sender, User, foreign_key: :sender_id, type: :binary_id)
    belongs_to(:receiver, User, foreign_key: :receiver_id, type: :binary_id)

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(%Comment{} = comment, attrs) do
    comment
    |> cast(attrs, [:body])
    |> validate_required([:body])
    |> foreign_key_constraint(:recipe_id)
    |> foreign_key_constraint(:sender_id)
    |> foreign_key_constraint(:receiver_id)
  end
end
