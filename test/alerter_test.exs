defmodule AlerterTest do
  use ExUnit.Case

  alias Circuits.GPIO

  test "info returns a map" do
    info = GPIO.info()

    assert is_map(info)
    assert info.name == :stub
    assert info.pins_open == 0
  end
end
