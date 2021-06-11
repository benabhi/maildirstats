defmodule Maildirstats.Scheduler.Job do
  @moduledoc """
  Define el comportamiento (behavior) de un Job, haciendo que sea necesario la
  implementacion de las funciones declaradas en este modulo.
  """

  @doc "Retorna el nombre del Job"
  @callback name() :: atom()

  @doc "Retorna una expresion de cron ej: \"* * * * *\""
  @callback schedule() :: String.t()

  @doc """
  Retorna una funcion anonima con la tarea que debe com cumplir el job.

  Debe retornar una funcion anonima, que esta a su vez, retorne :ok
  """
  @callback task() :: (-> :ok)
end
