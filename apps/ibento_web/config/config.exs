# Since configuration is shared in umbrella projects, this file
# should only configure the :ibento_web application itself
# and only for organization purposes. All other config goes to
# the umbrella root.
use Mix.Config

# General application configuration
config :ibento_web,
  ecto_repos: [Ibento.Repo],
  generators: [context_app: :ibento]

# Configures the endpoint
config :ibento_web, IbentoWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "jsBGGigUYiHC/rMXtEUHbJ/83NqybYAkBaGLXYm8iNNbdPkQv2Z6CdWzZLLfVcYY",
  render_errors: [view: IbentoWeb.ErrorView, accepts: ~w(html json)],
  pubsub: [name: IbentoWeb.PubSub, adapter: Phoenix.PubSub.PG2]

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env()}.exs"
