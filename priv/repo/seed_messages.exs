alias Letzell.Accounts.User
alias Letzell.Repo
alias Letzell.Listings.Listing
alias Letzell.Messages
alias Letzell.Messages.Message

# Create messages for 2000 users

Repo.delete_all(Message)

1..500
|> Enum.map(fn _messages ->
  listing = Repo.all(Listing) |> Enum.random()
  sender = Repo.all(User) |> Enum.random()
  receiver = Repo.all(User) |> Enum.random()

  1..Enum.random(1..20)
  |> Enum.map(fn _message ->
    case sender == receiver do
      true ->
        :ok

      _ ->
        Messages.create_message(
          sender,
          receiver,
          listing,
          %{
            body: Faker.Lorem.sentence()
          }
        )

        Messages.create_message(receiver, sender, listing, %{
          body: Faker.Lorem.sentence()
        })
    end
  end)
end)
