defmodule Stargate.Portal.Builder do
  def bot() do
    token = Application.fetch_env!(:stargate, :token)
    headers = [Authorization: "Bot #{token}"]
    HTTPoison.get("https://discord.com/api/v9/gateway/bot", headers) |> parse_response()
  end

  def parse_response({:ok, %HTTPoison.Response{status_code: 200, body: body}}) do
    body |> Poison.decode!()
  end
end
