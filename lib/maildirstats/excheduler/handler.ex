defmodule Maildirstats.Scheduler.Handler do
  @moduledoc """
  TODO: Documentar
  """

  import Crontab.CronExpression

  @doc """
  TODO: Documentar
  """
  @spec add_job(atom()) :: :ok
  def add_job(job) do
    parse_job(job)
    |> Maildirstats.Scheduler.add_job()
  end

  @doc """
  TODO: Documentar
  """
  @spec add_multiple_jobs(jobs :: [atom()]) :: :ok | [:ok]
  def add_multiple_jobs(jobs) when is_list(jobs) do
    for job <- jobs, do: add_job(job)
  end

  @doc """
  TODO: Documentar
  """
  @spec parse_job(job :: atom()) :: Quantum.Job.t()
  def parse_job(job) do
    Maildirstats.Scheduler.new_job()
    |> Quantum.Job.set_name(job.name())
    |> Quantum.Job.set_schedule(~e[#{job.schedule()}])
    |> Quantum.Job.set_task(job.task())
  end
end
