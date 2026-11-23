defmodule LibraryLendingApi.Application do
  # See https://elixir.hexdocs.pm/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      LibraryLendingApiWeb.Telemetry,
      LibraryLendingApi.Repo,
      {DNSCluster,
       query: Application.get_env(:library_lending_api, :dns_cluster_query) || :ignore},
      {Phoenix.PubSub, name: LibraryLendingApi.PubSub},
      # Start a worker by calling: LibraryLendingApi.Worker.start_link(arg)
      # {LibraryLendingApi.Worker, arg},
      # Start to serve requests, typically the last entry
      LibraryLendingApiWeb.Endpoint
    ]

    # See https://elixir.hexdocs.pm/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: LibraryLendingApi.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  @impl true
  def config_change(changed, _new, removed) do
    LibraryLendingApiWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
