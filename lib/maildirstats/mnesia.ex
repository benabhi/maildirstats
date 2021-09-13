defmodule Maildirstats.Mnesia do
  @moduledoc """
  Shortcut de funciones contenidas en el namespace
  `Maildirstats.Mnesia.Table.Maildir`.
  """

  alias Maildirstats.Mnesia.Table.Maildir, as: DB

  # Shorcuts

  @doc false
  def find(account), do: DB.find(account)
  @doc false
  def find_all(), do: DB.find_all()
  @doc false
  def clear(), do: DB.clear()
end
