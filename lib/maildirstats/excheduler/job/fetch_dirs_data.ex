defmodule Maildirstats.Scheduler.Job.FetchDirsData do
  @moduledoc """
  TODO: Documentar
  """

  alias Maildirstats.Scheduler.Job

  @behaviour Job

  @impl Job
  def name(), do: :fetchdirsdata

  @impl Job
  def schedule(), do: "50 09 * * *"

  @impl Job
  def task(), do: fn ->
    Maildirstats.Memory.clear()
    Maildirstats.fetch_dirs()
  end
end
