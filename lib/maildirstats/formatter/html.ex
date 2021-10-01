defmodule Maildirstats.Formatter.Html do

  def daily_report(_data) do
    html_wrapper([
      # Este meta es importante para la codificacion de caracteres
      [:meta, %{"charset" => "UTF-8"}],
      [:h1, "Reporte Diario"],
      [:hr],
      [:p, "Reporte de cambios en tamaños de direcotrios de casillas de correos."],
      [:table,
        [:tr,
          [:th, "Un titulo"],
          [:th, "otro titulo"]
        ],
        [:tr,
          [:td, "una fila"],
          [:td, "otra fila"]
        ]
      ]
    ])
  end

  defp html_wrapper(html) do
    Sneeze.render([
      [:__@raw_html, "<!DOCTYPE html>"],
      [:html,
        [:head,
          [:meta, %{"charset" => "UTF-8"}]
        ],
        [:body, html]
      ]
    ])
  end

end
