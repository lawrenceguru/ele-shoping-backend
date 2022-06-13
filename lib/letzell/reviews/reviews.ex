defmodule Letzell.Reviews do
  import Ecto.Query, warn: false
  import Ecto.Changeset, only: [put_assoc: 3]
  alias Letzell.Repo
  alias Letzell.Reviews.Review
  alias Letzell.Accounts.User

  def create_review(user, author, attrs) do
    %Review{}
    |> Review.changeset(attrs)
    |> put_assoc(:user, user)
    |> put_assoc(:author, user)
    |> Repo.insert()
  end

  def review_stats(user_id) do
    query =
      from r in Review,
        where: r.user_id == ^user_id,
        select: %{total_reviews: count(r.user_id), average_review: avg(r.rating)}

    review_stats = query |> Repo.one() |> IO.inspect()

    avg_review_temp =
      case review_stats.average_review do
        nil ->
          review_stats.average_review

        _ ->
          review_stats.average_review
          |> Decimal.round(2)
          |> Decimal.to_float()
      end

    review_stats = Map.replace(review_stats, :average_review, avg_review_temp) |> IO.inspect()
  end

  def review_count(user_id) do
    query =
      from r in Review,
        where: r.user_id == ^user_id

    reviews_count = Repo.count(query)
  end

  def average_review(user_id) do
    query =
      from r in Review,
        where: r.user_id == ^user_id

    average_review =
      Repo.aggregate(
        query,
        :avg,
        :rating
      )
      |> Decimal.round(2)
      |> Decimal.to_string()
  end

  # User Reviews
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
