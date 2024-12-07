defmodule Aoc24.Day3 do
  def pattern do
    ~r/mul\((\d{0,3}),(\d{0,3})\)/
  end

  def part1(input) do
    Regex.scan(pattern(), input)
    |> Enum.map(fn [_, a, b] -> String.to_integer(a) * String.to_integer(b) end)
    |> Enum.reduce(0, &+/2)
  end

  def part2(input) when is_binary(input) do
    do_indexes = [0] ++ indexes_of(input, ~r/do\(\)/)
    dont_indexes = indexes_of(input, ~r/don't\(\)/) ++ [byte_size(input)]

    valid_ranges(do_indexes, dont_indexes)
    |> merge_intervals()
    |> Enum.map(fn {start_i, end_i} -> binary_slice(input, start_i..end_i) end)
    |> Enum.map(&part1/1)
    |> Enum.reduce(&+/2)
  end

  def valid_ranges(do_indexes, dont_indexes) do
    do_indexes
    |> Enum.map(fn do_i ->
      [dont_i | _] = Enum.filter(dont_indexes, fn i -> i > do_i end)
      {do_i, dont_i}
    end)
  end

  def indexes_of(input, pat) do
    Regex.scan(pat, input, return: :index)
    |> Enum.map(fn [tuple] ->
      {index, _} = tuple
      index
    end)
  end

  def in_range(index, start_i, end_i) do
    index >= start_i and index <= end_i
  end

  def merge_intervals(intervals) do
    intervals
    # Ensure the intervals are sorted by start time
    |> Enum.sort_by(&elem(&1, 0))
    |> merge_sorted_intervals()
  end

  defp merge_sorted_intervals([]), do: []
  defp merge_sorted_intervals([interval]), do: [interval]

  defp merge_sorted_intervals([first, second | rest]) do
    {start1, end1} = first
    {start2, end2} = second

    if end1 >= start2 do
      # Merge overlapping intervals
      merge_sorted_intervals([{start1, max(end1, end2)} | rest])
    else
      # Keep the first interval and continue merging the rest
      [first | merge_sorted_intervals([second | rest])]
    end
  end
end
