defmodule Letzell.Reviews.Review do
  use Ecto.Schema
  import Ecto.Changeset
  alias Letzell.Accounts.User
  alias Letzell.Reviews.Review
  alias Letzell.Schema

  @primary_key {:id, :binary_id, autogenerate: true}
  schema "reviews" do
    field(:body, :string)
    field(:rating, :integer)
    belongs_to(:user, User, foreign_key: :user_id, type: :binary_id)
    belongs_to(:author, User, foreign_key: :author_id, type: :binary_id)

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(%Review{} = review, attrs) do
    review
    |> cast(attrs, [:rating, :body])
    |> validate_required([:rating, :body])
    |> foreign_key_constraint(:user_id)
    |> foreign_key_constraint(:author_id)
  end
end
