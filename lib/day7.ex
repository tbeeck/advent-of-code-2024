defmodule Aoc24.Day7 do
  def part1(input) do
    process_input(input)
    |> Enum.filter(fn {target, nums} -> valid_line(target, 0, nums) end)
    |> Enum.map(fn {target, _} -> target end)
    |> Enum.sum()
  end

  def part2(input) do
     process_input(input)
    |> Enum.filter(fn {target, nums} -> valid_line_with_concat(target, 0, nums) end)
    |> Enum.map(fn {target, _} -> target end)
    |> IO.inspect()
    |> Enum.sum()
  end

  def valid_line(target, current, []), do: target == current
  def valid_line(target, current, remaining) do
    [first | rest] = remaining
    do_add = valid_line(target, current+first, rest)
    do_mul = valid_line(target, current*first, rest)
    do_add or do_mul
  end

  def valid_line_with_concat(target, current, []), do: target == current
  def valid_line_with_concat(target, current, remaining) do
    [first | rest] = remaining
    do_add = valid_line_with_concat(target, current+first, rest)
    do_mul = valid_line_with_concat(target, current*first, rest)
    {concated, _} = Integer.parse(Integer.to_string(current) <> Integer.to_string(first))
    do_concat = valid_line_with_concat(target, concated, rest)
    do_add or do_mul or do_concat
  end

  def process_input(input) do
    input
    |> String.split("\n")
    |> Enum.map(fn s -> String.split(s, ": ") end)
    |> Enum.map(fn l ->
      [first | [rest]] = l

      {Integer.parse(first) |> elem(0),
       Enum.map(String.split(rest), fn n -> Integer.parse(n) |> elem(0) end)}
    end)
  end
end
