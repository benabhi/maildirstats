defmodule Maildirstats.Ssh do
  @moduledoc false

  use GenServer
  require Logger
  alias Maildirstats.Ssh.Funcs, as: SSHLib

  @conndata Application.fetch_env!(:maildirstats, :ssh)

  # Api

  def start_link(_opts) do
    GenServer.start_link(__MODULE__, %{}, name: __MODULE__)
  end

  def list() do
    GenServer.call(__MODULE__, :list)
  end

  def size(account) do
    GenServer.call(__MODULE__, {:size, account}, :infinity)
  end

  def stats(account) do
    GenServer.cast(__MODULE__, {:stats, account})
  end

  # GenServer Callbacks

  @impl true
  def init(_opts) do
    Logger.debug("[GenServer] SSH initialized... connected to #{@conndata[:ip]}")
    {:ok, conn} = SSHLib.conn()
    {:ok, %{conn: conn}}
  end

  @impl true
  def handle_call(:list, _from, %{conn: conn} = state) do
    {:reply, SSHLib.maildir_list(conn), state}
  end

  @impl true
  def handle_call({:size, account}, _from, %{conn: conn} = state) do
    {:reply, SSHLib.maildir_size(conn, account), state}
  end

  @impl true
  def handle_cast({:stats, account}, %{conn: conn} = state) do
    case SSHLib.maildir_stats(conn, account) do
      {:ok, stats} ->
        case Maildirstats.Ldap.get_user_details(account) do
          {:ok, ldap_data} ->
            stats = %{stats | ldap: ldap_data}
            Maildirstats.Memory.add(stats)
          {:error, msg} ->
            Maildirstats.Memory.add(stats)
            Maildirstats.Logger.log({:warning, :ldap, {account, msg}})
        end

      {:error, msg} ->
        Maildirstats.Logger.log({:error, :ssh, msg})
    end

    {:noreply, state}
  end
end
