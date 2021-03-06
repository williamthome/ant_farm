defmodule AntFarm.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      # Start the Telemetry supervisor
      AntFarmWeb.Telemetry,
      # Start the PubSub system
      {Phoenix.PubSub, name: AntFarm.PubSub},
      # Start the Endpoint (http/https)
      AntFarmWeb.Endpoint,
      # Create the Ant Registry
      {Registry, keys: :unique, name: AntFarm.Ant.Registry},
      # Start the Incrementer supervisor
      AntFarm.Incrementer,
      # Start the Ant Colony dynamic supervisor
      AntFarm.Colony.Supervisor
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: AntFarm.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  @impl true
  def config_change(changed, _new, removed) do
    AntFarmWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
