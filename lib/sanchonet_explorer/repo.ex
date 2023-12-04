defmodule SanchonetExplorer.Repo do
  use Ecto.Repo,
    otp_app: :sanchonet_explorer,
    adapter: Ecto.Adapters.Postgres
end
