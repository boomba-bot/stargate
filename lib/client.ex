defmodule Stargate.Client do
  use GenServer

  def start_link([client_manager, client_params]) do
    GenServer.start_link()
  end
end
