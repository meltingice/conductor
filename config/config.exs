# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.

# General application configuration
use Mix.Config

config :conductor,
  ecto_repos: [Conductor.Repo]

# Configures the endpoint
config :conductor, ConductorWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "ZRmkjqnrm9Ej2EbV0ZKhF00+xuE+Ka8LzKN8R/2tltjEcjoV/wP4C+8o5YZMIZxp",
  render_errors: [view: ConductorWeb.ErrorView, accepts: ~w(html json), layout: false],
  pubsub_server: Conductor.PubSub,
  live_view: [signing_salt: "h7YlkE6x"]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env()}.exs"
