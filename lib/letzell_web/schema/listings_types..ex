defmodule LetzellWeb.Schema.ListingsTypes do
  use Absinthe.Schema.Notation
  import Absinthe.Resolution.Helpers

  alias LetzellWeb.Helpers.StringHelpers
  alias Letzell.Listings
  alias Letzell.Listings.Listing
  alias Letzell.ImageUploader
  alias Letzell.Accounts
  alias Letzell.Favorites
  alias Letzell.Meta

  @desc "A Listing with title and content for a user"
  object :listing do
    field(:id, :id)
    field(:slug, :string)
    field(:title, :string)
    field(:inserted_at, :string)
    field(:description, :string)
    field(:price_per_unit, :integer)
    field(:no_of_units, :integer)
    field(:category, :string)
    field :category_description, :string do
        resolve(fn listing, _, _ ->
          {:ok, Meta.get_lookup_description("Category", listing.category)}
        end)
    end
    field(:condition, :string)
    field :condition_description, :string do
        resolve(fn listing, _, _ ->
          {:ok, Meta.get_lookup_description("Condition", listing.condition)}
        end)
    end
    field(:photo_urls, list_of(:string))
    field(:location, :string)
    field(:location_details, :loc_details) do
      resolve(fn listing, _, _ ->
        loc_details =
          case listing.location_details do
            nil ->
              %{}
            _ ->
              for {key, val} <- listing.location_details, into: %{} do
                case is_atom(key) do
                  true -> {key, val}
                  _ -> {String.to_atom(key), val}
                end
              end
          end

        {:ok, loc_details}
      end)
    end
    field(:status, :string)
    field(:owner_id, :string)
    field(:owner, :owner, resolve: dataloader(Listings))
  end

  @desc "Owner"
  object :owner do
    field(:id, :id)
    field(:first_name, :string)
    field(:last_name, :string)
    field(:inserted_at, :datetime)
    field(:favorites, list_of(:favorite), resolve: dataloader(Accounts))
    field(:reviews, list_of(:review), resolve: dataloader(Accounts))
  end

end
