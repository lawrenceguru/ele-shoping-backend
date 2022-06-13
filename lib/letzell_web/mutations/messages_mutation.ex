defmodule LetzellWeb.Mutations.MessagesMutations do
  use Absinthe.Schema.Notation
  import Ecto.Query, warn: false
  import LetzellWeb.Helpers.ValidationMessageHelpers

  alias LetzellWeb.Schema.Middleware
  alias Letzell.Repo
  alias Letzell.{Listings, Messages, Accounts}
  alias Letzell.Listings.Listing
  alias Letzell.Accounts.User

  object :messages_mutations do
    @desc "Create a message"
    field :create_message, :message_payload do
      arg(:receiver_id, non_null(:id))
      arg(:listing_id, non_null(:id))
      arg(:body, non_null(:string))
      middleware(Middleware.Authorize)

      resolve(fn args, %{context: context} ->
        receiver = User |> Repo.get!(args[:receiver_id]) |> IO.inspect()
        listing = Listing |> Repo.get!(args[:listing_id]) |> IO.inspect()

        case context[:current_user]
             |> Messages.create_message(receiver, listing, %{body: args[:body]}) do
          {:ok, message} ->
            publish_message_change(message)
            {:ok, message}

          {:error, %Ecto.Changeset{} = changeset} ->
            {:ok, changeset}
        end
      end)
    end
  end

  defp publish_message_change(message) do
    Absinthe.Subscription.publish(
      LetzellWeb.Endpoint,
      message,
      new_message: "new_message:#{message.receiver.id}:#{message.listing.id}"
    )
  end
end
