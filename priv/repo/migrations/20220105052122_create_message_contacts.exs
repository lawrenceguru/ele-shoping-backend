defmodule Letzell.Repo.Migrations.CreateMessageContacts do
  use Ecto.Migration

   def change do
    create table(:contacts, primary_key: false) do
        add :id, :uuid, primary_key: true
        add :deleted_at, :naive_datetime
        add :sender_id, references(:users, on_delete: :delete_all)
        add :receiver_id, references(:users, on_delete: :delete_all)
        add :listing_id, references(:listings, on_delete: :delete_all)
        add :reciprocal, :string

        timestamps()
      end

      create index(:contacts, [:sender_id])
      create index(:contacts, [:receiver_id])
      create index(:contacts, [:listing_id])

      create unique_index(:contacts, [:sender_id, :receiver_id, :listing_id])
  end
end
