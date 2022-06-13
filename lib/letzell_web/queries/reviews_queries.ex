defmodule LetzellWeb.Queries.ReviewsQueries do
  use Absinthe.Schema.Notation
  alias LetzellWeb.Schema.Middleware
  import Ecto.Query, warn: false

  alias Letzell.Repo
  alias Letzell.Reviews
  alias Letzell.Reviews.Review

  object :reviews_queries do
    @desc "Number of Reviews and Average Review for a user"
    field :user_review_stats, :review_stats do
      arg(:user_id, non_null(:string))

      resolve(fn args, _ ->
        review_stats =
          args[:user_id]
          |> Reviews.review_stats()

        IO.inspect(review_stats)

        {:ok, review_stats}
      end)
    end

    @desc "Reviews for a user"
    field :user_reviews, list_of(:review) do
      arg(:user_id, non_null(:string))
      arg(:limit, :integer, default_value: 30)
      arg(:offset, :integer, default_value: 0)

      resolve(fn args, _ ->
        IO.inspect(args)

        reviews =
          Review
          |> Letzell.Reviews.user(args[:user_id])
          |> order_by(desc: :inserted_at)
          |> Repo.paginate(args[:limit], args[:offset])
          |> Repo.all()

        {:ok, reviews}
      end)
    end
  end
end
