defmodule LetzellWeb.Router do
  use LetzellWeb, :router

  pipeline :api do
    plug(:accepts, ["json"])
    plug(LetzellWeb.Plugs.Context)
  end

  scope "/" do
    pipe_through(:api)

    forward("/graphql", Absinthe.Plug, schema: LetzellWeb.Schema)

    if Mix.env() == :dev do
      forward("/graphiql", Absinthe.Plug.GraphiQL, schema: LetzellWeb.Schema, socket: LetzellWeb.UserSocket)
      forward("/emails", Bamboo.SentEmailViewerPlug)
    end
  end
end
