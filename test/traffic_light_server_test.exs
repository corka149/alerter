defmodule TrafficLightServerTest do
  use ExUnit.Case

  test "Start server" do
    assert {:ok, _} = Task.start_link(fn -> Alerter.TrafficLightServer.accept(4040) end)
  end

end
