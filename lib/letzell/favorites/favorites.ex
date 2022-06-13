defmodule Letzell.Favorites do
  import Ecto.Query, warn: false
  import Ecto.Changeset, only: [put_assoc: 3]
  alias Letzell.Repo

  alias Letzell.Listings.Listing
  alias Letzell.Accounts.User
  alias Letzell.Favorites.Favorite

  def get_favorite!(id), do: Repo.get!(Favorite, id)

  def get_favorite(id), do: Repo.get!(Favorite, id)

  def create(user, listing, attrs) do
    %Favorite{}
    |> Favorite.changeset(attrs)
    |> put_assoc(:user, user)
    |> put_assoc(:listing, listing)
    |> Repo.insert()
  end

  @spec is_owner(User.t(), Favorite.t()) :: true | {:error, String.t()}
  def is_owner(%User{} = user, %Favorite{} = favorite) do
    if favorite.user.id == user.id do
      true
    else
      {:error, "Whoops!. This is not your favorite"}
    end
  end

  def delete(%Favorite{} = favorite) do
    {:ok, favorite} = favorite |> Repo.delete()
    {:ok, favorite}
  end

  # Is the listing a user favorite?
  def is_favorite(query, user_id, listing_id) do
    from(
      r in query,
      where:
        r.user_id == ^user_id and
          r.listing_id == ^listing_id
    )
  end

  # User Favorites
  def user(query, user_id) do
    from(
      r in query,
      where: r.user_id == ^user_id
    )
  end

  def data() do
    Dataloader.Ecto.new(Repo, query: &query/2)
  end

  def query(queryable, _) do
    queryable
  end
end
