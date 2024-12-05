defmodule Aoc24.Day5 do
  def part1(input) do
    {pairs, lists} = process_input(input)
    graph = build_graph(pairs)
    0
  end

  def part2(input) do
    0
  end

  def build_graph(pairs) do
    result = Map.new()
    Enum.reduce(pairs, result, fn [a, b], acc ->
      cur = Map.get(acc, a, [])
      Map.put(acc, a, [b] ++ cur)
    end)
    |> IO.inspect(charlists: :as_lists)
  end

  @spec process_input(binary()) :: {list(list(integer())), list(list(integer()))}
  def process_input(input) do
    [graph, lists] = String.split(input, "\n\n")

    graph_pairs =
      graph
      |> String.split()
      |> Enum.map(fn s ->
        String.split(s, "|")
        |> Enum.map(fn n ->
          {num, _} = Integer.parse(n)
          num
        end)
      end)
      |> IO.inspect(charlists: :as_lists)

    print_lists =
      lists
      |> String.split()
      |> Enum.map(fn s ->
        String.split(s, ",")
        |> Enum.map(fn n ->
          {num, _} = Integer.parse(n)
          num
        end)
      end)
      |> IO.inspect(charlists: :as_lists)

    {graph_pairs, print_lists}
  end
end
