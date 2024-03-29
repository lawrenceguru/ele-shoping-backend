defmodule LetzellWeb.Mutations.RecipesMutations do
  use Absinthe.Schema.Notation
  import Ecto.Query, warn: false
  import LetzellWeb.Helpers.ValidationMessageHelpers

  alias LetzellWeb.Schema.Middleware
  alias Letzell.Repo
  alias Letzell.Recipes
  alias Letzell.Recipes.Recipe
  alias Letzell.Accounts.User

  input_object :recipe_input do
    field(:title, :string)
    field(:content, :string)
    field(:total_time, :string)
    field(:level, :string)
    field(:budget, :string)
    field(:remove_image, :boolean, default_value: false)
    field(:image, list_of(:upload))
  end

  object :recipes_mutations do
    @desc "Create a recipe"
    field :create_recipe, :recipe_payload do
      arg(:input, :recipe_input)
      middleware(Middleware.Authorize)

      resolve(fn %{input: params}, %{context: context} ->
        case context[:current_user] |> Recipes.create(params) do
          {:ok, recipe} -> {:ok, recipe}
          {:error, %Ecto.Changeset{} = changeset} -> {:ok, changeset}
        end
      end)
    end

    @desc "Update a Recipe and return Recipe"
    field :update_recipe, :recipe_payload do
      arg(:id, non_null(:id))
      arg(:input, :recipe_input)
      middleware(Middleware.Authorize)

      resolve(fn %{input: params} = args, %{context: context} ->
        recipe =
          Recipe
          |> preload(:author)
          |> Repo.get!(args[:id])

        with true <- Recipes.is_author(context[:current_user], recipe),
             {:ok, recipe_updated} <- Recipes.update(recipe, params) do
          if params[:remove_image] do
            # return recipe without image
            {:ok, Recipes.delete_image(recipe_updated)}
          else
            {:ok, recipe_updated}
          end
        else
          {:error, %Ecto.Changeset{} = changeset} -> {:ok, changeset}
          {:error, msg} -> {:ok, generic_message(msg)}
        end
      end)
    end

    @desc "Destroy a Recipe"
    field :delete_recipe, :recipe_payload do
      arg(:id, non_null(:id))
      middleware(Middleware.Authorize)

      resolve(fn args, %{context: context} ->
        recipe =
          Recipe
          |> preload(:author)
          |> Repo.get!(args[:id])

        case Recipes.is_author(context[:current_user], recipe) do
          true -> recipe |> Recipes.delete()
          {:error, msg} -> {:ok, generic_message(msg)}
        end
      end)
    end

    @desc "Create a comment to recipe"
    field :create_comment, :comment_payload do
      arg(:body, :string)
      arg(:receiver_id, non_null(:id))
      arg(:recipe_id, non_null(:id))
      middleware(Middleware.Authorize)

      resolve(fn args, %{context: context} ->
        recipe = Recipe |> Repo.get!(args[:recipe_id])
        receiver = User |> Repo.get!(args[:receiver_id])
        case Recipes.create_comment(context[:current_user], receiver, recipe, %{body: args[:body]}) do
          {:ok, comment} -> {:ok, comment}
          {:error, %Ecto.Changeset{} = changeset} -> {:ok, changeset}
        end
      end)
    end
  end
end
