defmodule Letzell.Repo.Migrations.AddStatusListings do
  use Ecto.Migration

  def change do
    alter table(:listings) do
      add :status, :string

    end
  end
end
