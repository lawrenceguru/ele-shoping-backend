defmodule LetzellWeb.Schema.OptionTypes do
  use Absinthe.Schema.Notation

  @desc "A option for select field in a form"
  object :option do
    field(:group, :string)
    field(:value, :string)
    field(:label, :string)
    field(:children, :string)
  end

  object :location do
    field(:postal_code, :string)
    field(:city_name, :string)
    field(:state_code, :string)
    field(:latitude, :string)
    field(:longitude, :string)
  end
end
