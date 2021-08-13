defmodule Maildirstats.Ssh.Funcs do
  @moduledoc """
  Funciones diversas para obtener informacion mediante SSH de las carpetas de
  correos de usuarios ubicadas en `maildir_path` (ver config).

  Este modulo hace uso de la libreria `SSHEx`, para mas informacion:

    - https://hexdocs.pm/sshex/api-reference.html
    - https://github.com/rubencaro/sshex
  """

  alias Maildirstats.Mnesia.Table.Maildir

  @maildir_path Application.fetch_env!(:maildirstats, :maildir_path)
  @conndata Application.fetch_env!(:maildirstats, :ssh)

  @doc """
  Retorna una lista con los nombres de todos los directorios de la carpeta
  `maildir_path` (ver config).

  TODO: Ejemplos, doctests?
  """
  @spec maildir_list(conn :: pid()) :: {:ok, list(String.t())} | {:error, String.t()}
  def maildir_list(conn) do
    cmd = 'ls #{@maildir_path}'

    case SSHEx.run(conn, cmd) do
      {:ok, output, 0} ->
        {:ok,
         output
         |> String.split("\n")
         |> Enum.reject(&(&1 == ""))}

      {:ok, err, _code} ->
        {:error, err}
    end
  end

  @doc """
  Devuelve el tamaño (peso) de una carpeta especifica del directorio
  `maildir_path` (ver config) expresados en bytes.

  TODO: Ejemplos, doctests?
  """
  @spec maildir_size(conn :: pid(), dir :: String.t()) :: {:ok, FileSize.t()} | {:error, String.t()}
  def maildir_size(conn, dir) do
    path = Path.join(@maildir_path, dir)
    cmd = 'du -s #{path}'

    case SSHEx.run(conn, cmd) do
      {:ok, output, 0} ->
        {:ok,
         output
         |> String.trim()
         |> String.split("\t")
         |> List.first()
         |> String.to_integer()
         |> FileSize.new(:b)}

      {:ok, err, _code} ->
        {:error, err}
    end
  end

  @doc """
  Retorna una tupla de 3 fechas (access, modify & change dates), obtenidas con
  el comando stats de linux (DateTimes).

  TODO: Ejemplos, doctests?
  """
  @spec maildir_dates(conn :: pid(), dir :: String.t()) ::
          {:ok, {DateTime.t(), DateTime.t(), DateTime.t()}} | {:error, String.t()}
  def maildir_dates(conn, dir) do
    path = Path.join(@maildir_path, dir)
    cmd = 'stat --format=\'%X,%Y,%Z\' #{path}'

    case SSHEx.run(conn, cmd) do
      {:ok, output, 0} ->
        {:ok,
         output
         |> String.trim()
         |> String.split(",")
         |> Enum.map(fn date ->
           date
           |> String.to_integer
           |> Timex.from_unix
          end)
         |> List.to_tuple()}

      {:ok, err, _code} ->
        {:error, err}
    end
  end

  @doc """
  Retorna un diccionario con los datos de la carpeta buscada.

  Los valores obtenidos son los siguientes:
    * `account`: Nombre de la cuenta (o nombre de la carpeta, es =)
    * `path`: Path absoluto a la carpeta
    * `size`: Tañao de la carpeta en bytes
    * `fdates`: Tupla de 3 items, {acceso, modificacion, creacion},
    * `date`: Fecha y hora en la que fue solicitada la informacion

  TODO: Ejemplos, doctests?
  """
  @spec maildir_stats(conn :: pid(), dir :: String.t()) :: {:ok, %Maildir{}} | {:error, String.t()}
  def maildir_stats(conn, dir) do
    path = Path.join(@maildir_path, dir)

    with {:ok, size} <- maildir_size(conn, dir),
         {:ok, {atime, mtime, ctime}} <- maildir_dates(conn, dir) do
      {:ok,
       %Maildir{
         account: dir,
         path: path,
         size: size,
         fdates: {atime, mtime, ctime},
         date: Timex.now()
       }}
    else
      error -> error
    end
  end

  # Helpers

  # Conexion en formato {:ok, pid}
  def conn(), do: SSHEx.connect(@conndata)

  # Conexion, solo pid
  def conn!() do
    {:ok, conn} = SSHEx.connect(@conndata)
    conn
  end
end
