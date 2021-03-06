use Mix.Config

# Only in tests, remove the complexity from the password hashing algorithm
config :bcrypt_elixir, :log_rounds, 1

# We don't run a server during test. If one is required,
# you can enable the server option below.
config :pento, PentoWeb.Endpoint,
  http: [port: 3379],
  server: false

# Print only warnings and errors during test
config :logger, level: :warn

import_config "test.secret.exs"
