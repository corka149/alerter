defmodule Alerter.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  @target Mix.target()

  use Application

  def start(_type, _args) do
    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: Alerter.Supervisor]
    Supervisor.start_link(children(@target), opts)
  end

  # List all child processes to be supervised
  def children(:host) do
    [
      {Task, fn -> TrafficLightServer.accept(4040) end}
    ]
  end

  def children(_target) do
    [
      Alerter,
      {Task, fn -> TrafficLightServer.accept(4040) end}
    ]
  end
end
