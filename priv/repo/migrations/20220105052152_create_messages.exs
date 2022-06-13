defmodule Letzell.Repo.Migrations.CreateUserMessages do
  use Ecto.Migration

  def change do
      create table(:messages, primary_key: false) do
        add :id, :uuid, primary_key: true
        add :deleted_at, :naive_datetime
        add :read_at, :naive_datetime
        add :body, :string, null: false
        add :sender_id, references(:users, on_delete: :delete_all)
        add :receiver_id, references(:users, on_delete: :delete_all)
        add :listing_id, references(:listings, on_delete: :delete_all)

        timestamps()
      end

      create index(:messages, [:sender_id])
      create index(:messages, [:receiver_id])
      create index(:messages, [:listing_id])
  end
end
