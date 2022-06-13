defmodule LetzellWeb.Schema.Middleware.Authorize do
  @behaviour Absinthe.Middleware

  import LetzellWeb.Helpers.ValidationMessageHelpers
  alias Letzell.Accounts.User

  def call(resolution, _config) do
    case resolution.context do
      %{current_user: %User{}} ->
        resolution

      _ ->
        message = "You must login or register to continue."
        resolution |> Absinthe.Resolution.put_result({:ok, generic_message(message)})
    end
  end
end
