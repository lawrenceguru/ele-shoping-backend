defmodule Letzell.Repo.Migrations.CreatePostalCodes do
  use Ecto.Migration

  def change do
    create table(:postal_codes, primary_key: false ) do
      add :id, :uuid, primary_key: true
      add :country_code, :string
      add :postal_code, :string
      add :place_name, :string
      add :state_name, :string
      add :state_code, :string
      add :county_name, :string
      add :county_code, :string
      add :community_name, :string
      add :community_code, :string
      add :latitude, :float
      add :longitude, :float
      add :accuracy, :string

      timestamps()
    end

    create index(:postal_codes, [:postal_code])
    create unique_index(:postal_codes, [:postal_code, :place_name])

  end
end
