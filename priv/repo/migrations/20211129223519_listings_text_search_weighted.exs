defmodule Letzell.Repo.Migrations.ListingsTextSearchWeighted do
  use Ecto.Migration

  def change do
      execute "
            ALTER TABLE listings ADD COLUMN full_text_search_weighted TSVECTOR
              GENERATED ALWAYS AS (
                to_tsvector('english', title || ' ' || description || ' ' || category || ' ' || place_name || ' ' || state_code || ' ' || location )
              ) STORED;
          "
          execute "
            create index listings_full_text_search_weighted on listings using gin(full_text_search_weighted);
          "
  end
end
