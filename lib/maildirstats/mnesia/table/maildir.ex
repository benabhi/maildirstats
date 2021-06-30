defmodule Maildirstats.Mnesia.Table.Maildir do
  use Memento.Table,
    attributes: [:account, :path, :size, :fdates, :quota, :date],
    type: :bag

    def all() do
      Memento.transaction! fn ->
        Memento.Query.all(__MODULE__)
      end
    end

    def read(maildir_data) do
      Memento.transaction! fn ->
          # TODO
      end
    end

    def write() do
      Memento.transaction! fn ->
          # TODO
      end
    end
  end
