defmodule Alerter.TrafficLightServer do
  require Logger

  @spec accept(char) :: no_return
  def accept(port) when is_integer(port) do
    # The options below mean:
    #
    # 1. `:binary` - receives data as binaries (instead of lists)
    # 2. `packet: :line` - receives data line by line
    # 3. `active: false` - blocks on `:gen_tcp.recv/2` until data is available
    # 4. `reuseaddr: true` - allows us to reuse the address if the listener crashes
    #
    socket = loop_acquire_socket port
    Logger.info "Accepting connections on port #{port}"
    loop_receiver socket
  end

  defp loop_acquire_socket(port) do
    case :gen_udp.open(port, [:binary, active: false, reuseaddr: true]) do
      {:ok, socket}     -> socket
      {:error, reason}  ->
        Logger.error "Couldn't launch #{__MODULE__} -  Reason: #{reason}. Will retry it in 5 seconds."
        Process.sleep(5000)
        loop_acquire_socket(port)
    end
  end

  defp loop_receiver(socket) do
    {:ok, {_, _, message}} = :gen_udp.recv(socket, 0)
    Logger.info "Received package #{message}"
    toggle_traffic_light(message)
    loop_receiver(socket)
  end

  def toggle_traffic_light(message) do
    cond do
      message =~ "green"  -> Alerter.activate_green()
      message =~ "yellow" -> Alerter.activate_yellow()
      message =~ "red"    -> Alerter.activate_red()
      true                -> nil
    end
  end
end
