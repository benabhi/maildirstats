defmodule Maildirstats do
  @moduledoc """
  TODO: Documentar
  """

  def fetch() do
    case Maildirstats.Ssh.list() do
      {:ok, dirs} ->
        dirs
        |> Enum.map(&Maildirstats.Ssh.stats(&1))
      {:error, error} ->
        Maildirstats.Logger.log({:error, :ssh, error})
    end
  end

  def persist(data) do
    data
    |> Enum.each(fn maildir ->
      case maildir do
        {:ok, data} ->
          Maildirstats.Mnesia.Table.Maildir.save(data)
        {:error, error} ->
          Maildirstats.Logger.log({:error, :ssh, error})
      end
    end)
  end

  def fetch_and_persist(), do:  persist(fetch())
end
