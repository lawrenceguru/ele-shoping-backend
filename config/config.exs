# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.
use Mix.Config

config :cors_plug,
  origin: ["http://localhost:3001"],
  allow_headers: ["accept", "content-type", "authorization"],
  allow_credentials: true,
  log: [rejected: :error, invalid: :warn, accepted: :debug],
  max_age: 86400,
  methods: ["GET", "POST"]

# General application configuration
config :letzell,
  ecto_repos: [Letzell.Repo],
  confirmation_code_expire_hours: 1,
  client_host: System.get_env("CLIENT_HOST") || "localhost:3000",
  loggers: [Letzell.RepoInstrumenter, Ecto.LogEntry]

# Configures the endpoint
config :letzell, LetzellWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "QvfN7ps5NsTx3Gz+TyYXH0vLB0JGNYxQZA3s5t7FunHZ9tENymuU1B70iHJpHRVK",
  render_errors: [view: LetzellWeb.ErrorView, accepts: ~w(json)],
  # pubsub: [name: Letzell.PubSub, adapter: Phoenix.PubSub.PG2],
  pubsub_server: Letzell.PubSub

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Generate key using the following command
# 32 |> :crypto.strong_rand_bytes() |> Base.encode64()
config :letzell, Letzell.Vault,
  json_library: Jason,
  ciphers: [
    default: {Cloak.Ciphers.AES.GCM, tag: "AES.GCM.V1", key: Base.decode64!("9zd/sNgALMg2yW+n8k9BnUDDo2ZtK+HAA5l1jDGR3Bg=")}
  ]

config :letzell, LetzellWeb.Gettext, default_locale: "en"

# Prometheus
# config :prometheus, Letzell.PhoenixInstrumenter,
#   controller_call_labels: [:controller, :action],
#   registry: :default,
#   duration_unit: :microseconds

# config :prometheus, Letzell.PipelineInstrumenter,
#   labels: [:status_class, :method, :host, :scheme, :request_path],
#   registry: :default,
#   duration_unit: :microseconds

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason

# -- ExAws Configuration
config :ex_aws,
  debug_requests: true,
  json_codec: Jason,
  access_key_id: "004a33f18e0fc690000000001",
  secret_access_key: "K004bJ9OLAZEr0SnHYStlqbCiYyVl0I"


config :ex_aws, :s3,
  scheme: "https://",
  host: "s3.us-west-004.backblazeb2.com"


# -- End ExAws Configuration

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env()}.exs"
