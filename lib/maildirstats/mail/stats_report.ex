defmodule Maildirstats.Mail.StatsReport do
  import Bamboo.Email

  def send_report() do
    new_email(
      to: "hdjalabert@policia.rionegro.gov.ar",
      from: "maildirstats",
      subject: "Estadisticas de directorios de emails.",
      html_body: "",
      text_body: "Aca va el reporte"
    )
  end
end
