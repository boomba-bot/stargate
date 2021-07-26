defmodule Stargate do
  use Application

  def start(_type, _args) do
    # connection_information = Stargate.Portal.Builder.bot()
    # token = Application.get_env(:stargate, :token)
    children = [
      {DynamicSupervisor, name: Stargate.ClientSupervisor, strategy: :one_for_one}
    ]

    Supervisor.start_link(children, strategy: :one_for_all)
    DynamicSupervisor.start_child()
  end
end


# {Stargate.Portal, %{
#   url: connection_information["url"] <> "/?v=9&enconding=json",
#   debug: true,
#   token: token
# }
# },
