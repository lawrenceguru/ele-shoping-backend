defmodule Letzell.Messages.Contact do
  use Ecto.Schema
  import Ecto.Changeset
  alias Letzell.Accounts.User
  alias Letzell.Listings.Listing
  alias Letzell.Messages.Message

  @primary_key {:id, :binary_id, autogenerate: true}
  schema "contacts" do
    field :deleted_at, :naive_datetime
    field :reciprocal, :string

    belongs_to :sender, User, foreign_key: :sender_id, type: :binary_id
    belongs_to :receiver, User, foreign_key: :receiver_id, type: :binary_id
    belongs_to :listing, Listing, foreign_key: :listing_id, type: :binary_id

    has_many :messages, Message

    timestamps(type: :utc_datetime)
  end

  def changeset(contacts, attrs) do
    required_fields = [:sender_id, :receiver_id, :listing_id]
    optional_fields = [:deleted_at, :reciprocal]

    contacts
    |> cast(attrs, required_fields ++ optional_fields)
    |> validate_required(required_fields)
    |> foreign_key_constraint(:listing_id)
    |> foreign_key_constraint(:sender_id)
    |> foreign_key_constraint(:receiver_id)
    |> unique_constraint([:sender_id, :receiver_id, :listing_id])
  end
end
