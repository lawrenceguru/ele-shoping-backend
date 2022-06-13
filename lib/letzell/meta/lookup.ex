defmodule Letzell.Meta.Lookup do
  use Ecto.Schema
  import Ecto.Changeset
  alias Letzell.Schema

  @primary_key {:id, :binary_id, autogenerate: true}
  schema "lookups" do
    field :lookup_type, :string
    field :lookup_group, :string
    field :lookup_code, :string
    field :description, :string
    field :children, :string, virtual: true

    timestamps(type: :utc_datetime)
  end

  def changeset(lookup, attrs) do
    required_fields = [:lookup_type, :lookup_code, :description]
    optional_fields = [:lookup_group]

    lookup
    |> cast(attrs, required_fields ++ optional_fields)
    |> validate_required(required_fields)
  end
end
