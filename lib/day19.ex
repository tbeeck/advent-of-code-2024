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

  def parse_input(input) do
    [towels_str, patterns_str] = String.split(input, "\n\n")
    towels = String.split(towels_str, ", ")
    patterns = String.split(patterns_str)
    {towels, patterns}
  end
end
