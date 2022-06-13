defmodule Letzell.Workers.CreateListing do
  alias Letzell.Listings.Listing
  alias Letzell.Accounts.User
  alias Letzell.Reviews.Review
  alias Letzell.{Listings, Accounts, Repo, Meta}
  import Ecto.Query, warn: false

  def run do
    Application.ensure_all_started(:inets)
    listing_images_url = "#{LetzellWeb.Endpoint.url()}/uploads/seed/listings"
    categories = Meta.list_lookups("Category") |> Enum.map(fn category -> category.lookup_code end)
    photo_count = Enum.random(1..10)

    categories
    |> Stream.map(fn category ->
      1..250
      |> Enum.map(fn image ->
        case :httpc.request(:get, {'https://source.unsplash.com/random/?#{category}', []}, [], body_format: :binary) do
          {:ok, resp} ->
            {{_, 200, 'OK'}, _headers, body} = resp
            File.write!("/var/www/apps/letzell-ts/backend/priv/static/uploads/seed/listings/#{category}-#{image}.jpg", body)
            category = Meta.list_lookups("Category") |> Enum.random()
            condition = Meta.list_lookups("Condition") |> Enum.random()
            user = Repo.all(User) |> Enum.random()
            title = category.description <> " - " <> Faker.Lorem.sentence()
            price_per_unit = Enum.random(15..140)
            no_of_units = Enum.random(1..10)

            %Listing{
              owner: user,
              title: title,
              slug: Slug.slugify(title),
              description: Faker.Lorem.paragraph(4),
              category: category.lookup_code,
              condition: condition.lookup_code,
              location: Faker.Address.city() <> "," <> Faker.Address.state_abbr(),
              price_per_unit: price_per_unit,
              no_of_units: no_of_units,
              photo_urls:
                1..photo_count
                |> Enum.map(fn _x ->
                  image = Enum.random(1..999)
                  "#{listing_images_url}/#{category.lookup_code}-#{image}.jpg"
                end)
            }
            |> Repo.insert()

          {:error, _} ->
            :ok
        end
      end)
    end)
    |> Enum.to_list()
  end
end
