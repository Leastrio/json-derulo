defmodule JsonDerulo.Client do
  use GenServer, restart: :transient

  def start_link(socket) do
    GenServer.start_link(__MODULE__, socket)
  end

  def init(socket) do
    {:ok, socket}
  end

  def handle_info({:tcp, socket, data}, state) do
    resp = JsonDerulo.Handler.handle_message(data)
    :gen_tcp.send(socket, resp)
    {:noreply, state}
  end

  def handle_info({:tcp_closed, _socket}, state), do: {:stop, :normal, state}
end
