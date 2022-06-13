import Ecto.Query, warn: false
alias Letzell.{Meta, Repo,Accounts, Reviews, Favorites, Listings, PostalCode, Messages}
alias Letzell.PostalCode.{DataParser, Store, Navigator}
alias Letzell.Recipes.{Comment, Recipe}
alias Letzell.Listings.Listing
alias Letzell.Messages.{Contact, Message}
alias Letzell.Accounts.User
alias Letzell.Reviews.Review
alias Letzell.Favorites.Favorite
alias Letzell.Meta.{Lookup, PostalCode}

venkat = Repo.get_by(User, email_hash: "venkat@example.com")
sharavan = Repo.get_by(User, email_hash: "shravan@example.com")
shreya = Repo.get_by(User, email_hash: "shreya@example.com")
hema = Repo.get_by(User, email_hash: "hema@example.com")

listing1 = Repo.all(Listing) |> Enum.at(1)
listing2 = Repo.all(Listing) |> Enum.at(2)
