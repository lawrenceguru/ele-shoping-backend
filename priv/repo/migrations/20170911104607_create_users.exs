defmodule Letzell.Repo.Migrations.CreateUsers do
  use Ecto.Migration

  def change do
    create table(:users, primary_key: false) do
      add :id, :uuid, primary_key: true
      add :first_name, :binary, null: false
      add :first_name_hash, :binary
      add :last_name, :binary, null: false
      add :last_name_hash, :binary
      add :user_name, :binary, null: false
      add :user_type, :binary, null: false
      add :email, :binary, null: false
      add :email_hash, :binary
      # add :password_hash, :string, null: false

      timestamps()
    end

    # create unique_index(:users, [:email])
    create unique_index(:users, [:email_hash])
  end
end
