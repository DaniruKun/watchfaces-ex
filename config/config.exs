# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.

# General application configuration
use Mix.Config

config :watch_faces,
  ecto_repos: [WatchFaces.Repo]

# Configures the endpoint
config :watch_faces, WatchFacesWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "yre70sPtw4LbbvJLY2wxskp8zIkYrMhLPuwYJNQro7gsb+zbwn3b+gBECL+dncSJ",
  render_errors: [view: WatchFacesWeb.ErrorView, accepts: ~w(html json), layout: false],
  pubsub_server: WatchFaces.PubSub,
  live_view: [signing_salt: "ifU/iQyJ"]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env()}.exs"
