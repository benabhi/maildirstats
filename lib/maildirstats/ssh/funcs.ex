defmodule Maildirstats.Ssh.Funcs do
  @moduledoc """
  Funciones diversas para obtener informacion mediante SSH de las carpetas de
  correos de usuarios ubicadas en `maildir_path` (ver config).

  Este modulo hace uso de la libreria `SSHEx`, para mas informacion:

    - https://hexdocs.pm/sshex/api-reference.html
    - https://github.com/rubencaro/sshex
  """

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
  @spec maildir_size(conn :: pid(), dir :: String.t()) :: {:ok, integer()} | {:error, String.t()}
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
         |> String.to_integer()}

      {:ok, err, _code} ->
        {:error, err}
    end
  end

  @doc """
  Retorna una tupla de 3 fechas (access, modify & change dates), obtenidas con
  el comando stats de linux (expresadas en unix epoch timestamp).

  TODO: Ejemplos, doctests?
  """
  @spec maildir_dates(conn :: pid(), dir :: String.t()) :: {:ok, {integer(), integer(), integer()}} | {:error, String.t()}
  def maildir_dates(conn, dir) do
    path = Path.join(@maildir_path, dir)
    cmd = 'stat --format=\'%X,%Y,%Z\' #{path}'

    case SSHEx.run(conn, cmd) do
      {:ok, output, 0} ->
        {:ok,
         output
         |> String.trim()
         |> String.split(",")
         |> Enum.map(&String.to_integer(&1))
         |> List.to_tuple()}

      {:ok, err, _code} ->
        {:error, err}
    end
  end

  @doc """
  Retorna una tupla de 6 elementos con diversa informacion de un archivo.

  La informacion devuelta, en el orden que estan ubicadas en la tupla es la
  siguiente:

    * nombre de directorio
    * ruta completa (absoluta) al directorio
    * tamaño del directorio (en bytes)
    * access time (en unix epoch timestamp)
    * modify time (en unix epoch timestamp)
    * change time (en unix epoch timestamp)

  TODO: Ejemplos, doctests?
  """
  @spec maildir_stats(conn :: pid(), dir :: String.t()) :: {String.t(), String.t(), integer(), integer(), integer(), integer()} | {:error, String.t()}
  def maildir_stats(conn, dir) do
    path = Path.join(@maildir_path, dir)

    with {:ok, size} <- maildir_size(conn, dir),
         {:ok, {atime, mtime, ctime}} <- maildir_dates(conn, dir) do
      {:ok, {dir, path, size, atime, mtime, ctime}}
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
