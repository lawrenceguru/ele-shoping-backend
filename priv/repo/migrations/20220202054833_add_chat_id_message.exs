defmodule Letzell.Repo.Migrations.AddChatIdMessage do
  use Ecto.Migration

  def change do
     alter table(:messages) do
      add :contact_id, references(:contacts, on_delete: :delete_all)
    end

    create index(:messages, [:contact_id])
  end
end
