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
  def task() do
    fn ->

      Maildirstats.Memory.clear()

      {:ok, dirs} = Maildirstats.Ssh.call_list()

      dirs
      |> Enum.map(&Task.async(fn -> Maildirstats.Ssh.cast_size(&1) end))
      |> Enum.map(&Task.await(&1, :infinity))

      :ok
    end
  end

end
