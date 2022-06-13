defmodule Letzell.Repo.Migrations.CreateListingComments do
  use Ecto.Migration

  def change do
    create table(:listing_comments, primary_key: false) do
      add :id, :uuid, primary_key: true
      add :body, :text, null: false
      add :listing_id, references(:listings, on_delete: :delete_all), null: false
      add :user_id, references(:users, on_delete: :delete_all), null: false

      timestamps()
    end

    create index(:listing_comments, [:listing_id])
    create index(:listing_comments, [:user_id])
  end
end
