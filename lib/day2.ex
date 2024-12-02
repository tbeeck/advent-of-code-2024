defmodule Aoc24.Day2 do
  def part1(input) do
    split_reports(input)
    |> IO.inspect(charlists: :as_lists)
    0
  end

  defp split_reports(input) do
    input
    |> String.split("\n")
    |> Enum.map(fn s -> String.split(s) end)
    |> Enum.map(fn nums ->
      Enum.map(nums, fn num ->
        {val, _} = Integer.parse(num)
        val
      end)
    end)
  end
end
