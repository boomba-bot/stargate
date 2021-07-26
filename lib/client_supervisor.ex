defmodule Stargate.ClientSupervisor do
  use Supervisor

  def start_link(client_state, opts) do
    Supervisor.start_link(__MODULE__, client_state, opts)
  end

  @impl true
  def init(:ok) do
    children = [
      {Stargate.ClientState, client_state},
      Stargate.PortalSupervisor,
      Stargate.GuildSupervisor
    ]

    Supervisor.init(children, strategy: :one_for_all)
  end
end
