defmodule Bacia.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      BaciaWeb.Telemetry,
      Bacia.Repo,
      {DNSCluster, query: Application.get_env(:bacia, :dns_cluster_query) || :ignore},
      {Phoenix.PubSub, name: Bacia.PubSub},
      # Start the Finch HTTP client for sending emails
      {Finch, name: Bacia.Finch},
      # Start a worker by calling: Bacia.Worker.start_link(arg)
      # {Bacia.Worker, arg},
      # Start to serve requests, typically the last entry
      BaciaWeb.Endpoint,
      # Start transaction producer and consumer
      Bacia.Bank.Producers.Transaction,
      Bacia.Bank.Consumers.Transaction
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: Bacia.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  @impl true
  def config_change(changed, _new, removed) do
    BaciaWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
