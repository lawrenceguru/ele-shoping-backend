alias Letzell.Listings.Listing
alias Letzell.Accounts.User
alias Letzell.Reviews.Review
alias Letzell.Recipes.Recipe
alias Letzell.Recipes.Comment
alias Letzell.PostalCode.{DataParser, Store, Navigator}
alias Letzell.{Listings, Accounts, Recipes, Repo, Repo, Meta}
alias Letzell.Meta.Lookup
import Ecto.Query, warn: false

listing_images_url = "#{LetzellWeb.Endpoint.url()}/images/seed/listings"
filebase_upload_url = "https://s3.filebase.com/letzell/seed"
backblaze2_upload_url = "https://s3.us-west-004.backblazeb2.com/letzell"

# Repo.delete_all(Listing)

1..5000 |> Task.async_stream( fn item ->
  photo_count = Enum.random(1..5)
  category = Meta.list_lookups("Category") |> Enum.random
  condition = Meta.list_lookups("Condition")  |> Enum.random
  user = Repo.all(User) |> Enum.random
  title = category.description <> " - " <> Faker.Lorem.sentence
  price_per_unit = Enum.random(15..1000)
  no_of_units = Enum.random(1..10)
  location = Store.random_postal_code
  location_details = Store.get_geolocation(location)
  %Listing{
    owner: user,
    title: title,
    slug: Slug.slugify(title),
    description: Faker.Lorem.paragraph(4),
    category: category.lookup_code,
    condition: condition.lookup_code,
    location: location,
    place_name: location_details.place_name,
    state_code: location_details.state_code,
    location_details: Store.get_geolocation(location),
    price_per_unit: price_per_unit,
    no_of_units: no_of_units,
    photo_urls: 1..photo_count |> Enum.map(fn _x ->
                                          image = Enum.random(1..50)
                                          "#{backblaze2_upload_url}/#{category.lookup_code}/#{category.lookup_code}-#{image}.jpg"
                                        end)
  } |> Repo.insert
end, max_concurrency: 20,timeout: :infinity) |> Enum.to_list
