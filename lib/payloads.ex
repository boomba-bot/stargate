defmodule Stargate.Payloads do
  def opcode(op) do
    %{
      dispatch: 0,
      heartbeat: 1,
      identify: 2,
      status_update: 3,
      voice_update: 4,
      voice_ping: 5,
      resume: 6,
      reconnect: 7,
      req_guild_members: 8,
      invalid: 9,
      hello: 10,
      ACK: 11
    }[op]
  end

  def build_payload(op, data) when is_atom(op) do
    build_payload(opcode(op), data)
  end

  def build_payload(op, data) when is_integer(op) do
    payload = %{op: op, d: data}
    Poison.encode!(payload)
  end

  def properties(os) do
    %{
      "$os" => os,
      "$browser" => "stargate",
      "$device" => "stargate"
    }
  end

  def identify(token, shard) do
    {os, _} = :os.type()
    identify = %{
      token: token,
      properties: properties(os),
      compress: false,
      large_treshold: 250,
      shard: shard
    }

    build_payload(:identify, identify)
  end

  def resume(%{session_id: session_id, seq: seq, token: token}) do
    build_payload(:resume, %{session: session_id, seq: seq, token: token})
  end

  def heartbeat(seq) do
    build_payload(:heartbeat, seq)
  end
end
