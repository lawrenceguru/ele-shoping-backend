defmodule LetzellWeb.Queries.RecipesQueries do
  use Absinthe.Schema.Notation

  import Ecto.Query, warn: false

  alias Letzell.Repo
  alias Letzell.Recipes
  alias Letzell.Recipes.Recipe

  object :recipes_queries do
    @desc "get recipes list"
    field :recipes, list_of(:recipe) do
      arg(:limit, :integer, default_value: 30)
      arg(:offset, :integer, default_value: 0)
      arg(:keywords, :string, default_value: nil)

      resolve(fn args, _ ->
        recipes =
          Recipe
          |> Recipes.search(args[:keywords])
          |> order_by(desc: :inserted_at)
          |> Repo.paginate(args[:limit], args[:offset])
          |> Repo.all()

        {:ok, recipes}
      end)
    end

    @desc "Number of recipes"
    field :recipes_count, :integer do
      arg(:keywords, :string, default_value: nil)

      resolve(fn args, _ ->
        recipes_count =
          Recipe
          |> Recipes.search(args[:keywords])
          |> Repo.count()

        {:ok, recipes_count}
      end)
    end

    @desc "fetch a Recipe by id"
    field :recipe, :recipe do
      arg(:id, non_null(:id))

      resolve(fn args, _ ->
        recipe = Recipe |> Repo.get(args[:id])
        {:ok, recipe}
      end)
    end

    @desc "recipe not stored with default value"
    field :recipe_with_default_value, :recipe do
      resolve(fn _, _ ->
        {:ok, Recipe.default_values()}
      end)
    end

    @desc "recipe options for a field"
    field :recipe_options, list_of(:option) do
      arg(:field, non_null(:string))

      resolve(fn args, _ ->
        field = String.to_existing_atom(args[:field])

        options =
          Enum.map(Recipe.options()[field], fn opt ->
            %{label: opt, value: opt}
          end)

        {:ok, options}
      end)
    end
  end
end
