defmodule Aoc24.Day5 do
  def part1(input) do
    {pairs, lists} = process_input(input)
    graph = build_graph(pairs)
    order = topo_sort(graph)

    lists
    |> Enum.map(fn l -> if print_order_ok?(l, order) do get_middle(l) else 0 end end)
    |> Enum.sum()
  end

  def part2(input) do
    0
  end

  def get_middle(l) do
    Enum.at(l, div(Enum.count(l), 2))
  end

  def print_order_ok?(print_list, order) do
    order = order
    |> Enum.filter(fn n -> Enum.member?(print_list, n) end)
    print_list
    |> Enum.with_index()
    |> IO.inspect()
    |> Enum.reduce({true, order}, fn {num, idx}, {ok, order} ->
      if ok do
        idx_in_order = Enum.find_index(order, fn n -> n == num end)
        if idx_in_order == nil do
          {true, order}
        else
          {idx_in_order <= idx, order}
        end
      else
        {false, order}
      end
    end)
    |> IO.inspect()
    |> elem(0)
  end

  @spec topo_sort(map()) :: list(integer())
  def topo_sort(graph) do
    visited = MapSet.new()
    stack = []

    {new_stack, _} =
      Enum.reduce(graph, {stack, visited}, fn {node, _}, {stack, visited} ->
        {new_stack, visited} =
          topo_dfs(graph, node, stack, visited)

        {new_stack, visited}
      end)

    new_stack
    |> IO.inspect()
  end

  defp topo_dfs(graph, node, stack, visited) do
    if MapSet.member?(visited, node) do
      {stack, visited}
    else
      visited = MapSet.put(visited, node)

      {new_stack, visited} =
        Enum.reduce(Map.get(graph, node, []), {stack, visited}, fn next_node, {stack, visited} ->
          topo_dfs(graph, next_node, stack, visited)
        end)

      {[node | new_stack], visited}
    end
  end

  def build_graph(pairs) do
    blank_map =
      Enum.reduce(pairs, Map.new(), fn [a, b], acc ->
        Map.put(acc, a, [])
        |> Map.put(b, [])
      end)

    Enum.reduce(pairs, blank_map, fn [a, b], acc ->
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

    {graph_pairs, print_lists}
  end
end
