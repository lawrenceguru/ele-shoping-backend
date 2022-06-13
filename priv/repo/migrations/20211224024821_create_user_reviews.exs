defmodule Letzell.Repo.Migrations.CreateUserReviews do
  use Ecto.Migration

  def change do
    create table(:reviews, primary_key: false) do
      add :id, :uuid, primary_key: true
      add :body, :text, null: false
      add :rating, :integer, null: 0
      add :user_id, references(:users, on_delete: :delete_all), null: false
      add :author_id, references(:users, on_delete: :delete_all), null: false

      timestamps()
    end

    create index(:reviews, [:user_id])
    create index(:reviews, [:author_id])
  end
end
