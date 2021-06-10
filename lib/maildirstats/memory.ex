defmodule Maildirstats.Memory do
  use Agent
  require Logger

  def start_link([]) do
    Logger.debug("[Agent] Memory initialized...")
    Agent.start_link(fn -> [] end, name: __MODULE__)
  end

  def clear() do
    Agent.update(__MODULE__, fn _state -> [] end)
  end

  def get() do
    Agent.get(__MODULE__, & &1)
  end

  def add(dir) do
    Agent.update(__MODULE__, &(&1 ++ [dir]))
  end

  def count() do
    Agent.get(__MODULE__, & &1)
    |> Enum.count()
  end
end
