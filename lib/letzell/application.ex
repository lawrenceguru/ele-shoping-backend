defmodule Letzell.Application do
  use Application

  # alias Letzell.{
  #   PhoenixInstrumenter,
  #   PipelineInstrumenter,
  #   PrometheusExporter,
  #   RepoInstrumenter
  # }

  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  def start(_type, _args) do
    import Supervisor.Spec

    # Prometheus
    # require Prometheus.Registry
    # PhoenixInstrumenter.setup()
    # PipelineInstrumenter.setup()
    # RepoInstrumenter.setup()

    # if :os.type() == {:unix, :linux} do
    #   Prometheus.Registry.register_collector(:prometheus_process_collector)
    # end

    # PrometheusExporter.setup()

    # Define workers and child supervisors to be supervised
    children = [
      # Start the Ecto repository
      Letzell.Repo,
      # supervisor(Letzell.LookupRepo, []),
      # Start the endpoint when the application starts
      LetzellWeb.Endpoint,
      Letzell.Vault,
      # Letzell.Workers.ProcessListing,
      {Phoenix.PubSub, [name: Letzell.PubSub, adapter: Phoenix.PubSub.PG2]},
      # Start your own worker by calling: Letzell.Worker.start_link(arg1, arg2, arg3)
      # worker(Letzell.Worker, [arg1, arg2, arg3]),
      {Absinthe.Subscription, [LetzellWeb.Endpoint]},
      {Cachex, name: :meta_cache, id: :meta_101},
      supervisor(Letzell.PostalCode.Supervisor, [])
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: Letzell.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  def config_change(changed, _new, removed) do
    LetzellWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
