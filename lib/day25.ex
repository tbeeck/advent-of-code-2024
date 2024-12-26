defmodule Aoc24.Day25 do
  alias Aoc24.Util

  def part1(input) do
    all = process_input(input)

    locks =
      Enum.filter(all, &is_lock/1)
      |> Enum.map(&heights/1)

    keys =
      Enum.filter(all, fn grid -> not is_lock(grid) end)
      |> Enum.map(&heights/1)

    Enum.with_index(locks)
    |> Enum.reduce([], fn {lock, i}, acc ->
      Enum.with_index(keys)
      |> Enum.reduce(acc, fn {key, j}, inner_acc ->
        if fits(lock, key) do
          inner_acc ++ [{i, j}]
        else
          inner_acc
        end
      end)
    end)
    |> length()
  end

  def fits(lock, key) when length(lock) == 0 and length(key) == 0, do: true

  def fits(lock, key) do
    [a | rest_lock] = lock
    [b | rest_key] = key

    cond do
      a + b <= 5 -> fits(rest_lock, rest_key)
      true -> false
    end
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
