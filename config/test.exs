use Mix.Config

# We don't run a server during test. If one is required,
# you can enable the server option below.
config :letzell, LetzellWeb.Endpoint,
  http: [port: System.get_env("PORT") || 4000],
  server: true

config :letzell, :sql_sandbox, true

config :wallaby,
  driver: Wallaby.Experimental.Chrome,
  # screenshot_on_failure: true,
  screenshot_dir: "test/screenshots"

# Print only warnings and errors during test
config :logger, level: :warn

# Configure your database
config :letzell, Letzell.Repo,
  adapter: Ecto.Adapters.Postgres,
  username: System.get_env("POSTGRES_USER") || "postgres",
  password: System.get_env("POSTGRES_PASSWORD") || "postgres",
  database: System.get_env("POSTGRES_DB") || "listmaxx_graphql_test",
  hostname: System.get_env("POSTGRES_HOST") || "localhost",
  pool: Ecto.Adapters.SQL.Sandbox

# Configures Bamboo
config :letzell, Letzell.Mailer, adapter: Bamboo.TestAdapter

config :ex_aws,
  access_key_id: ["fake", :instance_role],
  secret_access_key: ["fake", :instance_role],
  region: "fakes3"

config :ex_aws, :s3,
  scheme: "http://",
  host: "localhost",
  port: 4567

config :arc,
  storage: Arc.Storage.S3,
  asset_host: "http://localhost:4567/letzell-phoenix-graphql",
  bucket: "letzell-phoenix-graphql"
