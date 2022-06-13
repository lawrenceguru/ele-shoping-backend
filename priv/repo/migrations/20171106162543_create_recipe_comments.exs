defmodule Letzell.Repo.Migrations.CreateRecipeComments do
  use Ecto.Migration

  def change do
    create table(:comments, primary_key: false) do
      add :id, :uuid, primary_key: true
      add :body, :text, null: false
      add :recipe_id, references(:recipes, on_delete: :delete_all), null: false
      add :sender_id, references(:users, on_delete: :delete_all), null: false
      add :receiver_id, references(:users, on_delete: :delete_all), null: false

      timestamps()
    end

    create index(:comments, [:recipe_id])
    create index(:comments, [:sender_id])
    create index(:comments, [:receiver_id])
  end
end
