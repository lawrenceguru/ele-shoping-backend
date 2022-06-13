defmodule Letzell.Repo.Migrations.AddLocationDetails do
  use Ecto.Migration

  def change do
    alter table(:listings) do
      add :location_details, :map
    end
  end
end
