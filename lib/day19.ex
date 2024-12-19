defmodule Aoc24.Day19 do
  def part1(input) do
    {towels, patterns} = parse_input(input)

    patterns
    |> Enum.filter(fn pat -> can_make(pat, towels) end)
    |> Enum.count()
  end

  def can_make("", _), do: true

  def can_make(s, towels) do
    towels
    |> Enum.filter(fn t -> String.starts_with?(s, t) end)
    |> Enum.any?(fn t -> can_make(String.replace_prefix(s, t, ""), towels) end)
  end

  def part2(input) do
    :ets.new(:memo, [:named_table, :public, :set])

    {towels, patterns} = parse_input(input)

    patterns
    |> Enum.map(fn p -> ways_to_make(p, towels) end)
    |> Enum.sum()
  end

  def ways_to_make("", _), do: 1

  def ways_to_make(pattern, towels) do
    case :ets.lookup(:memo, pattern) do
      [{_, ans}] ->
        ans

      [] ->
        ways =
          towels
          |> Enum.filter(fn t -> String.starts_with?(pattern, t) end)
          |> Enum.map(fn t -> ways_to_make(String.replace_prefix(pattern, t, ""), towels) end)
          |> Enum.sum()

        :ets.insert(:memo, {pattern, ways})
        ways
    end
  end

  def parse_input(input) do
    [towels_str, patterns_str] = String.split(input, "\n\n")
    towels = String.split(towels_str, ", ")
    patterns = String.split(patterns_str)
    {towels, patterns}
  end
end
