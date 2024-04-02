defmodule JsonDerulo.Serializer do
  import Bitwise
  
  def emoji_encode(text) do
    Enum.map(String.to_charlist(text), fn c ->
      t = ((c + 55) >>> 6) + 143
      f = ((c + 55) &&& 0x3f) + 128
      <<0xF0, 0x9F, t, f>>
    end)
    |> Enum.join()
  end
  
  def emoji_decode(text) do
    Enum.map(String.to_charlist(text), fn c ->
      [240, 159, t, f] = :erlang.binary_to_list(<<c::utf8>>)
      (((t - 143) * 64) + ((f - 128))) - 55
    end)
    |> List.to_string()
  end
end
