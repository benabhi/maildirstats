defmodule Maildirstats.Ssh do
  @moduledoc false

  use GenServer
  require Logger
  alias Maildirstats.Ssh.Lib, as: SSHLib

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
    GenServer.call(__MODULE__, {:stats, account}, :infinity)
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

  def handle_call({:stats, account}, _from, %{conn: conn} = state) do
    {:reply, SSHLib.maildir_stats(conn, account), state}
  end

end
