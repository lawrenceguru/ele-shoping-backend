defmodule Letzell.Listings do
  @moduledoc """
  The Listings context.
  """

  import Ecto.Query, warn: false
  alias Letzell.Repo

  alias Letzell.Listings.Listing
  alias Letzell.Accounts.User
  alias Letzell.PostalCode.Store

  @doc """
  Returns the list of listings by keywords.

  ## Examples

      iex> search()
      [%Listing{}, ...]

  """
  def search(query, nil), do: query

  def search(query, keywords) do
    from(
      r in query,
      where: fragment(" full_text_search_weighted @@ plainto_tsquery('english', ?) ", ^keywords)
    )
  end

  def extended_search(query, criteria) do
      q = from(p in query, order_by: [desc: :inserted_at])

      Enum.reduce(criteria, query, fn
      {:limit, limit}, query ->
        from p in query, limit: ^limit

      {:offset, offset}, query ->
        from p in query, offset: ^offset

      {:location, value}, query ->
        from p in query, where: p.location == ^value

      {:radius, value}, query ->
        from p in query, where: p.location == ^value

      {:category, value}, query ->
        from p in query, where: p.category == ^value

      {:condition, value}, query ->
        from p in query, where: p.condition == ^value

      {:price_from, value}, query ->
        from p in query, where: p.price_per_unit >= ^value

      {:price_to, value}, query ->
        from p in query, where: p.price_per_unit <= ^value

    end)

  end

  defp location_details(postal_code) do
    Store.get_geolocation(postal_code)
  end

  def category(query, category) do
    from(
      r in query,
      where: r.category == ^category
    )
  end

  def related(query, listing_id, category, location) do
    from(
      r in query,
      where:
        (r.category == ^category or
           r.location == ^location ) and
          r.id != ^listing_id,
      limit: 6
    )
  end

  def user(query, user_id) do
    from(
      r in query,
      where: r.user_id == ^user_id
    )
  end

  @doc """
  Returns the list of listings.

  ## Examples

      iex> list_listings()
      [%Listing{}, ...]

  """
  def list_listings do
    Repo.all(Listing)
  end

  @doc """
  Gets a single listing.

  Raises `Ecto.NoResultsError` if the Listing does not exist.

  ## Examples

      iex> get_listing(123)
      %Listing{}

      iex> get_listing(456)
      ** (Ecto.NoResultsError)

  """
  def get_listing(id), do: Repo.get(Listing, id)

  @doc """
  Creates a listing.

  ## Examples

      iex> create_listing(%{field: value})
      {:ok, %Listing{}}

      iex> create_listing(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """

  def create(owner, attrs) do

    urls =
      for entry <- attrs.image do
        # {:ok, filename } = ExAws.Config.new(:s3) |> ExAws.S3.presigned_url(:get,"letzell",filename(entry))
        Path.join("https://s3.us-west-004.backblazeb2.com/letzell/", filename(entry))
      end

    listing =
      %Listing{photo_urls: urls}
      |> Listing.changeset(attrs)
      |> Ecto.Changeset.put_assoc(:owner, owner)
      |> Repo.insert()

    case listing do
      {:ok, listing} ->
        consume_images(urls, attrs)
        {:ok, listing}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:ok, changeset}
    end
  end

  defp consume_images(urls, %{image: files} = _params) do
    Enum.zip(urls, files)
    |> Enum.into([])
    |> Enum.map(fn item ->
      {url, file} = item
      # [url_slice | _] = String.split(url,"?")
      image_file = String.replace(url, "https://s3.us-west-004.backblazeb2.com/letzell", "")
      # Original file in the local directory
      local_image = File.read!(file.path)

      IO.inspect image_file
      # [file | ext ] = String.split(image_file, ".")
      # thumbnail_file = "#{file}-thumb.#{ext}"

      # Create thumbnail of the file and store in the cloud.
      # Mogrify.open(local_image) 
      # |> Mogrify.resize_to_limit("200x200") 
      # |> Mogrify.save(path: "/tmp/#{thumbnail_file}")

      # local_thumb_file = File.read!("/tmp/#{thumbnail_file}")

      # ExAws.S3.put_object("letzell", thumbnail_file, local_thumb_file) |> ExAws.request!()

      # "/var/images/listings/mobile-phones-1.jpg" |> ExAws.S3.Upload.stream_file |> ExAws.S3.upload("letzell","mobile-phones/mobile-phones-1.jpg") |> ExAws.request!
      # file.path
      # |> ExAws.S3.Upload.stream_file
      # |> ExAws.S3.upload("letzell",image_file)
      # |> ExAws.request!
      ExAws.S3.put_object("letzell", image_file, local_image) |> ExAws.request!()
    end)
  end

  defp filename(entry) do
    ext = Path.extname(entry.filename)
    file_name = Ecto.UUID.generate()
    "#{file_name}#{ext}"
  end

  @doc """
  Updates a listing.

  ## Examples

      iex> update_listing(listing, %{field: new_value})
      {:ok, %Listing{}}

      iex> update_listing(listing, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_listing(listing, attrs) do
    listing
    |> Listing.changeset(attrs)
    |> Repo.update()
  end

  def is_owner(%User{} = user, %Listing{} = listing) do
    if listing.owner.id == user.id do
      true
    else
      {:error, "You cannot edit someone else's listing"}
    end
  end

  def delete(%Listing{} = listing) do
    {:ok, listing} = listing |> Repo.delete()
    # delete_image_files(listing)
    {:ok, listing}
  end

  defp delete_image_files(%Listing{photo_urls: nil} = listing), do: listing

  @doc """
  Deletes a listing.

  ## Examples

      iex> delete_listing(listing)
      {:ok, %Listing{}}

      iex> delete_listing(listing)
      {:error, %Ecto.Changeset{}}

  """
  def delete_listing(%Listing{} = listing) do
    Repo.delete(listing)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking listing changes.

  ## Examples

      iex> change_listing(listing)
      %Ecto.Changeset{data: %Listing{}}

  """
  def change_listing(%Listing{} = listing, attrs \\ %{}) do
    Listing.changeset(listing, attrs)
  end

  def data() do
    Dataloader.Ecto.new(Repo, query: &query/2)
  end

  def query(queryable, _) do
    queryable
  end
end
