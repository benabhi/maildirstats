defmodule Maildirstats.Mnesia.Schema do
  alias Maildirstats.Mnesia.Table

  @doc """
  TODO: Documentar
  """
  def run() do
    # Listado de nodos
    nodes = [node()]

    # Creamos el schema
    Memento.stop()
    Memento.Schema.create(nodes)
    Memento.start()

    # Creamos las copias en disco de las tablas
    Memento.Table.create(Table.Dirs, disc_copies: nodes)
  end
end
