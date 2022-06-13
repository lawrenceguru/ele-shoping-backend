defmodule Letzell.Meta.PostalCode do
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key {:id, :binary_id, autogenerate: true}
  schema "postal_codes" do
    field :accuracy, :string
    field :community_code, :string
    field :community_name, :string
    field :country_code, :string
    field :county_code, :string
    field :county_name, :string
    field :latitude, :float
    field :longitude, :float
    field :place_name, :string
    field :postal_code, :string
    field :state_code, :string
    field :state_name, :string

    timestamps()
  end

  @doc false
  def changeset(postal_code, attrs) do
    postal_code
    |> cast(attrs, [
      :country_code,
      :postal_code,
      :place_name,
      :state_name,
      :state_code,
      :county_name,
      :county_code,
      :community_name,
      :community_code,
      :latitude,
      :longitude,
      :accuracy
    ])
    |> validate_required([:country_code, :postal_code, :place_name, :latitude, :longitude, :accuracy])
  end
end
