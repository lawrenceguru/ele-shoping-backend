defmodule Letzell.MetaTest do
  use Letzell.DataCase

  alias Letzell.Meta

  describe "postal_codes" do
    alias Letzell.Meta.PostalCode

    @valid_attrs %{
      accuracy: "some accuracy",
      community_code: "some community_code",
      community_name: "some community_name",
      country_code: "some country_code",
      county_code: "some county_code",
      county_name: "some county_name",
      latitude: "some latitude",
      longitude: "some longitude",
      place_name: "some place_name",
      postal_code: "some postal_code",
      state_code: "some state_code",
      state_name: "some state_name"
    }
    @update_attrs %{
      accuracy: "some updated accuracy",
      community_code: "some updated community_code",
      community_name: "some updated community_name",
      country_code: "some updated country_code",
      county_code: "some updated county_code",
      county_name: "some updated county_name",
      latitude: "some updated latitude",
      longitude: "some updated longitude",
      place_name: "some updated place_name",
      postal_code: "some updated postal_code",
      state_code: "some updated state_code",
      state_name: "some updated state_name"
    }
    @invalid_attrs %{
      accuracy: nil,
      community_code: nil,
      community_name: nil,
      country_code: nil,
      county_code: nil,
      county_name: nil,
      latitude: nil,
      longitude: nil,
      place_name: nil,
      postal_code: nil,
      state_code: nil,
      state_name: nil
    }

    def postal_code_fixture(attrs \\ %{}) do
      {:ok, postal_code} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Meta.create_postal_code()

      postal_code
    end

    test "list_postal_codes/0 returns all postal_codes" do
      postal_code = postal_code_fixture()
      assert Meta.list_postal_codes() == [postal_code]
    end

    test "get_postal_code!/1 returns the postal_code with given id" do
      postal_code = postal_code_fixture()
      assert Meta.get_postal_code!(postal_code.id) == postal_code
    end

    test "create_postal_code/1 with valid data creates a postal_code" do
      assert {:ok, %PostalCode{} = postal_code} = Meta.create_postal_code(@valid_attrs)
      assert postal_code.accuracy == "some accuracy"
      assert postal_code.community_code == "some community_code"
      assert postal_code.community_name == "some community_name"
      assert postal_code.country_code == "some country_code"
      assert postal_code.county_code == "some county_code"
      assert postal_code.county_name == "some county_name"
      assert postal_code.latitude == "some latitude"
      assert postal_code.longitude == "some longitude"
      assert postal_code.place_name == "some place_name"
      assert postal_code.postal_code == "some postal_code"
      assert postal_code.state_code == "some state_code"
      assert postal_code.state_name == "some state_name"
    end

    test "create_postal_code/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Meta.create_postal_code(@invalid_attrs)
    end

    test "update_postal_code/2 with valid data updates the postal_code" do
      postal_code = postal_code_fixture()
      assert {:ok, %PostalCode{} = postal_code} = Meta.update_postal_code(postal_code, @update_attrs)
      assert postal_code.accuracy == "some updated accuracy"
      assert postal_code.community_code == "some updated community_code"
      assert postal_code.community_name == "some updated community_name"
      assert postal_code.country_code == "some updated country_code"
      assert postal_code.county_code == "some updated county_code"
      assert postal_code.county_name == "some updated county_name"
      assert postal_code.latitude == "some updated latitude"
      assert postal_code.longitude == "some updated longitude"
      assert postal_code.place_name == "some updated place_name"
      assert postal_code.postal_code == "some updated postal_code"
      assert postal_code.state_code == "some updated state_code"
      assert postal_code.state_name == "some updated state_name"
    end

    test "update_postal_code/2 with invalid data returns error changeset" do
      postal_code = postal_code_fixture()
      assert {:error, %Ecto.Changeset{}} = Meta.update_postal_code(postal_code, @invalid_attrs)
      assert postal_code == Meta.get_postal_code!(postal_code.id)
    end

    test "delete_postal_code/1 deletes the postal_code" do
      postal_code = postal_code_fixture()
      assert {:ok, %PostalCode{}} = Meta.delete_postal_code(postal_code)
      assert_raise Ecto.NoResultsError, fn -> Meta.get_postal_code!(postal_code.id) end
    end

    test "change_postal_code/1 returns a postal_code changeset" do
      postal_code = postal_code_fixture()
      assert %Ecto.Changeset{} = Meta.change_postal_code(postal_code)
    end
  end
end
