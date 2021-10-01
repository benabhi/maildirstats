defmodule Maildirstats.CLI.Account do
  # alias Maildirstats.Ldap
  alias Maildirstats.Ssh
  # alias Maildirstats.Mnesia.Table.Maildir

  def get_details(account, options \\ []) do
    default = [ldap: false, direct: false]
    _options = Keyword.merge(default, options)

    {:ok, data} = Ssh.stats(account)

    %{
      name: data.account,
      path: data.path,
      size: data.size,
      fdates: data.fdates
    }
  end
end
