defmodule Aoc24.Day25 do
  alias Aoc24.Util

  def part1(input) do
    all = process_input(input)

    locks =
      Enum.filter(all, &is_lock/1)
      |> Enum.map(&heights/1)
      |> IO.inspect()

    keys =
      Enum.filter(all, fn grid -> not is_lock(grid) end)
      |> Enum.map(&heights/1)
      |> IO.inspect()

    0
  end

  def is_lock(grid) do
    elem(grid, 0)
    |> Tuple.to_list()
    |> Enum.all?(fn char -> char == "#" end)
  end

  def heights(grid) do
    {width, height} = Util.tuple_dimensions_2d(grid)

    freqs =
      for x <- 0..(width - 1), y <- 1..(height - 2), Util.grid_val(grid, {x, y}) == "#" do
        x
      end
      |> Enum.frequencies()

    Enum.reduce(0..4, [], fn i, acc ->
      acc ++ [Map.get(freqs, i, 0)]
    end)
  end

  def process_input(input) do
    input
    |> String.split("\n\n")
    |> Enum.map(fn chunk ->
      chunk
      |> String.split()
      |> Enum.map(fn line -> String.graphemes(line) |> List.to_tuple() end)
    end)
    |> Enum.map(&List.to_tuple/1)
  end
end
