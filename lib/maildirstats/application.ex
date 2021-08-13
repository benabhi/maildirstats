defmodule Maildirstats.Application do
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    before_initialization_stuff()

    children = [
      Maildirstats.Scheduler,
      Maildirstats.Memory,
      Maildirstats.Logger,
      Maildirstats.Ssh,
      Maildirstats.Ldap,
      # NOTE: Este es un proceso que corre y muere luego de inicializar todos
      #       los demas procesos de la aplicacion para correr tareas de inicia-
      #       lizacion.
      {Task, fn -> after_initialization_stuff() end}
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: Maildirstats.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Colocar aqui tareas para ejecutar antes de inicializar la app
  defp before_initialization_stuff() do
    # Crea la base de datos Mnesia y las tablas correspondientes, en disco
    Maildirstats.Mnesia.Schema.run()
  end

  # Colocar aqui tareas para ejecutar despues de inicializar la app
  defp after_initialization_stuff() do
    # Incializamos taras automatizadas (cron)
    jobs = [
      Maildirstats.Scheduler.Job.FetchDirsData,
      Maildirstats.Scheduler.Job.SaveData
    ]

    Maildirstats.Scheduler.Handler.add_multiple_jobs(jobs)
  end
end
