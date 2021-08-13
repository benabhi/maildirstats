defmodule Maildirstats.Scheduler.Job.SaveData do
  @moduledoc """
  TODO: Documentar
  """

  alias Maildirstats.Scheduler.Job

  @behaviour Job

  @impl Job
  def name(), do: :savedata

  @impl Job
  def schedule(), do: "0 10 * * *"

  @impl Job
  def task(), do: fn ->
    for d <- Maildirstats.Memory.get() do
      Maildirstats.Mnesia.Table.Maildir.write(d)
    end
  end
end
