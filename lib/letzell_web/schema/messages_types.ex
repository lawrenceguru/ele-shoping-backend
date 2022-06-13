defmodule LetzellWeb.Schema.MessagesTypes do
  use Absinthe.Schema.Notation
  import Absinthe.Resolution.Helpers
  alias Letzell.{Accounts, Listings, Messages}

  object :contact do
    field(:id, :id)
    field(:deleted_at, :datetime)
    field(:inserted_at, :datetime)
    field(:sender, :user, resolve: dataloader(Messages))
    field(:receiver, :user, resolve: dataloader(Messages))
    field(:listing, :listing, resolve: dataloader(Messages))
  end

  object :message do
    field(:id, :id)
    field(:body, :string)
    field(:inserted_at, :datetime)
    field(:sender, :user, resolve: dataloader(Messages))
    field(:receiver, :user, resolve: dataloader(Messages))
    field(:listing, :listing, resolve: dataloader(Messages))
  end
end
