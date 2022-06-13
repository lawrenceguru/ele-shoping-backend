defmodule LetzellWeb.Email do
  use Bamboo.Phoenix, view: LetzellWeb.EmailView
  alias Letzell.Accounts.User

  @noreply "noreply@letzell.com"

  def welcome(%User{} = user) do
    new_email()
    |> to(user.email)
    |> from(@noreply)
    |> subject("Welcome to Letzell !")
    |> assign(:user, user)
    |> render(:welcome)
  end

  def new_confirmation_code(%User{} = user) do
    new_email()
    |> to(user.email)
    |> from(@noreply)
    |> subject("New code to validate your account")
    |> assign(:user, user)
    |> render(:new_confirmation_code)
  end
end
