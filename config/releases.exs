import Config

config :qr_code_server, QrCodeServerWeb.Endpoint,
  url: [host: System.get_env("HOST"), port: {:system, "PORT"}],
  http: [:inet6, port: {:system, "PORT"}],
  secret_key_base: System.get_env("SECRET_KEY_BASE")
