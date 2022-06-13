defmodule Letzell.Repo.Migrations.AddUserAdditionalFields do
  use Ecto.Migration

  def change do
    alter table(:users) do
      add :primary_phone, :binary
      add :secondary_phone, :binary
      add :fax_number, :binary
      add :postal_code, :binary
      add :postal_code_hash, :binary
    end
  end
end
