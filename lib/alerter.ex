defmodule Alerter do
  use Agent
  require Logger
  alias Circuits.GPIO

  def child_spec(_) do
    %{
      id: __MODULE__,
      start: {__MODULE__, :start_link, []}
    }
  end

  @red_led_pin Application.get_env(:alerter, :red_led_pin, 13)
  @yello_led_pin Application.get_env(:alerter, :yello_led_pin, 19)
  @green_led_pin Application.get_env(:alerter, :green_led_pin, 26)

  def start_link() do
    {:ok, green} = GPIO.open(@green_led_pin, :output)
    {:ok, yellow} = GPIO.open(@yello_led_pin, :output)
    {:ok, red} = GPIO.open(@red_led_pin, :output)
    GPIO.write(green, 1)
    Agent.start(fn -> %{green: green, yellow: yellow, red: red} end, [name: __MODULE__])
  end

  def activate_green do
    Agent.get(__MODULE__, &(Map.get(&1, :green))) |> GPIO.write(1)
    Agent.get(__MODULE__, &(Map.get(&1, :yellow))) |> GPIO.write(0)
    Agent.get(__MODULE__, &(Map.get(&1, :red))) |> GPIO.write(0)
  end

  def activate_yellow do
    Agent.get(__MODULE__, &(Map.get(&1, :green))) |> GPIO.write(0)
    Agent.get(__MODULE__, &(Map.get(&1, :yellow))) |> GPIO.write(1)
    Agent.get(__MODULE__, &(Map.get(&1, :red))) |> GPIO.write(0)
  end

  def activate_red do
    Agent.get(__MODULE__, &(Map.get(&1, :green))) |> GPIO.write(0)
    Agent.get(__MODULE__, &(Map.get(&1, :yellow))) |> GPIO.write(0)
    Agent.get(__MODULE__, &(Map.get(&1, :red))) |> GPIO.write(1)
  end


end
