defmodule LetzellWeb.UserSocket do
  use Phoenix.Socket
  use Absinthe.Phoenix.Socket, schema: LetzellWeb.Schema

  ## Channels
  # channel "room:*", LetzellWeb.RoomChannel

  ## Transports
  transport(:websocket, Phoenix.Transports.WebSocket)
  # transport :longpoll, Phoenix.Transports.LongPoll

  # Socket params are passed from the client and can
  # be used to verify and authenticate a user. After
  # verification, you can put default assigns into
  # the socket that will be set for all channels, ie
  #
  #     {:ok, assign(socket, :user_id, verified_user_id)}
  #
  # To deny connection, return `:error`.
  #
  # See `Phoenix.Token` documentation for examples in
  # performing token verification on connect.
  def connect(_params, socket) do
    {:ok, assign(socket, :absinthe, %{schema: LetzellWeb.Schema})}
  end

  def id(_socket), do: nil
end
