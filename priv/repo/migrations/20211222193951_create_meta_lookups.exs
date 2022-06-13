defmodule Letzell.Repo.Migrations.CreateMetaLookups do
  use Ecto.Migration

  def change do
   create table(:lookups) do
      add :lookup_type, :string
      add :lookup_group, :string
      add :lookup_code, :string
      add :description, :string

      timestamps()
    end

    create index(:lookups, [:lookup_type,:lookup_group, :lookup_code ])
  end
end
