defmodule Maildirstats.Application do
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    # Crea la base de datos Mnesia y las tablas correspondientes, en disco
    Maildirstats.Mnesia.Schema.run()

    children = [
      Maildirstats.Scheduler,
      Maildirstats.Memory,
      Maildirstats.Logger,
      Maildirstats.Ssh,
      Maildirstats.Ldap
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: Maildirstats.Supervisor]
    Supervisor.start_link(children, opts)
  end
end
