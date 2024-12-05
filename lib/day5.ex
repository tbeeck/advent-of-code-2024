defmodule Aoc24.Day5 do
  def part1(input) do
    {pairs, lists} = process_input(input)
    graph = build_graph(pairs)

    lists
    |> Enum.map(fn l ->
      if print_order_ok?(l, graph) do
        get_middle(l)
      else
        0
      end
    end)
    |> Enum.sum()
  end

  def part2(input) do
    {pairs, lists} = process_input(input)
    graph = build_graph(pairs)

    lists
    |> Enum.filter(fn l -> !print_order_ok?(l, graph) end)
    |> Enum.map(fn l -> sort_print_order(l, indegrees(graph, l), graph) end)
    |> Enum.map(fn l -> get_middle(l) end)
    |> Enum.sum()
  end

  def get_middle(l) do
    Enum.at(l, div(Enum.count(l), 2))
  end

  def sort_print_order([], _, _), do: []
  def sort_print_order(print_list, indeg, graph) do
    first =
      print_list
      |> Enum.filter(fn n -> Map.get(indeg, n, 0) <= 0 end)
      |> List.first()

    remaining = Enum.reject(print_list, &(&1 == first))

    indeg =
      Enum.reduce(Map.get(graph, first, []), indeg, fn child, indeg ->
        Map.update(indeg, child, 0, &(&1 - 1))
      end)

    [first | sort_print_order(remaining, indeg, graph)]
  end

  def print_order_ok?(print_list, graph) do
    print_list
    |> Enum.reduce({true, indegrees(graph, print_list)}, fn num, {ok, indeg} ->
      if ok do
        if Map.get(indeg, num, 0) <= 0 do
          # reduce indegrees of all children
          indeg =
            Enum.reduce(Map.get(graph, num, []), indeg, fn child, indeg ->
              Map.update(indeg, child, 0, &(&1 - 1))
            end)

          {true, indeg}
        else
          {false, indeg}
        end
      else
        {ok, indeg}
      end
    end)
    |> elem(0)
  end

  @spec indegrees(map(), list()) :: map()
  def indegrees(graph, print_list) do
    Enum.reduce(graph, Map.new(), fn {node, edges}, acc ->
      Enum.reduce(edges, acc, fn edge, acc ->
        if Enum.member?(print_list, node) and Enum.member?(print_list, edge) do
          Map.update(acc, edge, 1, &(&1 + 1))
        else
          acc
        end
      end)
    end)
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
