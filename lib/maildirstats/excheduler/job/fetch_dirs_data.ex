defmodule Maildirstats.Scheduler.Job.FetchDirsData do
  @moduledoc """
  TODO: Documentar
  """

  alias Maildirstats.Scheduler.Job

  @behaviour Job

  @impl Job
  def name(), do: :fetchdirsdata

  @impl Job
  def schedule(), do: "* * * * *"

  @impl Job
  # def task(), do: fn -> Maildirstats.fetch() end
  def task(), do: fn -> nil end
end
