defmodule JsonDerulo.Strategy.LocalEpmd do
  def init(opts) do
    JsonDerulo.Cluster.connect_nodes(find_nodes())
    {:ok, opts}
  end

  defp find_nodes() do
    suffix = '@' ++ (Node.self() |> Atom.to_charlist() |> :string.split("@") |> List.last())
    {:ok, names} = :erl_epmd.names()
    Enum.map(names, fn {name, _} -> List.to_atom(name ++ suffix) end)
  end
end
