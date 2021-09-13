defmodule Maildirstats.Stats do

  defp calculate_size_variation(data) do
    data = data
    |> Enum.reverse()
    |> Enum.with_index()

    for {{date, size, record}, index} <- data do
      if index != 0 do
        {{_d, previous_size, _r}, _i} = Enum.fetch!(data, (index - 1))
        {date, size, FileSize.subtract(size, previous_size), record}
      else
        {date, size, FileSize.new(0, :b), record}
      end
    end
    |> Enum.reverse()
  end

  defp beetween_dates(data, interval) do
    # 1. Verifica que la fecha del registro este en el intervalo deseado
    data
    |> Enum.filter(& (&1.date in interval))
  end

  defp sort_and_clean(data) do
    # 2. Ordena por fecha de mayor a menor (la ultima primero)
    # 3. Remueve los dias duplicados
    # 4. Retorna una lista de tuplas con fecha y peso
    data
    |> Enum.sort(& (Timex.compare(&1.date, &2.date) == -1))
    |> Enum.uniq_by(&(Timex.to_date(&1.date)))
    |> Enum.map(&({&1.date, &1.size, &1}))
  end

  # Helpers
  def days_ago_interval(days_ago)  do
    from = Timex.shift(Timex.now(), days: -days_ago)
    until = Timex.now()

    Timex.Interval.new(from: from, until: until)
  end

end
