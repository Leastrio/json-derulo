defmodule JsonDerulo.Handler do
  def handle_message(data) do
    case data do
      "PING" <> _ -> "PONG"
      "<" <> keys -> get_data(keys)
      ">" <> input -> write_data(input)
      "@" <> _ -> JsonDerulo.Writer.all()
      "!" <> keys -> clear_data(keys)
      _ -> "!@UNKNOWN OPERATION"
    end
  end

  def get_data(input) do
    case String.trim(input) |> JsonDerulo.Utils.parse_keys() do
      [] -> "!@INVALID INPUT"
      keys -> JsonDerulo.Writer.get(keys)
    end
  end

  def write_data(input) do
    case String.trim(input) |> JsonDerulo.Utils.parse_keys() do
      [] -> "!@INVALID INPUT"
      keys ->
        splitter_key = List.last(keys)
        case String.split(input, "[#{splitter_key}]") |> List.last() |> String.trim() do
          "" -> "!@INVALID DATA"
          data ->
            JsonDerulo.Writer.write(keys, data)
        end
    end
  end

  def clear_data(input) do
    case String.trim(input) |> JsonDerulo.Utils.parse_keys() do
      [] -> "!@INVALID INPUT"
      keys -> JsonDerulo.Writer.clear(keys)
    end
  end
end
