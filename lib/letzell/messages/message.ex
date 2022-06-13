defmodule Letzell.Messages.Message do
  use Ecto.Schema
  import Ecto.Changeset
  alias Letzell.Accounts.User
  alias Letzell.Listings.Listing
  alias Letzell.Messages.Contact

  @primary_key {:id, :binary_id, autogenerate: true}
  schema "messages" do
    field :deleted_at, :naive_datetime
    field :read_at, :naive_datetime
    field :body, :string

    # belongs_to :contact, Contact, type: :binary_id
    belongs_to :sender, User, foreign_key: :sender_id, type: :binary_id
    belongs_to :receiver, User, foreign_key: :receiver_id, type: :binary_id
    belongs_to :listing, Listing, foreign_key: :listing_id, type: :binary_id

    timestamps(type: :utc_datetime)
  end

  def changeset(message, attrs) do
    required_fields = [:body]

    message
    |> cast(attrs, required_fields)
    |> validate_required(required_fields)
    |> assoc_constraint(:listing)
    |> assoc_constraint(:sender)
    |> assoc_constraint(:receiver)
  end
end
