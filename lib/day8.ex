defmodule Aoc24.Day8 do

  def part1(input) do
    0
  end

  def part2(input) do
    0
  end

  def process_input(input) do
    input
    |> String.split()
    |> Enum.map(fn line -> String.graphemes(line) end)
  end
end
