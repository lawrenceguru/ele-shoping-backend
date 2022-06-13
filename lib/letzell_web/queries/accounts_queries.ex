defmodule LetzellWeb.Queries.AccountsQueries do
  use Absinthe.Schema.Notation
  alias Letzell.Accounts.User
  alias Letzell.Reviews.Review
  alias LetzellWeb.Schema.Middleware

  import Ecto.Query, warn: false
  alias Letzell.Repo

  object :accounts_queries do
    @desc "fetch a User by id"
    field :user_details, :user do
      arg(:id, non_null(:id))

      resolve(fn args, _ ->
        user = User |> Letzell.Repo.get(args[:id])
        {:ok, user}
      end)
    end

    @desc "get user favorites"
    field :user_favorites, list_of(:favorite) do
      arg(:limit, :integer, default_value: 30)
      arg(:offset, :integer, default_value: 0)
      middleware(Middleware.Authorize)

      resolve(fn args, %{context: context} ->
        IO.inspect(args)
        IO.inspect(context)

        {:ok, nil}
      end)
    end

    @desc "get user reviews"
    field :reviews, list_of(:recipe) do
      arg(:limit, :integer, default_value: 30)
      arg(:offset, :integer, default_value: 0)
      arg(:keywords, :string, default_value: nil)

      resolve(fn args, _ ->
        recipes =
          Task.async(fn ->
            Recipe
            |> Recipes.search(args[:keywords])
            |> order_by(desc: :inserted_at)
            |> Repo.paginate(args[:limit], args[:offset])
            |> Repo.all()
          end)
          |> Task.await()

        {:ok, recipes}
      end)
    end

    @desc "Number of reviews for a user"
    field :total_reviews, :integer do
      arg(:user_id, non_null(:id))

      resolve(fn args, _ ->
        query =
          from r in Review,
            where: r.author_id == ^args[:user_id]

        reviews_count =
          Task.async(fn ->
            Repo.count(query)
          end)
          |> Task.await()

        {:ok, reviews_count}
      end)
    end

    @desc "Average review for a user"
    field :average_review, :string do
      arg(:user_id, non_null(:id))

      resolve(fn args, _ ->
        query =
          from r in Review,
            where: r.author_id == ^args[:user_id]

        average_review =
          Task.async(fn ->
            Repo.aggregate(
              query,
              :avg,
              :rating
            )
            |> Decimal.round(2)
            |> Decimal.to_string()
          end)
          |> Task.await()

        {:ok, average_review}
      end)
    end

    @desc "fetch a User by id"
    field :users, list_of(:user) do
      arg(:limit, :integer, default_value: 30)
      arg(:offset, :integer, default_value: 0)

      resolve(fn args, _ ->
        users =
          User
          |> order_by(desc: :inserted_at)
          |> Repo.paginate(args[:limit], args[:offset])
          |> Repo.all()

        {:ok, users}
      end)
    end

    @desc "Fetch the current user"
    field :current_user, :user do
      resolve(fn _, %{context: context} ->
        {:ok, context[:current_user]}
      end)
    end
  end
end
