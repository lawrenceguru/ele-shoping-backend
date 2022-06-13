defmodule LetzellWeb.Queries.MetaQueries do
  use Absinthe.Schema.Notation
  alias Letzell.{LookupRepo, Meta}
  alias Letzell.Meta.Lookup
  alias Letzell.PostalCode.Store

  import Ecto.Query, warn: false
  alias Letzell.Repo

  object :lookup_queries do
    @desc "fetch a User by id"
    field :lookups, list_of(:lookup) do
      arg(:keywords, non_null(:string))

      resolve(fn args, _ ->
        lookups = Meta.list_lookups(args[:keywords])

        {:ok, lookups}
      end)
    end

    @desc "fetch location details for a postalcode"
    field :location_details, :loc_details do
      arg(:postal_code, non_null(:string))

      resolve(fn args, _ ->
        location = Meta.get_geolocation(args[:postal_code])

        {:ok, location}
      end)
    end
  end
end
