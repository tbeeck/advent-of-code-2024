defmodule Aoc24.Day1 do
  def part1(input) do
    {list1, list2} = split_lists(input)
    Enum.zip(list1, list2)
    |> Enum.map(fn {a, b} -> abs(a - b) end)
    |> Enum.sum()
  end

  def part2(input) do
    {list1, list2} = split_lists(input)
    freq = Enum.frequencies(list2)
    IO.inspect(freq)
    list1
    |> Enum.map(fn n ->
      n*Map.get(freq, n, 0)
    end)
    |> Enum.sum()
    |> IO.inspect()
  end

  defp split_lists(input) do
    flat_list =
      input
      |> String.split("\n")
      |> Enum.map(fn s -> String.split(s) end)
      |> Enum.flat_map(fn pair -> pair end)
      |> Enum.map(fn s ->
        {i, _} = Integer.parse(s)
        i
      end)

    list1 =
      flat_list
      |> Enum.with_index()
      |> Enum.filter(fn {_, index} -> rem(index, 2) == 0 end)
      |> Enum.map(fn {elem, _} -> elem end)
      |> Enum.sort()

    list2 =
      flat_list
      |> Enum.with_index()
      |> Enum.filter(fn {_, index} -> rem(index, 2) == 1 end)
      |> Enum.map(fn {elem, _} -> elem end)
      |> Enum.sort()

      {list1, list2}
  end
end
