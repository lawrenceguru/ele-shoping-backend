defmodule LetzellWeb.Schema.AccountsTypes do
  use Absinthe.Schema.Notation
  import Absinthe.Resolution.Helpers
  alias Letzell.Accounts
  alias Letzell.Reviews

  @desc "An user entry, returns basic user information"
  object :user do
    field(:id, :id)
    field(:first_name, :string)
    field(:last_name, :string)
    field(:user_name, :string)
    field(:user_type, :string)

    field :gravatar_md5, :string do
      resolve(fn user, _, _ ->
        {:ok, :crypto.hash(:md5, user.email) |> Base.encode16(case: :lower)}
      end)
    end

    field(:profile_details, :profile) do
      resolve(fn user, _, _ ->
        profile_details =
          case user.profile_details do
            nil ->
              %{}

            _ ->
              user.profile_details
              # _ -> for {key, val} <- user.profile_details, into: %{}, do: {String.to_atom(key), val}
          end

        {:ok, profile_details}
      end)
    end

    field(:preference_details, :string)
    field(:photo_urls, list_of(:string))
    field(:inserted_at, :datetime)
    field(:email, :string)
    field(:primary_phone, :string)
    field(:postal_code, :string)
    field(:favorites, list_of(:favorite), resolve: dataloader(Accounts))
    field(:recipes, list_of(:recipe), resolve: dataloader(Accounts))
    field(:listings, list_of(:listing), resolve: dataloader(Accounts))
    field(:reviews, list_of(:review), resolve: dataloader(Accounts))
  end

  @desc "token to authenticate user"
  object :session do
    field(:token, :string)
    field(:profile_completed, :boolean)
  end

  object :profile do
    field(:age, :integer)
    field(:marital, :string)
    field(:looking_for, :string)
    field(:gender, :string)
    field(:location, :string)
    field(:country, :string)
    field(:occupation, :string)
    field(:intent, :string)
    field(:education, :string)
    field(:seeking, :string)
    field(:smoking, :string)
    field(:drinking, :string)
    field(:drugs, :string)
    field(:religion, :string)
    field(:have_kids, :string)
    field(:want_kids, :string)
    field(:eye_color, :string)
    field(:hair_color, :string)
    field(:body_type, :string)
    field(:longest_relationship, :string)
    field(:pets, :string)
    field(:own_car, :string)
    field(:debt, :string)
    field(:employed, :string)
  end
end
