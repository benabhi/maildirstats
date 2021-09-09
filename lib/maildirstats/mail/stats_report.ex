defmodule Maildirstats.Mail.StatsReport do
  import Bamboo.Email

  def send_report() do
    new_email(
      to: "hdjalabert@policia.rionegro.gov.ar",
      from: "maildirstats",
      subject: "Estadisticas de directorios de emails.",
      html_body: "<h1>Aca el reporte</h1>",
      text_body: ""
    )
    |> Maildirstats.Mail.Mailer.deliver_now!()
  end
end
