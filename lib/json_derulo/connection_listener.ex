defmodule JsonDerulo.ConnectionListener do
  require Logger
  
  def child_spec(opts) do
    %{
      id: __MODULE__,
      start: {__MODULE__, :start_link, [opts]},
      type: :worker,
      restart: :permanent,
      shutdown: 500
    }
  end
  
  def start_link([port: port]) do
    Task.start_link(__MODULE__, :accept, [port])
  end

  def accept(port) do
    {:ok, socket} = :gen_tcp.listen(port, [:binary, packet: :line, active: true, reuseaddr: true])
    Logger.info("Listening for connections")
    await_connection(socket)
  end

  def await_connection(listen_socket) do
    {:ok, socket} = :gen_tcp.accept(listen_socket)
    Logger.info("Connection accepted, spawning new child")
    {:ok, pid} = DynamicSupervisor.start_child(JsonDerulo.DynamicSupervisor, {JsonDerulo.Client, socket})
    :gen_tcp.controlling_process(socket, pid)
    await_connection(listen_socket)
  end
end
