defmodule SanchonetExplorer.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      SanchonetExplorerWeb.Telemetry,
      SanchonetExplorer.Repo,
      {DNSCluster,
       query: Application.get_env(:sanchonet_explorer, :dns_cluster_query) || :ignore},
      {Phoenix.PubSub, name: SanchonetExplorer.PubSub},
      {Finch, name: SanchonetExplorer.Finch},
      {SanchonetExplorer.PoolInfo, pool_info_opts()},
      SanchonetExplorerWeb.Endpoint
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: SanchonetExplorer.Supervisor]
    Supervisor.start_link(children, opts)
  end

  defp pool_info_opts do
    :sanchonet_explorer
    |> Application.get_env(SanchonetExplorer.PoolInfo)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  @impl true
  def config_change(changed, _new, removed) do
    SanchonetExplorerWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
