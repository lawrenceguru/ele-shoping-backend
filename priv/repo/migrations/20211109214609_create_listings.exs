defmodule Letzell.Repo.Migrations.CreateListings do
  use Ecto.Migration

  def change do
    create table(:listings, primary_key: false) do
      add :id, :uuid, primary_key: true
      add :title, :string
      add :slug, :string
      add :description, :text
      add :category, :string
      add :condition, :string
      add :photo_urls, {:array, :text}, null: false, default: []
      add :price_per_unit, :integer
      add :no_of_units, :integer
      add :firm_on_price, :string
      add :location, :string
      add :place_name, :string
      add :state_code, :string
      add :user_id, references(:users, on_delete: :delete_all)
      add :uuid, :string

      timestamps()
    end

    create index(:listings, [:user_id])
    create index(:listings, [:location])
    create unique_index(:listings, [:slug, :user_id])
  end
end
