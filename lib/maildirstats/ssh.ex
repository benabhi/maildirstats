defmodule Maildirstats.Ssh do
  use GenServer
  require Logger
  alias Maildirstats.Lib.Ssh, as: SSHLib

  @conndata Application.fetch_env!(:maildirstats, :ssh)

  # Api

  def start_link(_opts) do
    GenServer.start_link(__MODULE__, %{}, name: __MODULE__)
  end

  def call_list() do
    GenServer.call(__MODULE__, :list)
  end

  def call_size(account) do
    GenServer.call(__MODULE__, {:size, account}, :infinity)
  end

  def cast_size(account) do
    GenServer.cast(__MODULE__, {:size, account})
  end

  # GenServer Callbacks

  @impl true
  def init(_opts) do
    Logger.debug("[GenServer] SSHProc initialized... connected to #{@conndata[:ip]}")
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
  def handle_cast({:size, account}, %{conn: conn} = state) do
    Maildirstats.Memory.add(SSHLib.maildir_size(conn, account))
    {:noreply, state}
  end
end
