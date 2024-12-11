defmodule Aoc24.Day11 do
  def part1(input) do
    stones =
      process_input(input)

    blink(stones, 25)
    |> length()
  end

  def part2(input) do
    0
  end

  def blink(stones, 0) when is_list(stones), do: stones

  def blink(stones, times) when is_list(stones) and is_integer(times) do
    result = Enum.flat_map(stones, fn stone -> blink(stone) end)
    blink(result, times - 1)
  end

  def blink(stone) when is_integer(stone) do
    if stone == 0 do
      [1]
    else
      if even_digits?(stone) do
        split_digits(stone)
      else
        [stone * 2024]
      end
    end
  end

  def even_digits?(num) do
    Integer.mod(String.length(Integer.to_string(num)), 2) == 0
  end

  def split_digits(num) do
    s = Integer.to_string(num)
    half = Integer.floor_div(String.length(s), 2)

    String.split_at(s, half)
    |> Tuple.to_list()
    |> Enum.map(fn s ->
      elem(Integer.parse(s), 0)
    end)
  end

  def process_input(input) do
    input
    |> String.split()
    |> Enum.map(fn s -> elem(Integer.parse(s), 0) end)
  end
end
