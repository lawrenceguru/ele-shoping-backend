alias Letzell.Listings.Listing
alias Letzell.Accounts.User
alias Letzell.Favorites
alias Letzell.Favorites.Favorite
alias Letzell.Repo

users = Repo.all(User)
listings = Repo.all(Listing)

Repo.delete_all(Favorite)

1..500 |> Task.async_stream( fn item ->
  user = users |> Enum.random
  listing = listings |> Enum.random
  case Favorites.create(user,listing,%{status: "added"}) do
      {:ok, favorite} -> :ok
      {:error, _} -> :ok
  end
end, max_concurrency: 10,timeout: :infinity) |> Enum.to_list
