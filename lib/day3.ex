defmodule Aoc24.Day3 do

  def pattern do
    ~r/mul\((\d{0,3}),(\d{0,3})\)/
  end

  def part1(input) do
    Regex.scan(pattern(), input)
    |> IO.inspect()
    |> Enum.map(fn [_, a, b] -> String.to_integer(a) * String.to_integer(b) end)
    |> Enum.reduce(0, &+/2)
  end

end
