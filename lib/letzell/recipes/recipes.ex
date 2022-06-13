defmodule Letzell.Recipes do
  import Ecto.Query, warn: false
  import Ecto.Changeset, only: [put_assoc: 3]
  alias Letzell.{Repo, ImageUploader}
  alias Letzell.Recipes.{Comment, Recipe}
  alias Letzell.Accounts.User

  def search(query, nil), do: query

  def search(query, keywords) do
    from(
      r in query,
      where: ilike(r.title, ^"%#{keywords}%") or ilike(r.content, ^"%#{keywords}%")
    )
  end

  def create(author, attrs) do
    urls =
      for entry <- attrs.image do
        Path.join("#{LetzellWeb.Endpoint.url()}/uploads/images", filename(entry))
      end

    consume_images(urls, attrs)

    %Recipe{image_url: urls}
    |> Recipe.changeset(attrs)
    |> put_assoc(:author, author)
    |> Repo.insert()

    # |> consume_images(attrs)
  end

  defp consume_images(urls, %{image: files} = params) do
    Enum.zip(urls, files)
    |> Enum.into([])
    |> Enum.map(fn item ->
      {url, file} = item
      image_file = String.replace(url, "#{LetzellWeb.Endpoint.url()}/uploads/images/", "")
      File.cp!(file.path, "./uploads/images/#{image_file}")
    end)
  end

  defp filename(entry) do
    ext = Path.extname(entry.filename)
    file_name = Ecto.UUID.generate()
    "#{file_name}#{ext}"
  end

  def update(%Recipe{} = recipe, attrs) do
    recipe
    |> Recipe.changeset(attrs)
    |> Repo.update()
  end

  @spec is_author(User.t(), Recipe.t()) :: true | {:error, String.t()}
  def is_author(%User{} = user, %Recipe{} = recipe) do
    if recipe.author.id == user.id do
      true
    else
      {:error, "You can't modify someone else's recipe"}
    end
  end

  def delete(%Recipe{} = recipe) do
    {:ok, recipe} = recipe |> Repo.delete()
    delete_image_files(recipe)
    {:ok, recipe}
  end

  @spec delete_image(Recipe.t()) :: Recipe.t()
  def delete_image(%Recipe{} = recipe) do
    {:ok, recipe} =
      recipe
      |> delete_image_files
      |> Recipe.changeset(%{image_url: nil})
      |> Repo.update()

    recipe
  end

  @spec delete_image_files(Recipe.t()) :: Recipe.t()
  defp delete_image_files(%Recipe{image_url: nil} = recipe), do: recipe

  defp delete_image_files(%Recipe{} = recipe) do
    # credo:disable-for-lines:3
    path =
      ImageUploader.url({recipe.image_url, recipe})
      |> String.split("?")
      |> List.first()

    :ok = ImageUploader.delete({path, recipe})
    recipe
  end

  @spec create_comment(User.t(), User.t(), Recipe.t(), map()) :: {:ok, Comment.t()} | {:error, any()}
  def create_comment(sender, receiver, recipe, attrs) do
    %Comment{}
    |> Comment.changeset(attrs)
    |> put_assoc(:sender, sender)
    |> put_assoc(:receiver, receiver)
    |> put_assoc(:recipe, recipe)
    |> Repo.insert()
  end

  def data() do
    Dataloader.Ecto.new(Repo, query: &query/2)
  end

  def query(queryable, _) do
    queryable
  end
end
