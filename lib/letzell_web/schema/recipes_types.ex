defmodule LetzellWeb.Schema.RecipesTypes do
  use Absinthe.Schema.Notation
  import Absinthe.Resolution.Helpers

  alias LetzellWeb.Helpers.StringHelpers
  alias Letzell.{Recipes, Accounts}
  alias Letzell.Recipes.Recipe
  alias Letzell.ImageUploader

  @desc "A Recipe with title and content"
  object :recipe do
    field(:id, :id)
    field(:title, :string)
    field(:content, :string)

    field :description, :string do
      resolve(fn recipe, _, _ ->
        {:ok, StringHelpers.description(recipe.content)}
      end)
    end

    field(:total_time, :string)
    field(:level, :string)
    field(:budget, :string)
    field(:image_url, list_of(:string))
    field(:inserted_at, :datetime)
    field(:author, :author, resolve: dataloader(Recipes))
    field(:comments, list_of(:comment), resolve: dataloader(Recipes))
  end

  object :comment do
    field(:id, :id)
    field(:body, :string)
    field(:inserted_at, :datetime)
    field(:recipe, :recipe, resolve: dataloader(Recipes))
    field(:sender, :author, resolve: dataloader(Recipes))
    field(:receiver, :author, resolve: dataloader(Recipes))
  end

  @desc "author"
  object :author do
    field(:id, :id)
    field(:first_name, :string)
    field(:last_name, :string)
    field(:inserted_at, :datetime)
  end
end
