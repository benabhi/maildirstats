defmodule Maildirstats.Ldap do
  @moduledoc false

  use GenServer
  require Logger

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
    Paddle.authenticate([cn: "ebox"], "ENRW2AiRbKp.Ta.E")
    {:ok, []}
  end

  @impl true
  def handle_call({:userdetails, user}, _from, state) do
    {:ok, [userdata]} = Paddle.get(filter: [uid: user], base: [ou: "Users"])

    {:reply, userdata, state}
  end
end
