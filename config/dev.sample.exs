use Mix.Config

# Configure your database
config :pento, Pento.Repo,
  username: "postgres",
  password: "postgres",
  database: "pento_dev",
  hostname: "localhost",
  show_sensitive_data_on_connection_error: true,
  pool_size: 10
