defmodule Maildirstats do
  @moduledoc """
  TODO: Documentar
  """

  def stats() do
    __MODULE__.Ssh.call_list()
    |> Enum.chunk_every(5)
    |> Enum.each(fn chunk_dirs ->
      chunk_dirs
      |> Enum.map(
        &Task.async(fn ->
          __MODULE__.Ssh.cast_size(&1)
        end)
      )
      |> Enum.map(&Task.await(&1, :infinity))
    end)
  end

  def stats2() do
    __MODULE__.Ssh.call_list()
    |> Enum.map(
      &Task.async(fn ->
        __MODULE__.Ssh.cast_size(&1)
      end)
    )
    |> Enum.map(&Task.await(&1, :infinity))
  end
end
