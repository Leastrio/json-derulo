defmodule JsonDerulo.Utils do
  def parse_keys(input) do
    Regex.scan(~r/\[([^\]]+)\]/, input)
    |> Enum.map(fn [_, match] -> match end)
  end
end
