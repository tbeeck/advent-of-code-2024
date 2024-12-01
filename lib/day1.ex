defmodule Aoc24.Day1 do
  def day1(input) do
    input
    # Lines
    |> String.split("\n")
    # whitespace
    |> Enum.map(fn s -> String.split(s) end)
    |> Enum.flat_map(fn pair -> pair end)
    |> Enum.map(fn s -> {i, _} = Integer.parse(s); i end)
    |> Enum.chunk_every(2)
    |> IO.inspect()

    0
  end
end
