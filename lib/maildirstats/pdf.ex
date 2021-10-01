defmodule Maildirstats.Pdf do
  # TODO: Agregar en config?
  @papersize "A4"
  @outputdirectory Path.join(File.cwd!(), "output")

  def generate(html) do
    {:ok, filename} = PdfGenerator.generate(html, page_size: @papersize)
    File.rename(filename, Path.join(@outputdirectory, random_name()))
  end

  # Para que no se pisen los pdf
  # TODO: reemplazar por algo mas legible
  defp random_name(), do: "#{:os.system_time}.pdf"
end
