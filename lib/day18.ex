defmodule Aoc24.Day18 do
  alias Aoc24.Util

  def part1(input, opts \\ []) do
    count = Keyword.get(opts, :count, 1024)
    # Inclusive
    width = Keyword.get(opts, :width, 70)
    height = Keyword.get(opts, :height, 70)

    input
    |> process_input()
    |> IO.inspect()

    0
  end

  def process_input(input) do
    input
    |> String.split()
    |> Enum.map(fn s ->
      String.split(s, ",")
      |> Enum.map(&Util.parseint/1)
      |> List.to_tuple()
    end)
  end
end
