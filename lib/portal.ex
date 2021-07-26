defmodule Stargate.Portal do
  use WebSockex
  require Logger
  alias Stargate.Payloads

  defmodule State do
    defstruct [:token, :seq, :ack]
  end

  ## Client API

  def start_link(%{url: url, token: token} = opts) do
    state = %State{seq: nil, token: token}
    opts = if(Map.get(opts, :debug, false), do: [debug: [:trace]], else: [])
    WebSockex.start_link(url, __MODULE__, state, opts)
  end

  ## Server callback

  @impl WebSockex
  def handle_connect(_conn, state) do
    # IO.puts(inspect(conn))
    {:ok, state}
  end

  @impl WebSockex
  def handle_frame({:text, body}, state) do
    message = Poison.decode!(body)
    handle_payload(message, state)
  end

  # Gateway Hello
  def handle_payload(%{"op" => 10, "d" => %{ "heartbeat_interval" => interval }}, %State{token: token} = state) do
    Process.send_after(self(), {:heartbeat, interval}, interval)
    if Map.get(state, :identified, false) do
      {:ok, state}
    else
      state = Map.put(state, :identified, true)
      {:reply, Payloads.identify(token, 0), state}
    end
  end

  # Heartbeat ACK
  def handle_payload(%{"op" => 11}, state) do
    state = Map.put(state, :ack, true)
    {:ok, state}
  end

  # Heartbeat request
  def handle_payload(%{"op" => 1, "d" => seq}, state) do
    state = Map.put(state, :seq, seq)
    {:reply, {:text, Payloads.heartbeat(seq)}, state}
  end

  @impl WebSockex
  def handle_disconnect(_connection_status, state) do
    # IO.puts(inspect(connection_status))
    IO.puts("reconnecting")
    {:reconnect, state}
  end

  # send heartbeat
  @impl true
  def handle_info({:heartbeat, interval}, %{seq: seq} = state) do
    # if no ack of last heartbeat, close connection
    unless Map.get(state, :ack, false) do
      Logger.error("did not receive heartbeat ack, closing connection")
      {:close, state}
    else
      Process.send_after(self(), {:heartbeat, interval}, interval)
      state = Map.put(state, :ack, false)
      {:reply, {:text, Payloads.heartbeat(seq)}, state}
    end
  end
end
