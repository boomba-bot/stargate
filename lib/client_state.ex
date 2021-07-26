defmodule Stargate.ClientState do
  use GenServer

  def start_link(opts) do
    GenServer.start_link(__MODULE__, :ok, opts)
  end

  # Server callbacks

  def init(:ok) do
    {:ok, %{}}
  end
end
