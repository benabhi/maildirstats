defmodule Maildirstats.CLI do
  def main(argv) do
    arguments =
      Optimus.new!(
        name: "statcalc",
        description: "Estadisticas de espacio de emails.",
        version: "0.1.0",
        author: "Hernan Jalabert <benabhi@gmail.com>",
        about:
          "Utilidad para obtener diversa informacion y estadisticas con respecto al peso de las carpetas de emails de Policia de Rio Negro.",
        allow_unknown_args: false,
        parse_double_dash: true,
        args: [
          infile: [
            value_name: "INPUT_FILE",
            help: "File with raw data",
            required: true,
            parser: :string
          ],
          outfile: [
            value_name: "OUTPUT_FILE",
            help: "File to write statistics to",
            required: false,
            parser: :string
          ]
        ],
        flags: [
          print_header: [
            short: "-h",
            long: "--print-header",
            help: "Specifies wheather to print header before the outputs",
            multiple: false
          ],
          verbosity: [
            short: "-v",
            help: "Verbosity level",
            multiple: true
          ]
        ],
        options: [
          date_from: [
            value_name: "DATE_FROM",
            short: "-f",
            long: "--from",
            help: "Start date for the period",
            parser: fn s ->
              case Date.from_iso8601(s) do
                {:error, _} -> {:error, "invalid date"}
                {:ok, _} = ok -> ok
              end
            end,
            required: true
          ],
          date_to: [
            value_name: "DATE_TO",
            short: "-t",
            long: "--to",
            help: "End date for the period",
            parser: fn s ->
              case Date.from_iso8601(s) do
                {:error, _} -> {:error, "invalid date"}
                {:ok, _} = ok -> ok
              end
            end,
            required: false,
            default: &Date.utc_today/0
          ]
        ],
        subcommands: [
          validate: [
            name: "validate",
            about: "Validates the raw contents of a file",
            args: [
              file: [
                value_name: "FILE",
                help: "File with raw data to validate",
                required: true,
                parser: :string
              ]
            ]
          ]
        ]
      )
      |> Optimus.parse!(argv)

    IO.inspect(arguments)
  end
end
