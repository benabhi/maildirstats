defmodule Maildirstats.Ldap do
  @moduledoc false

  use GenServer
  require Logger

  @ldap_credentials Application.fetch_env!(:maildirstats, :ldap)

  # Api
  def start_link(_args) do
    GenServer.start_link(__MODULE__, [], name: __MODULE__)
  end

  def get_user_details(user) do
    GenServer.call(__MODULE__, {:userdetails, user})
  end

  # GenServer Callbacks

  @impl true
  def init(_args) do
    # TODO: Pasar clave y usuario a config
    Logger.debug("[GenServer] LDAP initialized...")
    [user: user, password: password] = @ldap_credentials
    Paddle.authenticate([cn: user], password)
    {:ok, []}
  end

  @impl true
  def handle_call({:userdetails, user}, _from, state) do
    case Paddle.get(filter: [uid: user], base: [ou: "Users"]) do
      {:ok, [userdata]} ->
        Paddle.get(filter: [uid: user], base: [ou: "Users"])
        {:reply, {:ok, userdata}, state}

      {:error, reason} ->
        {:reply, {:error, reason}, state}
    end
  end
end
