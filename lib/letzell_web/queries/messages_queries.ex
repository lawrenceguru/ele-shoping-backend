defmodule LetzellWeb.Queries.MessagesQueries do
  use Absinthe.Schema.Notation
  alias LetzellWeb.Schema.Middleware
  import Ecto.Query, warn: false

  alias Letzell.Repo
  alias Letzell.Messages
  alias Letzell.Messages.{Contact, Message}

  object :messages_queries do
    @desc "Message contacts for a user"
    field :user_contacts, list_of(:contact) do
      arg(:sender_id, non_null(:id))
      arg(:limit, :integer, default_value: 30)
      arg(:offset, :integer, default_value: 0)

      resolve(fn args, _ ->
        contacts =
          Contact
          |> Letzell.Messages.user_contacts(args[:sender_id])
          |> order_by(desc: :inserted_at)
          |> Repo.paginate(args[:limit], args[:offset])
          |> Repo.all()

        {:ok, contacts}
      end)
    end

    @desc "Messages between a sender/receiver for a listing"
    field :user_messages, list_of(:message) do
      arg(:sender_id, non_null(:id))
      arg(:receiver_id, non_null(:id))
      arg(:listing_id, non_null(:id))
      arg(:limit, :integer, default_value: 10)
      arg(:offset, :integer, default_value: 0)

      resolve(fn args, _ ->
        messages =
          Message
          |> Letzell.Messages.user_messages(
            args[:sender_id],
            args[:receiver_id],
            args[:listing_id]
          )
          |> order_by(desc: :inserted_at)
          |> Repo.paginate(args[:limit], args[:offset])
          |> Repo.all()

        {:ok, messages}
      end)
    end
  end
end
