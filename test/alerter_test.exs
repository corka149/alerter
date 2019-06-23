defmodule AlerterTest do
  use ExUnit.Case
  doctest Alerter

  test "greets the world" do
    assert Alerter.hello() == :world
  end
end
