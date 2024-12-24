defmodule Aoc24.Day23 do
  def part1(input) do
    graph =
      process_input(input)

    relevant_keys =
      Map.keys(graph)
      |> Enum.filter(fn s -> String.starts_with?(s, "t") end)

    Enum.reduce(relevant_keys, MapSet.new(), fn name, acc ->
      IO.puts("--- #{name} ---")

      available =
        connected_to_directly(graph, name)

      groupings =
        choose(available, 2)
        |> Enum.map(fn t -> Tuple.insert_at(t, 0, name) end)
        |> MapSet.new()

      MapSet.union(acc, groupings)
    end)
    |> Enum.map(fn t -> t |> Tuple.to_list() |> Enum.sort() |> List.to_tuple() end)
    |> Enum.uniq()
    |> Enum.filter(fn {a, b, c} -> all_connected?(graph, [a, b, c]) end)
    |> length()
  end

  def choose(_, n) when n == 0, do: []
  def choose(vals, n) when n == 1, do: Enum.map(vals, fn val -> {val} end)

  def choose(vals, n) do
    next_groups =
      choose(vals, n - 1)

    Enum.flat_map(next_groups, fn group ->
      existing = MapSet.new(Tuple.to_list(group))

      Enum.map(vals, fn val ->
        if val in existing do
          nil
        else
          Tuple.insert_at(group, 0, val)
          |> Tuple.to_list()
          |> Enum.sort()
          |> List.to_tuple()
        end
      end)
    end)
    |> Enum.filter(fn group -> group != nil end)
    |> Enum.map(fn t -> t |> Tuple.to_list() |> Enum.sort() |> List.to_tuple() end)
    |> Enum.uniq()
  end

  def connected_to_directly(graph, computer) do
    Map.get(graph, computer)
  end

  def all_connected?(graph, list) do
    [a, b, c] = list

    a in Map.get(graph, b) and a in Map.get(graph, c) and b in Map.get(graph, a) and
      b in Map.get(graph, c) and c in Map.get(graph, a) and c in Map.get(graph, b)
  end

  def connected_to(_, queue, found) when length(queue) == 0, do: found

  def connected_to(graph, queue, found) do
    [cur | remaining_queue] = queue

    found = MapSet.put(found, cur)

    new_queue =
      Enum.reduce(Map.get(graph, cur, []), remaining_queue, fn neighbor, queue_acc ->
        if neighbor in found do
          queue_acc
        else
          [neighbor] ++ queue_acc
        end
      end)

    connected_to(graph, new_queue, found)
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
