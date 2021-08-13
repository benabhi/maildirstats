defmodule Maildirstats.Logger do
  use Agent
  require Logger

  def start_link([]) do
    Logger.debug("[Agent] Logger initialized...")
    Agent.start_link(fn -> [] end, name: __MODULE__)
  end

  def log({error_level, service, msg}) when is_atom(error_level) and is_atom(service) do
    log = [{Timex.now(), error_level, service, msg}]
    Agent.update(__MODULE__, &( &1 ++ log ))
  end

  def get() do
    Agent.get(__MODULE__, & &1)
  end

  def clear() do
    Agent.update(__MODULE__, fn _state -> [] end)
  end

  def count() do
    Agent.get(__MODULE__, & &1)
    |> Enum.count()
  end
end
