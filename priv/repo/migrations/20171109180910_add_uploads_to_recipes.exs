defmodule Letzell.Repo.Migrations.AddUploadsToRecipes do
  use Ecto.Migration

  def up do
    alter table(:recipes) do
      add :image_url, {:array, :string}, null: false, default: []
      add :uuid, :string
    end
  end

  def down do
    alter table(:recipes) do
      remove :image_url
      remove :uuid
    end
  end
end
