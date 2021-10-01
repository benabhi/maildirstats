defmodule Maildirstats.CLI.Termgraph do
  def execute(data) do
    data = parse_data(data)

    ~s(script --return --quiet -c "echo -e \\"#{data}\\" | termgraph" /dev/null)
    |> String.to_charlist()
    |> :os.cmd()
  end

  def parse_data(data) do
    data
    |> Enum.map(fn {date, size, _change} ->
      size = FileSize.format(FileSize.convert(size, :kb), symbols: %{kb: ""})
      "#{date.day}-#{date.month}-#{date.year}\t#{String.trim(size)}"
    end)
    |> Enum.join("\n")
  end

  defp generate_header() do
    """
    Usuario: hdjalabert
    Quota: 250 MB
    Path: /var/vmail/policia.rionegro.gov.ar/hdjalabert
    Folder: hdjalabert
    Modify: update: 21.08 create: 21.08
    """
  end
end
