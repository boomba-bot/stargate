defmodule StargateTest.Portal.Builder do
  use ExUnit.Case

  test "get gateway connection details" do
    assert is_map(Stargate.Portal.Builder.bot())
  end
end
