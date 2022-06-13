defmodule Letzell.Listings.Listing do
  use Ecto.Schema
  alias Letzell.Meta
  import Ecto.Changeset
  alias Letzell.Schema
  alias Letzell.Meta
  alias Letzell.PostalCode.Store

  @default_values %{
    condition: "new",
    category: "mobile-phones"
  }

  @primary_key {:id, :binary_id, autogenerate: true}
  schema "listings" do
    field :slug, :string
    field :category, :string
    field :condition, :string
    field :description, :string
    field :firm_on_price, :string
    field :photo_urls, {:array, :string}, default: []
    field :location, :string
    field :place_name, :string
    field :state_code, :string
    field :location_details, :map
    field :price_per_unit, :integer
    field :no_of_units, :integer, default: 1
    field :title, :string
    field :uuid, :string
    field :status, :string, default: "open"

    has_many :favorites, Letzell.Favorites.Favorite
    belongs_to :owner, Letzell.Accounts.User, foreign_key: :user_id, type: :binary_id
    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(listing, attrs) do
    required_fields = [:title, :description, :category, :condition, :location, :price_per_unit]
    optional_fields = [:firm_on_price, :place_name, :state_code, :no_of_units, :slug, :photo_urls, :status]

    listing
    |> cast(attrs, required_fields ++ optional_fields)
    |> validate_required(required_fields)
    |> check_uuid
    |> validate_inclusion(:condition, Meta.list_lookups("Condition") |> Enum.map(fn condition -> condition.lookup_code end))
    |> validate_inclusion(:category, Meta.list_lookups("Category") |> Enum.map(fn category -> category.lookup_code end))
    |> validate_inclusion(:location, Meta.list_postal_codes |> Stream.map(fn x -> x.postal_code end) |> Enum.to_list)
    |> validate_inclusion(:status, ["open", "pending", "sold", "review"])
    |> unique_constraint(:slug)
    |> assoc_constraint(:owner)
    |> populate_slug()
    |> populate_location_details()
  end

  def default_values(), do: @default_values

  defp populate_slug(changeset) do
    name = get_field(changeset, :title) |> String.downcase() |> String.replace(" ", "-")
    slug = name <> "-" <> for _ <- 1..6, into: "", do: <<Enum.random('0123456789abcdef')>>
    put_change(changeset, :slug, slug)
  end

  defp check_uuid(changeset) do
    if get_field(changeset, :uuid) == nil do
      force_change(changeset, :uuid, Ecto.UUID.generate())
    else
      changeset
    end
  end

  defp populate_location_details(changeset) do
    postal_code = get_field(changeset, :location) |> IO.inspect
    location_details = Store.get_geolocation(postal_code)

    case location_details do
      nil -> put_change(changeset, :location_details, %{})
      _ -> put_change(changeset, :location_details, location_details)
           put_change(changeset, :place_name, location_details.place_name)
           put_change(changeset, :state_code, location_details.state_code)
    end

  end

end
