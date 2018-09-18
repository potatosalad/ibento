# Since configuration is shared in umbrella projects, this file
# should only configure the :ibento application itself
# and only for organization purposes. All other config goes to
# the umbrella root.
use Mix.Config

# Configure your database
config :ibento, Ibento.Repo,
  username: "postgres",
  password: "postgres",
  database: "ibento_test",
  hostname: "localhost",
  pool: Ecto.Adapters.SQL.Sandbox
