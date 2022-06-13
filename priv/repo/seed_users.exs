alias Letzell.Listings.Listing
alias Letzell.Accounts.User
alias Letzell.Reviews.Review
alias Letzell.Recipes.Recipe
alias Letzell.Recipes.Comment
alias Letzell.PostalCode.{DataParser, Store, Navigator}
alias Letzell.{Listings, Accounts, Recipes, Repo, Repo, Meta}
alias Letzell.Meta.Lookup
import Ecto.Query, warn: false

# Application.ensure_all_started :inets

listing_images_url = "#{LetzellWeb.Endpoint.url()}/uploads/seed/listings"
profile_images_url = "#{LetzellWeb.Endpoint.url()}/uploads/seed/profiles"
place_images_url = "#{LetzellWeb.Endpoint.url()}/images"

images_path = Letzell.ReleaseTasks.priv_path_for(Letzell.Repo, "images")

Repo.delete_all(User)

1..100 |> Task.async_stream( fn x ->
  s = for _ <- 1..6, into: "a", do: <<Enum.random('0123456789abcdefghijklmnopqrstuvwxyz')>>
  {:ok, unconfirmed_user} = Accounts.create_user(%{first_name: Faker.Person.first_name, last_name: Faker.Person.last_name,
                  email: "user#{s}"<>Faker.Internet.email, primary_phone: Faker.Phone.EnUs.phone, postal_code: Store.random_postal_code})
  {:ok, code, user_with_code} = Letzell.Confirmations.generate_confirmation_code(unconfirmed_user)
  {:ok, user} = Letzell.Confirmations.confirm_account(user_with_code, code)

  image = Enum.random(1..250)
  gender = Enum.random(["male","female"])
  photo_url = "#{gender}-profile-#{image}.jpg"
  end, max_concurrency: 10,timeout: :infinity) |> Enum.to_list

  {:ok, unconfirmed_user} = Accounts.create_user(%{first_name: "Jose", last_name: "Doe", email: "Jose@letzell.com", primary_phone: Faker.Phone.EnUs.phone,
  postal_code: Store.random_postal_code})
  {:ok, code, user_with_code} = Letzell.Confirmations.generate_confirmation_code(unconfirmed_user)
  {:ok, user} = Letzell.Confirmations.confirm_account(user_with_code, code)

  {:ok, unconfirmed_user} = Accounts.create_user(%{first_name: Faker.Person.first_name, last_name: Faker.Person.last_name, postal_code: Store.random_postal_code, email: "VENKAT@example.com", primary_phone: Faker.Phone.EnUs.phone})
  {:ok, code, user_with_code} = Letzell.Confirmations.generate_confirmation_code(unconfirmed_user)
  {:ok, venkat} = Letzell.Confirmations.confirm_account(user_with_code, code)

  {:ok, unconfirmed_user} = Accounts.create_user(%{first_name: Faker.Person.first_name, last_name: Faker.Person.last_name, postal_code: Store.random_postal_code, email: "shreya@EXAMPLE.com", primary_phone: Faker.Phone.EnUs.phone})
  {:ok, code, user_with_code} = Letzell.Confirmations.generate_confirmation_code(unconfirmed_user)
  {:ok, shreya} = Letzell.Confirmations.confirm_account(user_with_code, code)

  {:ok, unconfirmed_user} = Accounts.create_user(%{first_name: Faker.Person.first_name, last_name: Faker.Person.last_name, postal_code: Store.random_postal_code, email: "Shravan@example.com", primary_phone: Faker.Phone.EnUs.phone})
  {:ok, code, user_with_code} = Letzell.Confirmations.generate_confirmation_code(unconfirmed_user)
  {:ok, shravan} = Letzell.Confirmations.confirm_account(user_with_code, code)

  {:ok, unconfirmed_user} = Accounts.create_user(%{first_name: Faker.Person.first_name, last_name: Faker.Person.last_name, postal_code: Store.random_postal_code, email: "Hema@example.com", primary_phone: Faker.Phone.EnUs.phone})
  {:ok, code, user_with_code} = Letzell.Confirmations.generate_confirmation_code(unconfirmed_user)
  {:ok, hema} = Letzell.Confirmations.confirm_account(user_with_code, code)

  {:ok, unconfirmed_user} = Accounts.create_user(%{first_name: Faker.Person.first_name, last_name: Faker.Person.last_name, postal_code: Store.random_postal_code, email: "bruno@example.com", primary_phone: Faker.Phone.EnUs.phone})
  {:ok, code, user_with_code} = Letzell.Confirmations.generate_confirmation_code(unconfirmed_user)
  {:ok, bruno} = Letzell.Confirmations.confirm_account(user_with_code, code)

  {:ok, unconfirmed_user} = Accounts.create_user(%{first_name: Faker.Person.first_name, last_name: Faker.Person.last_name, postal_code: Store.random_postal_code, email: "bingo@example.com", primary_phone: Faker.Phone.EnUs.phone})
  {:ok, code, user_with_code} = Letzell.Confirmations.generate_confirmation_code(unconfirmed_user)
  {:ok, bingo} = Letzell.Confirmations.confirm_account(user_with_code, code)

  {:ok, unconfirmed_user} = Accounts.create_user(%{first_name: Faker.Person.first_name, last_name: Faker.Person.last_name, postal_code: Store.random_postal_code, email: "mikE@example.com", primary_phone: Faker.Phone.EnUs.phone})
  {:ok, code, user_with_code} = Letzell.Confirmations.generate_confirmation_code(unconfirmed_user)
  {:ok, mike} = Letzell.Confirmations.confirm_account(user_with_code, code)

  {:ok, unconfirmed_user} = Accounts.create_user(%{first_name: Faker.Person.first_name, last_name: Faker.Person.last_name, postal_code: Store.random_postal_code, email: "nicole@example.com", primary_phone: Faker.Phone.EnUs.phone})
  {:ok, code, user_with_code} = Letzell.Confirmations.generate_confirmation_code(unconfirmed_user)
  {:ok, nicole} = Letzell.Confirmations.confirm_account(user_with_code, code)

  {:ok, unconfirmed_user} = Accounts.create_user(%{first_name: Faker.Person.first_name, last_name: Faker.Person.last_name, postal_code: Store.random_postal_code, email: "beachbum@example.com", primary_phone: Faker.Phone.EnUs.phone})
  {:ok, code, user_with_code} = Letzell.Confirmations.generate_confirmation_code(unconfirmed_user)
  {:ok, beachbum} = Letzell.Confirmations.confirm_account(user_with_code, code)


  Repo.all(User) |> Task.async_stream( fn user ->
  reviews = Enum.random(1..20)

  1..reviews |> Enum.map( fn _review ->
      body = Faker.Lorem.sentence
      rating = Enum.random(0..5)
      author = Repo.all( from u in User, where: u.id != ^user.id ) |> Enum.random

      %Review{
        user: user,
        author: author,
        body: body,
        rating: rating
      } |> Repo.insert

    end)
  end, max_concurrency: 25,timeout: :infinity) |> Enum.to_list

1..100 |> Task.async_stream( fn x ->
s = for _ <- 1..2, into: "a", do: <<Enum.random('0123456789abcdefghijklmnopqrstuvwxyz')>>
{:ok, unconfirmed_user} = Accounts.create_user(%{first_name: Faker.Person.first_name, last_name: Faker.Person.last_name,
                email: "user#{s}"<>Faker.Internet.email, primary_phone: Faker.Phone.EnUs.phone, postal_code: Store.random_postal_code})
{:ok, code, user_with_code} = Letzell.Confirmations.generate_confirmation_code(unconfirmed_user)
{:ok, user} = Letzell.Confirmations.confirm_account(user_with_code, code)
end, max_concurrency: 10,timeout: :infinity) |> Enum.to_list

Repo.all(User) |> Task.async_stream( fn user ->
reviews = Enum.random(1..5)

1..reviews |> Enum.map( fn _review ->
    body = Faker.Lorem.sentence
    rating = Enum.random(0..5)
    author = Repo.all( from u in User, where: u.id != ^user.id ) |> Enum.random

    %Review{
      user: user,
      author: author,
      body: body,
      rating: rating
    } |> Repo.insert

  end)
end, max_concurrency: 25,timeout: :infinity) |> Enum.to_list
