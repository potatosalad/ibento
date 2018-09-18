# Since configuration is shared in umbrella projects, this file
# should only configure the :ibento application itself
# and only for organization purposes. All other config goes to
# the umbrella root.
use Mix.Config

config :ibento,
  ecto_repos: [Ibento.Repo]

import_config "#{Mix.env()}.exs"
