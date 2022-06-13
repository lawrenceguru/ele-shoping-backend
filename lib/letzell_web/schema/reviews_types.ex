defmodule LetzellWeb.Schema.ReviewsTypes do
  use Absinthe.Schema.Notation
  import Absinthe.Resolution.Helpers
  alias Letzell.Accounts

  object :review do
    field(:id, :id)
    field(:body, :string)
    field(:rating, :integer)
    field(:inserted_at, :datetime)
    field(:user, :user, resolve: dataloader(Accounts))
    field(:author, :author, resolve: dataloader(Accounts))
  end

  object :review_stats do
    field(:user_id, :id)
    field(:total_reviews, :integer)
    field(:average_review, :float)
  end
end
