defmodule LetzellWeb.Mutations.FavoritesMutations do
  use Absinthe.Schema.Notation
  import Ecto.Query, warn: false
  import LetzellWeb.Helpers.ValidationMessageHelpers

  alias LetzellWeb.Schema.Middleware
  alias Letzell.Repo
  alias Letzell.Listings
  alias Letzell.Listings.Listing
  alias Letzell.Favorites
  alias Letzell.Favorites.Favorite

  object :favorites_mutations do
    @desc "Create a favorite"
    field :create_favorite, :favorite_payload do
      arg(:listing_id, non_null(:id))
      middleware(Middleware.Authorize)

      resolve(fn args, %{context: context} ->
        listing = Listings.get_listing(args[:listing_id])

        case context[:current_user] |> Favorites.create(listing, args) do
          {:ok, favorite} -> {:ok, favorite}
          {:error, %Ecto.Changeset{} = changeset} -> {:ok, changeset}
        end
      end)
    end

    @desc "Remove a favorite"
    field :remove_favorite, :favorite_payload do
      arg(:favorite_id, non_null(:id))
      middleware(Middleware.Authorize)

      resolve(fn args, %{context: context} ->
        favorite =
          Favorite
          |> preload(:user)
          |> Favorites.is_favorite(context[:current_user].id, args[:favorite_id])
          |> Repo.one()

        case Favorites.is_owner(context[:current_user], favorite) do
          true -> favorite |> Favorites.delete()
          {:error, msg} -> {:ok, generic_message(msg)}
        end
      end)
    end
  end
end
