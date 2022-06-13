defmodule LetzellWeb.Schema.FavoritesTypes do
  use Absinthe.Schema.Notation
  import Absinthe.Resolution.Helpers
  alias Letzell.{Accounts, Listings}

  object :favorite do
    field(:id, :id)
    field(:listing_id, :id)
    field(:status, :string)
    field(:inserted_at, :datetime)
    field(:user_id, :id)
    field(:user, :user, resolve: dataloader(Accounts))
    field(:listing, :listing, resolve: dataloader(Listings))
  end
end
