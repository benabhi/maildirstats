defmodule Maildirstats.CLI do
  # alias Maildirstats.CLI.Account

  def main(argv) do
    # Argumentos crudos
    argv
    # Parseamos los argumentos
    |> parse_args()
    # Pattern matching para ejecutar el comando
    |> parse_command()
  end

  # NOTE: Nos aseguramos que solo haya un parametro
  # def parse_command(%{flags: %{daily: d, monthly: m, yearly: y}})  do
  # Contamos cuantos "true" tiene el array
  #  if(Enum.count([d, m, y], &(&1 == true)) > 1) do
  #    IO.puts("Solo se puede tener un parámetro activo -d | -m | -y")
  #  end
  # end

  def parse_command(%{options: %{account: account}, flags: %{daily: true}}) do
    # TODO
  end

  defp parse_args(argv) do
    Optimus.new!(
      name: "maildirsize",
      description: "Reportes y Estadística de cuentas y directorios de casillas de correos",
      version: "0.0.1",
      author: "Hernán Jalabert <benabhi@gmail.com>",
      about:
        "Utilidad que genera reportes y estadísticas de cuentas y directorios de casillas de correos",
      allow_unknown_args: false,
      parse_double_dash: true,
      options: [
        account: [
          value_name: "ACCOUNT",
          short: "-a",
          long: "--account",
          help: "Cuenta especifica a buscar",
          parser: :string,
          required: false
        ],
        max: [
          value_name: "MAX",
          short: "-M",
          long: "--max",
          help: "Cantidad maxima de registros a listar",
          parser: :integer,
          default: 10,
          required: false
        ],
        # TODO: Ver como parsear fechas
        interval: [
          value_name: "INTERVAL",
          short: "-i",
          long: "--interval",
          help: "Intervalo de fechas para buscar registros",
          parser: :integer,
          # default: 10,
          required: false
        ]
      ],
      flags: [
        daily: [
          short: "-d",
          long: "--daily",
          help: "Registros diarios",
          multiple: false
        ],
        monthly: [
          short: "-m",
          long: "--monthly",
          help: "Registros Mensuales (defecto)",
          multiple: false
        ],
        yearly: [
          short: "-y",
          long: "--yearly",
          help: "Registros Anuales",
          multiple: false
        ],
        direct: [
          short: "-D",
          long: "--direct",
          help: "Fuerza la busqueda directa, no lo guardado en base de datos",
          multiple: false
        ]
      ]
    )
    |> Optimus.parse!(argv)
  end
end
