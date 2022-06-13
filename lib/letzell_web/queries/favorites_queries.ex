defmodule LetzellWeb.Queries.FavoritesQueries do
  use Absinthe.Schema.Notation
  alias LetzellWeb.Schema.Middleware
  import Ecto.Query, warn: false

  alias Letzell.{Repo, Listings, Meta, Favorites}
  alias Letzell.Favorites.Favorite
  alias Letzell.Listings.Listing

  object :favorites_queries do
    @desc "Is Listing Favorite?"
    field :is_favorite, :favorite do
      arg(:user_id, non_null(:string))
      arg(:listing_id, non_null(:string))

      resolve(fn args, _ ->
        favorite =
          Favorite
          |> Favorites.is_favorite(args[:user_id], args[:listing_id])
          |> Repo.one()

        {:ok, favorite}
      end)
    end

    @desc "Favorites of Listings for a user"
    field :user_favorites, list_of(:favorite) do
      arg(:user_id, non_null(:string))
      arg(:limit, :integer, default_value: 30)
      arg(:offset, :integer, default_value: 0)

      resolve(fn args, _ ->
        favorites =
          Favorite
          |> Favorites.user(args[:user_id])
          |> order_by(desc: :inserted_at)
          |> Repo.paginate(args[:limit], args[:offset])
          |> Repo.all()

        {:ok, favorites}
      end)
    end
  end
end
