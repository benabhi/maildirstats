defmodule Maildirstats.Stats do
  alias Maildirstats.Mnesia

  # resumen de un usuario
  def summary(), do: summary(Mnesia.find_all())

  def summary(records) when is_list(records) do
    total_records =
      records
      |> Enum.count()

    total_users =
      records
      |> Enum.map(& &1.account)
      |> Enum.uniq()
      |> Enum.count()

    {total_size, total_files} =
      records
      |> Enum.group_by(& &1.account)
      |> Enum.into([])
      |> Enum.map(fn {_u, data} ->
        Enum.sort(data, &(Timex.compare(&1.date, &2.date) == 1))
      end)
      |> Enum.map(&List.first/1)
      |> Enum.map(&{&1.size, &1.fcount})
      |> Enum.reduce({FileSize.new(0, :b), 0}, fn {s, f}, acc ->
        {FileSize.add(elem(acc, 0), s), elem(acc, 1) + f}
      end)

    %{
      totalUsers: total_users,
      totalRecords: total_records,
      totalSize: total_size,
      totalFiles: total_files
    }
  end

  # TODO: Resumen de cuenta individual
  # def account(account) when is_binary(account) do
  #  summary(Mnesia.find(user))
  # end

  # def account(account) do
  #
  # end

  # def compare_daily(data, acc \\ [])
  # def compare_daily([], acc), do: Enum.reverse(acc)
  # def compare_daily([record], acc) do
  #   inspect(record)
  #   compare_daily([], acc ++ [{record.date, record.size, FileSize.new(0, :b), record}])
  # end
  # def compare_daily([record1, record2 | _others] = data, acc) do
  #   variation = FileSize.subtract(record1.size, record2.size, :b)
  #   compare_daily(
  #     data -- [record1],
  #     acc ++ [{record1.date, record1.size, variation, record1}]
  #   )
  # end

  # TODO: Implementar una funcion que llene los espacios de los dias que no se
  #       recogieron datos
  #
  # Ej:
  #     16-03-2021: 500mb
  #     17-03-2021: 501mb
  #     :nil                <-- Aca falto un dia
  #     19-03-2021: 501mb
  #
  def fill_the_gaps(_data) do
    # TODO: Logic
  end


  # [
  #
  #   {interval, total_size, variation, records}
  #
  # ]

  def weekly_size_variation(data) do
    data
    #|> daily_size_variation()
    |> Enum.chunk_every(7)
    |> Enum.map(fn
     records ->
        records
        #|> Enum.map(fn {_date, size, _record} -> size end)
        #|> Enum.reduce(FileSize.new(0, :b), fn size, acc ->
        #  FileSize.add(acc, size, :b)
        #end)
    end)
  end

  def daily_size_variation(data, acc \\ [])
  def daily_size_variation([], acc), do: acc

  def daily_size_variation([{rdate, rsize, r}], acc) do
    daily_size_variation([], acc ++ [{rdate, rsize, FileSize.new(0, :b), r}])
  end

  def daily_size_variation(
        [{r1date, r1size, r1} = record1, {_r2date, r2size, _r2} | _others] = data,
        acc
      ) do
    variation = FileSize.subtract(r1size, r2size, :b)

    daily_size_variation(
      data -- [record1],
      acc ++ [{r1date, r1size, variation, r1}]
    )
  end

  def formating(data) do
    data
    |> Enum.sort(&(Timex.compare(&1.date, &2.date) == 1))
    |> Enum.uniq_by(&Timex.to_date(&1.date))
    |> Enum.map(&{&1.date, &1.size, &1})
  end
end
