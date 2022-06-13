defmodule LetzellWeb.Schema.MetaTypes do
  use Absinthe.Schema.Notation
  import Absinthe.Resolution.Helpers

  alias LetzellWeb.Helpers.StringHelpers
  alias Letzell.Meta
  alias Letzell.Meta.Lookup

  @desc "A Lookup details with lookup_type and lookup_code"
  object :lookup do
    field(:id, :id)
    field(:lookup_type, :string)
    field(:lookup_code, :string)
    field(:description, :string)
    field(:children, :string)
    field(:inserted_at, :datetime)
  end

  @desc "Location details with city, state, longitude, latitude"
  object :loc_details do
    field(:place_name, :string)
    field(:latitude, :float)
    field(:longitude, :float)
    field(:state_code, :string)
    field(:postal_code, :string)
  end
end
