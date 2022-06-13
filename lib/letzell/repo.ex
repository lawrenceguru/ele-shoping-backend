defmodule Letzell.Repo do
  use Ecto.Repo,
    otp_app: :letzell,
    adapter: Ecto.Adapters.Postgres

  import Ecto.Query, warn: false
  @per_page 30

  @doc """
  Dynamically loads the repository url from the
  DATABASE_URL environment variable.
  """
  defoverridable get: 2, get: 3

  def get(query, id, opts \\ []) do
    super(query, id, opts)
  rescue
    Ecto.Query.CastError -> nil
  end

  def init(_, opts) do
    {:ok, Keyword.put(opts, :url, System.get_env("DATABASE_URL"))}
  end

  def count(query) do
    one(from(r in query, select: count("*")))
  end

  def random(query) do
    one(from(r in query, order_by: fragment("RANDOM()"), limit: 1))
  end

  def paginate(query, limit, offset) do
    from(r in query, offset: ^offset, limit: ^limit)
  end

  def fetch(query) do
    case all(query) do
      [] -> {:error, query}
      [obj] -> {:ok, obj}
    end
  end
end
