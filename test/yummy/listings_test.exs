defmodule Letzell.ListingsTest do
  use Letzell.DataCase

  alias Letzell.Listings

  describe "listings" do
    alias Letzell.Listings.Listing

    @valid_attrs %{
      category: "some category",
      condition: "some condition",
      description: "some description",
      firm_on_price: "some firm_on_price",
      location: "some location",
      price: "some price",
      title: "some title"
    }
    @update_attrs %{
      category: "some updated category",
      condition: "some updated condition",
      description: "some updated description",
      firm_on_price: "some updated firm_on_price",
      location: "some updated location",
      price: "some updated price",
      title: "some updated title"
    }
    @invalid_attrs %{category: nil, condition: nil, description: nil, firm_on_price: nil, location: nil, price: nil, title: nil}

    def listing_fixture(attrs \\ %{}) do
      {:ok, listing} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Listings.create_listing()

      listing
    end

    test "list_listings/0 returns all listings" do
      listing = listing_fixture()
      assert Listings.list_listings() == [listing]
    end

    test "get_listing!/1 returns the listing with given id" do
      listing = listing_fixture()
      assert Listings.get_listing!(listing.id) == listing
    end

    test "create_listing/1 with valid data creates a listing" do
      assert {:ok, %Listing{} = listing} = Listings.create_listing(@valid_attrs)
      assert listing.category == "some category"
      assert listing.condition == "some condition"
      assert listing.description == "some description"
      assert listing.firm_on_price == "some firm_on_price"
      assert listing.location == "some location"
      assert listing.price == "some price"
      assert listing.title == "some title"
    end

    test "create_listing/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Listings.create_listing(@invalid_attrs)
    end

    test "update_listing/2 with valid data updates the listing" do
      listing = listing_fixture()
      assert {:ok, %Listing{} = listing} = Listings.update_listing(listing, @update_attrs)
      assert listing.category == "some updated category"
      assert listing.condition == "some updated condition"
      assert listing.description == "some updated description"
      assert listing.firm_on_price == "some updated firm_on_price"
      assert listing.location == "some updated location"
      assert listing.price == "some updated price"
      assert listing.title == "some updated title"
    end

    test "update_listing/2 with invalid data returns error changeset" do
      listing = listing_fixture()
      assert {:error, %Ecto.Changeset{}} = Listings.update_listing(listing, @invalid_attrs)
      assert listing == Listings.get_listing!(listing.id)
    end

    test "delete_listing/1 deletes the listing" do
      listing = listing_fixture()
      assert {:ok, %Listing{}} = Listings.delete_listing(listing)
      assert_raise Ecto.NoResultsError, fn -> Listings.get_listing!(listing.id) end
    end

    test "change_listing/1 returns a listing changeset" do
      listing = listing_fixture()
      assert %Ecto.Changeset{} = Listings.change_listing(listing)
    end
  end
end
