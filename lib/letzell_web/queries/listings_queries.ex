defmodule LetzellWeb.Queries.ListingsQueries do
  use Absinthe.Schema.Notation
  alias LetzellWeb.Schema.Middleware
  import Ecto.Query, warn: false

  alias Letzell.Repo
  alias Letzell.Listings
  alias Letzell.Meta
  alias Letzell.Favorites.Favorite
  alias Letzell.Listings.Listing

  object :listings_queries do
    @desc "get list of listings "
    field :listings, list_of(:listing) do
      arg(:limit, :integer, default_value: 30)
      arg(:offset, :integer, default_value: 0)
      arg(:keywords, :string, default_value: nil)

      resolve(fn args, _ ->
        listings =
          Task.async(fn ->
            Listing
            |> Listings.search(args[:keywords])
            |> order_by(desc: :inserted_at)
            |> Repo.paginate(args[:limit], args[:offset])
            |> Repo.all()
          end)
          |> Task.await()

        {:ok, listings}
      end)
    end

    @desc "extended search of listings "
    field :search_listings, list_of(:listing) do
      arg(:limit, :integer, default_value: 30)
      arg(:offset, :integer, default_value: 0)
      arg(:category, :string, default_value: nil)
      arg(:condition, :string, default_value: nil)
      arg(:location, :string, default_value: nil)
      arg(:radius, :integer, default_value: nil)
      arg(:price_from, :integer, default_value: nil)
      arg(:price_to, :integer, default_value: nil)

      resolve(fn args, _ ->
        listings =
          Task.async(fn ->
            Listing
            |> Listings.extended_search(args)
            |> Repo.all()
          end)
          |> Task.await()

        {:ok, listings}
      end)
    end

    @desc "get category listings "
    field :category_listings, list_of(:listing) do
      arg(:limit, :integer, default_value: 30)
      arg(:offset, :integer, default_value: 0)
      arg(:category, :string, default_value: nil)

      resolve(fn args, _ ->
        listings =
          Task.async(fn ->
            Listing
            |> Listings.category(args[:category])
            |> order_by(desc: :inserted_at)
            |> Repo.paginate(args[:limit], args[:offset])
            |> Repo.all()
          end)
          |> Task.await()

        {:ok, listings}
      end)
    end

    @desc "get related of listings "
    field :related_listings, list_of(:listing) do
      arg(:listing_id, :string, default_value: nil)
      arg(:category, :string, default_value: nil)
      arg(:location, :string, default_value: nil)

      resolve(fn args, _ ->
        listings =
          Task.async(fn ->
            Listing
            |> Listings.related(args[:listing_id], args[:category], args[:location])
            |> Repo.all()
          end)
          |> Task.await()

        {:ok, listings}
      end)
    end

    @desc "get listings of a user "
    field :user_listings, list_of(:listing) do
      arg(:limit, :integer, default_value: 30)
      arg(:offset, :integer, default_value: 0)
      arg(:user_id, :string, default_value: nil)

      resolve(fn args, _ ->
        listings =
          Task.async(fn ->
            Listing
            |> Listings.user(args[:user_id])
            |> order_by(desc: :inserted_at)
            |> Repo.paginate(args[:limit], args[:offset])
            |> Repo.all()
          end)
          |> Task.await()

        {:ok, listings}
      end)
    end

    @desc "Number of listings"
    field :listings_count, :integer do
      arg(:keywords, :string, default_value: nil)

      resolve(fn args, _ ->
        listings_count =
          Task.async(fn ->
            Listing
            |> Listings.search(args[:keywords])
            |> Repo.count()
          end)
          |> Task.await()

        {:ok, listings_count}
      end)
    end

    @desc "fetch a Listing by id"
    field :listing, :listing do
      arg(:id, non_null(:id))

      resolve(fn args, _ ->
        listing = Listing |> Repo.get!(args[:id])
        {:ok, listing}
      end)
    end

    @desc "listing not stored with default value"
    field :listing_with_default_value, :listing do
      resolve(fn _, _ ->
        {:ok, Listing.default_values()}
      end)
    end

    @desc "listing options for a field"
    field :listing_options, list_of(:option) do
      arg(:field, non_null(:string))

      resolve(fn args, _ ->
        # field = String.to_existing_atom(args[:field])

        # Enum.map(Listing.options()[field], fn opt ->
        #   %{label: opt, value: opt}
        # end)
        options =
          Task.async(fn ->
            Meta.list_lookups(args[:field])
            |> Enum.map(fn opt ->
              %{label: opt.description, group: opt.lookup_group, value: opt.lookup_code}
            end)
          end)
          |> Task.await()

        {:ok, options}
      end)
    end
  end
end
