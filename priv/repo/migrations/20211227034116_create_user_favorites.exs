defmodule Letzell.Repo.Migrations.CreateUserFavorites do
  use Ecto.Migration

  def change do
    create table(:favorites, primary_key: false) do
      add :id, :uuid, primary_key: true
      add :status, :text, null: false
      add :listing_id, references(:listings, on_delete: :delete_all), null: false
      add :user_id, references(:users, on_delete: :delete_all), null: false

      timestamps()
    end

    create unique_index(:favorites, [:listing_id, :user_id])
    create index(:favorites, [:listing_id])
    create index(:favorites, [:user_id])
  end
end
