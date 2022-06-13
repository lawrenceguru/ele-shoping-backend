defmodule Letzell.Repo.Migrations.AddUserProfileFields do
  use Ecto.Migration

  def change do
    alter table(:users) do
      add :profile_details, :binary
      add :photo_urls, {:array, :string}, null: false, default: []
    end
  end
end
