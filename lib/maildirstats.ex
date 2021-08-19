defmodule Maildirstats do
  @moduledoc """
  TODO: Documentar
  """

  # TODO: Dejar una funcion para traer y otra para guardar y hacer una que haga
  #       ambas cosas-

  def fetch() do
    {:ok, dirs} = Maildirstats.Ssh.list()

    dirs
    |> Enum.map(&Maildirstats.Ssh.stats(&1))
    |> Enum.each(fn maildir ->
      # TODO: Validar errores
      {:ok, data} = maildir
      Maildirstats.Mnesia.Table.Maildir.write(data)
    end)
  end

  def fetch_ldap() do
    # TODO
  end

  def save() do
    # TODO
  end
end
