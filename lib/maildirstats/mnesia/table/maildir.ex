defmodule Maildirstats.Mnesia.Table.Maildir do
  use Memento.Table,
    # NOTE: El macro `Memento.Table` crea automaticamente un struct con los
    #       key pasados al parametro "attributes" con valores nil por defecto.
    attributes: [:account, :path, :size, :fdates, :fcount, :date],
    type: :bag

  # Helpers

  @doc """
  Shortcut/Wrapper de la libreria `Memento` que muestra todos los registros de
  la tabla.
  """
  def find_all() do
    Memento.transaction!(fn ->
      Memento.Query.all(__MODULE__)
    end)
  end

  @doc """
  Shortcut/Wrapper de la libreria `Memento` que muestra un registro
  determinado de la tabla.
  """
  def find(account) do
    Memento.transaction!(fn ->
      Memento.Query.select(__MODULE__, {:==, :account, account})
    end)
  end

  @doc """
  Shortcut/Wrapper de la libreria `Memento` que escribe un nuevo registro
  en la base de datos.
  """
  def save(maildir_data) do
    Memento.transaction!(fn ->
      Memento.Query.write(maildir_data)
    end)
  end

  @doc """
  TODO: documentar
  """
  def save_all(data) do
    for records <- data do
      for record <- records do
        Memento.transaction!(fn ->
          Memento.Query.write(record)
        end)
      end
    end
  end

  @doc """
  EShortcut/Wrapper de la libreria `Memento`  que elimina todos los registros
  de la base de datos.
  """
  def clear(), do: Memento.Table.clear(__MODULE__)
end
