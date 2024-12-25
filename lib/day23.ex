defmodule Aoc24.Day23 do
  alias Aoc24.Util

  def part1(input) do
    graph =
      process_input(input)

    relevant_keys =
      Map.keys(graph)
      |> Enum.filter(fn s -> String.starts_with?(s, "t") end)

    Enum.reduce(relevant_keys, MapSet.new(), fn name, acc ->
      available = Map.get(graph, name)

      groupings =
        Util.choose(available, 2)
        |> Enum.map(fn t -> Tuple.insert_at(t, 0, name) end)
        |> MapSet.new()

      MapSet.union(acc, groupings)
    end)
    |> Enum.map(fn t -> t |> Tuple.to_list() |> Enum.sort() |> List.to_tuple() end)
    |> Enum.uniq()
    |> Enum.filter(fn {a, b, c} -> all_connected?(graph, [a, b, c]) end)
    |> length()
  end

  def part2(input) do
    graph =
      process_input(input)

    graph
    |> Enum.map(fn {c, l} -> [c] ++ l end)
    |> Enum.reduce({}, fn l, acc ->
      Enum.reduce(0..length(l), acc, fn choice, inner_acc ->
        if choice > tuple_size(inner_acc) do
          groups =
            Util.choose(l, choice)
            |> Enum.filter(fn group -> all_connected?(graph, group |> Tuple.to_list()) end)

          if length(groups) >= 1 do
            List.first(groups)
          else
            inner_acc
          end
        else
          inner_acc
        end
      end)
    end)
    |> Tuple.to_list()
    |> Enum.sort()
    |> Enum.join(",")
  end

  def all_connected?(graph, list) do
    Enum.all?(list, fn computer ->
      Enum.all?(list, fn neighbor ->
        if computer == neighbor do
          true
        else
          computer in Map.get(graph, neighbor) and neighbor in Map.get(graph, computer)
        end
      end)
    end)
  end

  def process_input(input) do
    input
    |> String.split()
    |> Enum.map(fn line -> String.split(line, "-") end)
    |> Enum.reduce(Map.new(), fn [l, r], acc ->
      acc
      |> Map.update(l, [r], fn existing_val -> [r] ++ existing_val end)
      |> Map.update(r, [l], fn existing_val -> [l] ++ existing_val end)
    end)
  end
end
