defmodule Maildirstats.Stats2 do



  def daily(data) do
    data
    |> sort_by_recent_date()
    |> ensure_one_for_day()
    |> output_format()
    |> calculate_size_variation()
  end

  def calculate_size_variation(data) do
    data = data
    |> to_tuple()
    |> Enum.reverse()
    |> Enum.with_index()

    for {{date, size, record}, index} <- data do
      if index != 0 do
        {{_d, previous_size}, _i} = Enum.fetch!(data, (index - 1))
        {date, size, FileSize.subtract(size, previous_size), record}
      else
        {date, size, FileSize.new(0, :b), record}
      end
    end
    |> Enum.reverse()
  end

  defp interval_filter(data, interval) do
    # 1. Verifica que la fecha del registro este en el intervalo deseado
    # 2. Ordena por fecha de mayor a menor (la ultima primero)
    # 3. Remueve los dias duplicados
    # 4. Retorna una lista de tuplas con fecha y peso
    data
    |> Stream.filter(& (&1.date in interval))
    |> sort_by_recent_date()
    |> ensure_one_for_day()
    |> output_format()
  end

  # Helpers

  defp sort_by_recent_date(data) do
    data
    |> Enum.sort(& (Timex.compare(&1.date, &2.date) == 1))
  end

  defp ensure_one_for_day(data) do
    data
    |> Stream.uniq_by(&(Timex.to_date(&1.date)))
  end

  defp output_format(data) do
    data
    |> Enum.map(&({&1.date, &1.size}))
  end

  defp to_tuple(data) do
    data
    |> Enum.map(&({&1.date, &1.size, &1}))
  end

end
