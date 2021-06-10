defmodule Maildirstats.Mnesia.Table.Dirs do
  use Memento.Table,
    attributes: [:account, :path, :size, :date],
    type: :bag
end
