defmodule Maildirstats.Mnesia.Fixture do
  @moduledoc """
  Genera un fixture sencillo de varios registros aleatorios en un rango de
  tiempo para realizar pruebas.
  """
  alias Maildirstats.Mnesia
  alias Maildirstats.Mnesia.Table.Maildir, as: Record
  alias Faker.Person

  # Chance estandar
  @standarchance 1..100
  # Chance de que se borre un registro
  @deletedchance 0.07
  # Tamaño inicial de las carpetas
  @rangesize 2500..50000
  # Rango de aumento/disminucion tamaño carpeta
  @rangesizechange 0..5000
  # Cantidad de archivos iniciales
  @rangefcount 100..400
  # Rango de aumento/disminucion cantidad archivos
  @rangefcountchange 0..10

  # Genera el fixture y lo guarda en la base de datos
  def generate_and_persist(num_records, num_days, start_date \\ Timex.now())
  def generate_and_persist(0, _num_days, _start_date), do: []
  def generate_and_persist(_num_records, 0, _start_date), do: []

  def generate_and_persist(num_records, num_days, start_date) do
    Mnesia.save_all(generate(num_records, num_days, start_date))
  end

  # Genera el fixture
  def generate(num_records, num_days, start_date \\ Timex.now())
  def generate(0, _num_days, _start_date), do: []
  def generate(_num_records, 0, _start_date), do: []
  def generate(num_records, num_days, start_date) do
    record_list(num_records, start_date)
    |> next_x_days(num_days)
  end

  defp next_x_days(records, numdays, acc \\ [])
  # Si es un solo registro metemos todos los dias en una sola lista
  defp next_x_days([_record], 0, acc) do
    [zipped_data] = Enum.zip(acc)
    [Tuple.to_list(zipped_data)]
  end
  defp next_x_days(_records, 0, acc), do: acc

  defp next_x_days(records, num_days, [] = acc) do
    next_x_days(records, num_days - 1, acc ++ [records])
  end

  defp next_x_days(records, num_days, acc) do
    next_x_days(records, num_days - 1, acc ++ [next_day(List.last(acc))])
  end

  defp next_day(records, acc \\ [])
  defp next_day([], acc), do: acc

  defp next_day([record | tail], acc) do
    chance = Enum.random(@standarchance)

    # NOTE: Toda esta logica podria estar abstraida en otra funcion pero como
    #       este fixture es solo para pruebas...
    cond do
      # Como los numeros son enteros y yo quiero una dificultad extremadamente
      # dificil (deberia ser con numeros decimales) a la chance actual de 1%
      # le sumo otra dificultad para lograr bajar las chances.
      chance < 2 && Float.round(:rand.uniform() * 100, 2) <= @deletedchance ->
        next_day(tail, acc)

      # 4% de chance de restar cantidad archivos y peso de la carpeta
      chance < 5 ->
        next_day(
          tail,
          acc ++
            [
              %{
                record
                | date: Timex.shift(record.date, days: 1),
                  fcount: record.fcount - Enum.random(@rangefcountchange),
                  size:
                    FileSize.subtract(
                      record.size,
                      FileSize.new(Enum.random(@rangesizechange), :b)
                    )
              }
            ]
        )

      # Posibilidad de que suba el tamaño
      chance < 15 ->
        next_day(
          tail,
          acc ++
            [
              %{
                record
                | date: Timex.shift(record.date, days: 1),
                  fcount: record.fcount + Enum.random(@rangefcountchange),
                  size:
                    FileSize.add(
                      record.size,
                      FileSize.new(Enum.random(@rangesizechange), :b)
                    )
              }
            ]
        )

      # Posibilidad de que quede como estaba
      true ->
        next_day(
          tail,
          acc ++
            [
              %{
                record
                | date: Timex.shift(record.date, days: 1)
              }
            ]
        )
    end
  end

  # Genera una lista de reigstros aleatorios
  def record_list(max, date \\ Timex.now()) do
    username_list(max)
    |> Enum.map(fn user ->
      size = Enum.random(@rangesize)
      fcount = Enum.random(@rangefcount)
      generate_record(user, size, fcount, date)
    end)
  end

  # Genera un registro
  defp generate_record(username, size, fcount, date) do
    %Record{
      __meta__: Memento.Table,
      account: username,
      date: date,
      fcount: fcount,
      # Llenar luego si hace falta en las pruebas
      fdates: {},
      path: "/var/vmail/policia.rionegro.gov.ar/#{username}",
      size: FileSize.new(size, :b)
    }
  end

  # Genera una lista de una determinada cantidad de usuarios aleatorios
  defp username_list(max) do
    1..max
    |> Enum.map(fn _i -> username() end)
  end

  # Crea un nombre de usuario con formato:
  # 1. inciial primer nombre
  # 2. inicial segundo nombre
  # 2. apellido completo
  defp username() do
    random_letter() <>
      random_letter() <>
      String.downcase(Person.last_name())
  end

  # Selecciona una letra al azar
  defp random_letter() do
    List.to_string([Enum.random(?a..?z)])
  end
end
