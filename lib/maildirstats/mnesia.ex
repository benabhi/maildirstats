defmodule Maildirstats.Mnesia do
  @moduledoc """
  Shortcut de funciones contenidas en el namespace
  `Maildirstats.Mnesia.Table.Maildir`.
  """

  alias Maildirstats.Mnesia.Table.Maildir, as: DB

  # Shorcuts

  def find(account), do: DB.find(account)
  def find_all(), do: DB.find_all()
  def save(record), do: DB.save(record)
  def save_all(records), do: DB.save_all(records)
  def clear(), do: DB.clear()
end
