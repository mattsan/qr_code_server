# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.

# General application configuration
use Mix.Config

# Configures the endpoint
config :qr_code_server, QrCodeServerWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "6w3JB1yYVoy/8U8oZiew/x28bMGJ/iD+L6z0zs2gpAPTPm/RC+/OumNkszJYSl5A",
  render_errors: [view: QrCodeServerWeb.ErrorView, accepts: ~w(html json)],
  pubsub: [name: QrCodeServer.PubSub, adapter: Phoenix.PubSub.PG2],
  live_view: [signing_salt: System.get_env("SECRET_SALT")]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env()}.exs"
