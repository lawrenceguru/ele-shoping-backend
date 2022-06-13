defmodule Letzell.Image do
  use Ecto.Schema
  use Arc.Ecto.Schema

  import Ecto
  import Ecto.Changeset

  @required_fields ~w(file)
  @optional_fields ~w()

  embedded_schema do
    field :file, Letzell.ImageUploader.Type
  end

  def changeset(model, attrs \\ :empty) do
    attributes =
      case attrs[:image] do
        %Plug.Upload{} -> Map.merge(attrs, %{file: attrs[:image]})
        _ -> attrs
      end

    model
    |> cast(attrs, @required_fields, @optional_fields)
    |> cast_attachments(attributes, [:file])
  end
end
