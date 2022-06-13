defmodule LetzellWeb.Mutations.ListingsMutations do
  use Absinthe.Schema.Notation
  import Ecto.Query, warn: false
  import LetzellWeb.Helpers.ValidationMessageHelpers

  alias LetzellWeb.Schema.Middleware
  alias Letzell.Repo
  alias Letzell.Listings
  alias Letzell.Listings.Listing
  alias Letzell.Favorites

  input_object :listing_input do
    field(:title, :string)
    field(:description, :string)

    field(:price_per_unit, :string)
    field(:no_of_units, :string)
    field(:category, :string)
    field(:condition, :string)
    field(:location, :string)

    field(:remove_image, :boolean, default_value: false)
    field(:image, list_of(:upload))
  end

  object :listings_mutations do
    @desc "Create a listing"
    field :create_listing, :listing_payload do
      arg(:input, :listing_input)
      middleware(Middleware.Authorize)

      resolve(fn %{input: params}, %{context: context} ->
        case context[:current_user] |> Listings.create(params) do
          {:ok, listing} -> {:ok, listing}
          {:error, %Ecto.Changeset{} = changeset} -> {:ok, changeset}
        end
      end)
    end

    @desc "Change the status of a listing and return Listing"
    field :change_listing, :listing_payload do
      arg(:id, non_null(:id))
      arg(:status, :string)
      middleware(Middleware.Authorize)

      resolve(fn %{input: params} = args, %{context: context} ->
        listing =
          Listing
          |> preload(:owner)
          |> Repo.get!(args[:id])

        with true <- Listings.is_owner(context[:current_user], listing),
             {:ok, listing_updated} <- Listings.update(listing, params) do
          {:ok, listing_updated}
        else
          {:error, %Ecto.Changeset{} = changeset} -> {:ok, changeset}
          {:error, msg} -> {:ok, generic_message(msg)}
        end
      end)
    end

    @desc "Update a Listing and return Listing"
    field :update_listing, :listing_payload do
      arg(:id, non_null(:id))
      arg(:input, :listing_input)
      middleware(Middleware.Authorize)

      resolve(fn %{input: params} = args, %{context: context} ->
        listing =
          Listing
          |> preload(:owner)
          |> Repo.get!(args[:id])

        with true <- Listings.is_owner(context[:current_user], listing),
             {:ok, listing_updated} <- Listings.update(listing, params) do
          if params[:remove_image] do
            # return listing without image
            {:ok, Listings.delete_image(listing_updated)}
          else
            {:ok, listing_updated}
          end
        else
          {:error, %Ecto.Changeset{} = changeset} -> {:ok, changeset}
          {:error, msg} -> {:ok, generic_message(msg)}
        end
      end)
    end

    @desc "Delete a Listing"
    field :delete_listing, :listing_payload do
      arg(:id, non_null(:id))
      middleware(Middleware.Authorize)

      resolve(fn args, %{context: context} ->
        listing =
          Listing
          |> preload(:owner)
          |> Repo.get!(args[:id])

        case Listings.is_owner(context[:current_user], listing) do
          true -> listing |> Listings.delete()
          {:error, msg} -> {:ok, generic_message(msg)}
        end
      end)
    end
  end
end
