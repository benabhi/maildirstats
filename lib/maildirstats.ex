defmodule Maildirstats do
  @moduledoc """
  TODO: Documentar
  """

  def fetch_dirs() do
    {:ok, dirs} = Maildirstats.Ssh.list()

    dirs
    |> Enum.map(&Task.async(fn -> Maildirstats.Ssh.stats(&1) end))
    |> Enum.map(&Task.await(&1, :infinity))
  end

  def fetch() do
    Maildirstats.Memory.clear()
    {:ok, conn} = Maildirstats.Ssh.Funcs.conn()
    {:ok, dirs} = Maildirstats.Ssh.Funcs.maildir_list(conn)

    dirs
    |> Enum.map(
      &Task.async(fn ->
        Maildirstats.Ldap.get_user_details(&1)
      end)
    )
    |> Enum.map(&Task.await(&1, :infinity))
  end

  def fetch_ldap() do
    # TODO
  end

  def save() do
    # TODO
  end
end
