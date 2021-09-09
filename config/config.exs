import Config

# Configuracion general de la aplicacion
config :maildirstats,
  maildir_path: '/var/vmail/policia.rionegro.gov.ar',
  # TODO: ver si se puede ofuscar colocando en una variable de entorno.
  ldap: [
    user: "ebox",
    password: "ENRW2AiRbKp.Ta.E"
  ],
  ssh: [
    ip: '10.11.37.213',
    user: 'soporte',
    password: 'soporte',
    negotiation_timeout: :infinity
  ],
  # Destinatario/s de los emails de reportes
  mail_recipients: [
    "hdjalabert@policia.rionegro.gov.ar"
  ]

# Configuracion de Logger
# NOTE: Para ver mas niveles de log, ver documentacion oficial
#         - https://hexdocs.pm/logger/1.12/Logger.html
config :logger, level: :error

# Configuraciones varias de elixir
config :elixir, :time_zone_database, Tzdata.TimeZoneDatabase

# Configuracion de base de datos en disco
config :mnesia,
  dir: '.mnesia/#{Mix.env()}/#{node()}'

# Configuracion de Scheduler, jobs tipo cron
config :maildirstats, Maildirstats.Scheduler,
  timezone: "America/Argentina/Ushuaia",
  jobs: [
    # {"@daily", fn -> Maildirstats.fetch_and_persist() end}
    # {"@monthly", fn -> Maildirstats.Mail.send_report() end}
  ]

# Configuracion de la libreria que envia emails
config :maildirstats, Maildirstats.Mail.Mailer,
  adapter: Bamboo.SMTPAdapter,
  server: "10.11.37.2",
  hostname: "policia.rionegro.gov.ar",
  port: 25,
  username: "hdjalabert@policia.rionegro.gov.ar",
  password: "31860933Ya",
  tls: :never,
  ssl: false,
  retries: 1,
  no_mx_lookups: false,
  auth: :if_available

# Configuracion libreria LDAP
config :paddle, Paddle,
  host: "10.11.37.2",
  base: "dc=vs-zmaster,dc=policia,dc=rionegro,dc=gov,dc=ar",
  ssl: false,
  port: 389,
  ipv6: false,
  tcpopts: [],
  timeout: 3000,
  account_subdn: "ou=Users"

# Configuracion de delimitadores y separadores para numeros utilizados por la
# libreria FileSize
config :number,
  delimit: [delimiter: ".", separator: ","]
