defmodule Aoc24.Day3 do
  def pattern do
    ~r/mul\((\d{0,3}),(\d{0,3})\)/
  end

  def part1(input) do
    Regex.scan(pattern(), input)
    |> Enum.map(fn [_, a, b] -> String.to_integer(a) * String.to_integer(b) end)
    |> Enum.reduce(0, &+/2)
  end

  def part2(input) do
    do_indexes = indexes_of(input, ~r/do\(\)/)
    dont_indexes = indexes_of(input, ~r/don't\(\)/)
    IO.inspect(do_indexes, charlists: :as_lists)
    IO.inspect(dont_indexes, charlists: :as_lists)
    0
  end

  def indexes_of(input, pat) do
    Regex.scan(pat, input, return: :index)
    |> Enum.map(fn [tuple] -> {index, _} = tuple; index end)
  end

  def in_range(index, indexes) do
    [start_i, end_i] = indexes
    index > start_i and index < end_i
  end
end
