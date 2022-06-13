alias Letzell.Listings.Listing
alias Letzell.Accounts.User
alias Letzell.Reviews.Review
alias Letzell.Recipes.Recipe
alias Letzell.Recipes.Comment
alias Letzell.PostalCode.{DataParser, Store, Navigator}
alias Letzell.{Listings, Accounts, Recipes, Repo, Repo, Meta}
alias Letzell.Meta.Lookup
import Ecto.Query, warn: false

listing_images_url = "#{LetzellWeb.Endpoint.url()}/uploads/seed/listings"

Recipe |> Repo.delete_all()

1..2500 |> Task.async_stream( fn recipe ->
user = Repo.all(User) |> Enum.random
receiver = Repo.all(User) |> Enum.random
image = Enum.random(1..50)
comments = Enum.random(5..50)

{:ok, recipe} = %Recipe{
          author: user,
          title: Faker.Lorem.paragraph(1),
          total_time: "30 min",
          level: "Facile",
          budget: "Bon marché",
          content: Faker.Lorem.paragraph(4),
          image_url: ["#{listing_images_url}/food-#{image}.jpg"]
        } |> Repo.insert

1..comments |> Enum.map( fn comment ->
  # Sender message
  %Comment{
    sender: user,
    receiver: receiver,
    recipe: recipe,
    body: Faker.Lorem.paragraph(2)
  } |> Repo.insert

  # Receiver Reply.
  %Comment{
    sender: receiver,
    receiver: user,
    recipe: recipe,
    body: Faker.Lorem.paragraph(2)
  } |> Repo.insert
end)

end, max_concurrency: 10,timeout: :infinity) |> Enum.to_list
