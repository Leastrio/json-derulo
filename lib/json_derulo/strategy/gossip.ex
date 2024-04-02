defmodule JsonDerulo.Strategy.Gossip do

  @multicast_address {239, 0, 0, 1}
  @multicast_port 2189
  
  def init(_) do
    udp_opts = [
      :binary,
      active: true,
      reuseaddr: true,
      multicast_ttl: 4,
      multicast_if: {0, 0, 0, 0},
      multicast_loop: true,
      add_membership: {@multicast_address, {0, 0, 0, 0}},
    ]
    {:ok, socket} = :gen_udp.open(@multicast_port, udp_opts)
    {:ok, socket, {:continue, nil}}
  end

  def handle_continue(_, state) do
    self = node()
    res = :gen_udp.send(state, @multicast_address, @multicast_port, ["connect::", :erlang.term_to_binary(%{node: self})])
    IO.inspect res
    {:noreply, state}
  end

  def handle_info({:udp, _socket, _ip, _port, <<"connect::", node::binary>>}, state) do
    self = node()
    case :erlang.binary_to_term(node) do
      %{node: ^self} -> :ok
      %{node: n} ->
        JsonDerulo.Cluster.connect_nodes([n])
        :ok
      _ -> :ok
    end

    {:noreply, state}
  end
  
  def handle_info({:udp, _socket, _ip, _port, _data}, state) do
    {:noreply, state}
  end
end
