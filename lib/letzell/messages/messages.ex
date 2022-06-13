defmodule Letzell.Messages do
  @moduledoc """
  The Messages context: public interface for user messages.
  """

  import Ecto.Query, warn: false
  alias Letzell.Repo

  alias Letzell.Messages.{Message, Contact}
  alias Letzell.Accounts.User

  def list_contacts(sender_id) do
    query =
      from c in Contact,
        where: (c.sender_id == ^sender_id
           or c.receiver_id == ^sender_id),
        order_by: [desc: :inserted_at]

    Repo.all(query)
  end

  def list_contacts(sender_id, criteria) do
    query =
      from m in Contact,
        where: m.sender_id == ^sender_id
          or m.receiver_id == ^sender_id,
        order_by: [desc: :inserted_at]

    Enum.reduce(criteria, query, fn
      {:limit, limit}, query ->
        from p in query, limit: ^limit

      {:offset, offset}, query ->
        from p in query, offset: ^offset
    end)
    |> Repo.all()
  end

  def get_contact(sender_id, receiver_id, listing_id) do
    query =
      from c in Contact,
        where:
          c.sender_id == ^sender_id and
            c.receiver_id == ^receiver_id and
            c.listing_id == ^listing_id

    Repo.one(query)
  end

  def add_contact(sender_id, receiver_id, listing_id) do
    attrs = %{
      sender_id: sender_id,
      receiver_id: receiver_id,
      listing_id: listing_id
    }

    attrs_reverse = %{
      receiver_id: sender_id,
      sender_id: receiver_id,
      listing_id: listing_id
    }

    %Contact{}
    |> Contact.changeset(attrs)
    |> Repo.insert()

    %Contact{}
    |> Contact.changeset(attrs_reverse)
    |> Repo.insert()

  end

  def create_message(%User{} = sender, %User{} = receiver, listing, attrs) do
    # Add a record in the contacts table if not exists. then add the message.
    get_contact = create_contact_if_nil(sender.id, receiver.id, listing.id)

    %Message{}
    |> Message.changeset(attrs)
    # |> Ecto.Changeset.put_assoc(:contact,get_contact)
    |> Ecto.Changeset.put_assoc(:sender,sender)
    |> Ecto.Changeset.put_assoc(:receiver, receiver)
    |> Ecto.Changeset.put_assoc(:listing, listing)
    |> Repo.insert()
  end

  defp create_contact_if_nil(sender_id, receiver_id, listing_id) do
    get_contact = get_contact(sender_id, receiver_id, listing_id)

    contact = if is_nil(get_contact) do
              {:ok, contact} = add_contact(sender_id, receiver_id, listing_id)
            else
              get_contact
            end
  end

  # All messages for a user.
  def list_messages(sender_id, criteria) do
    query =
      from m in Message,
        where:
          m.sender_id == ^sender_id or
            m.receiver_id == ^sender_id,
        order_by: [:inserted_at]

    Enum.reduce(criteria, query, fn
      {:receiver_id, receiver_id}, query ->
        from q in query,
          where:
            q.sender_id == ^receiver_id or
              q.receiver_id == ^receiver_id

      {:listing_id, listing_id}, query ->
        from q in query,
          where: q.listing_id == ^listing_id

      {:limit, limit}, query ->
        from p in query, limit: ^limit

      {:offset, offset}, query ->
        from p in query, offset: ^offset
    end)
    |> Repo.all()

  end

  defp filter_with(filters, query) do
    Enum.reduce(filters, query, fn
      {:receiver_id, value}, query ->
        from q in query,
          where:
            q.sender_id == ^value or
              q.receiver_id == ^value

      {:listing_id, value}, query ->
        from q in query, where: q.listing_id == ^value
    end)
  end

  # All messages between two users for an Item.
  def list_messages(sender_id, receiver_id, listing_id) do
    query =
      from m in Message,
        where:
          (m.sender_id == ^sender_id or
             m.receiver_id == ^sender_id) and
            (m.sender_id == ^receiver_id or
               m.receiver_id == ^receiver_id) and
            m.listing_id == ^listing_id

    query |> Repo.all()
  end

  # User Contacts for messasing
  def user_contacts(query, sender_id) do
    from(
      r in query,
      where: ( r.sender_id == ^sender_id or
               r.receiver_id == ^sender_id )
    )
  end

  # Messages between sender/receiver for a listing
  def user_messages(query, sender_id, receiver_id, listing_id) do
    from(
      r in query,
      where:
        (r.sender_id == ^sender_id or
           r.receiver_id == ^sender_id) and
          (r.sender_id == ^receiver_id or
             r.receiver_id == ^receiver_id) and
          r.listing_id == ^listing_id
    )
  end

  def data() do
    Dataloader.Ecto.new(Repo, query: &query/2)
  end

  def query(queryable, _) do
    queryable
  end
end
