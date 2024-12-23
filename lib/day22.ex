defmodule Aoc24.Day22 do
  def part1(input) do
    starts =
      process_input(input)
      |> IO.inspect()

    0
  end

  def part2(input) do
    0
  end

  def process_input(input) do
    input
    |> String.split()
    |> Enum.map(&String.to_integer/1)
  end
end
