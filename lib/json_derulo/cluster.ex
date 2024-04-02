defmodule JsonDerulo.Cluster do
  require Logger

  defstruct [:strategy]

  def child_spec(opts) do
    %{
      id: __MODULE__,
      start: {__MODULE__, :start_link, [opts]}
    }
  end

  def start_link(opts) do
    args = struct(__MODULE__, opts)
    module = case args.strategy do
      :local_epmd -> JsonDerulo.Strategy.LocalEpmd
      :gossip -> JsonDerulo.Strategy.Gossip
    end
    GenServer.start_link(module, struct(__MODULE__, opts), name: __MODULE__)
  end

  def connect_nodes(nodes) do
    connect = (nodes -- Node.list(:connected)) -- [Node.self()]
    Enum.each(connect, fn node ->
      case Node.connect(node) do
        true ->
          Logger.info("Connected to #{inspect node}")
        false ->
          Logger.info("Could not connect to #{inspect node}")
        :ignored ->
          Logger.info("Ignored #{inspect node}, local node not alive.")
      end
    end)
  end
end
