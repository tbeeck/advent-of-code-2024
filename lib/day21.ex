defmodule Aoc24.Day21 do
  use Memoize
  alias Aoc24.Util

  def num_grid do
    {
      {"7", "8", "9"},
      {"4", "5", "6"},
      {"1", "2", "3"},
      {nil, "0", "A"}
    }
  end

  def dir_grid do
    {
      {nil, "^", "A"},
      {"<", "v", ">"}
    }
  end

  def part1(input) do
    :ets.new(:memo_table, [:named_table, :set, :public])

    codes =
      process_input(input)

    seqs =
      Map.merge(pair_paths(num_grid()), pair_paths(dir_grid()))

    Enum.map(codes, fn code ->
      real_seq_len =
        search_seqs(code, seqs, 3)

      num = Util.parseint(Enum.join(Enum.slice(code, 0..2), ""))
      num * real_seq_len
    end)
    |> Enum.sum()
  end

  def part2(input) do
    :ets.new(:memo_table, [:named_table, :set, :public])

    codes =
      process_input(input)

    seqs =
      Map.merge(pair_paths(num_grid()), pair_paths(dir_grid()))

    Enum.map(codes, fn code ->
      real_seq_len =
        search_seqs(code, seqs, 26)

      num = Util.parseint(Enum.join(Enum.slice(code, 0..2), ""))
      num * real_seq_len
    end)
    |> Enum.sum()
  end

  def search_seqs(cur_code, _, depth) when depth < 1 do
    length(cur_code)
  end

  def search_seqs(cur_code, seqs, depth) do
    key = {List.to_tuple(cur_code), depth}

    case :ets.lookup(:memo_table, key) do
      [{^key, result}] ->
        result

      [] ->
        result =
          Enum.chunk_every(["A" | cur_code], 2, 1, :discard)
          |> Enum.map(fn [l, r] ->
            Map.get(seqs, {l, r})
            |> Enum.map(fn path ->
              to_gen = path ++ ["A"]
              search_seqs(to_gen, seqs, depth - 1)
            end)
            |> Enum.min()
          end)
          |> Enum.sum()

        :ets.insert(:memo_table, {key, result})
        result
    end

    # result =
    #   Enum.chunk_every(["A" | cur_code], 2, 1, :discard)
    #   |> Enum.map(fn [l, r] ->
    #     Map.get(seqs, {l, r})
    #     |> Enum.map(fn path ->
    #       to_gen = path ++ ["A"]
    #       search_seqs(to_gen, seqs, depth - 1)
    #     end)
    #     |> Enum.min_by(fn path -> length(path) end)
    #   end)
    #   |> Enum.reduce([], fn elem, acc ->
    #     acc ++ elem
    #   end)
  end

  def process_input(input) do
    input
    |> String.split()
    |> Enum.map(&String.graphemes/1)
  end

  def dfs(_graph, path, cur, target, fuel, _visited)
      when cur == target and fuel == 0,
      do: [path ++ [cur]]

  def dfs(graph, path, cur, target, fuel, visited) do
    if cur in visited or fuel <= 0 do
      []
    else
      Enum.reduce(Map.get(graph, cur), [], fn {neighbor, _cost}, acc ->
        dfs(graph, path ++ [cur], neighbor, target, fuel - 1, MapSet.put(visited, cur)) ++ acc
      end)
    end
  end

  def path_to_seq(path) do
    Enum.chunk_every(path, 2, 1, :discard)
    |> Enum.map(fn [p1, p2] ->
      {a, b} = p1
      {c, d} = p2

      case {c - a, d - b} do
        {1, 0} -> ">"
        {-1, 0} -> "<"
        {0, 1} -> "v"
        {0, -1} -> "^"
      end
    end)
  end

  def make_graph(grid) do
    {width, height} = Util.tuple_dimensions_2d(grid)

    for x <- 0..(width - 1),
        y <- 0..(height - 1) do
      {x, y}
    end
    |> Enum.filter(fn point -> Util.grid_val(grid, point) != nil end)
    |> Enum.reduce(Map.new(), fn point, edges_acc ->
      valid_neighbors =
        Util.valid_neighbors(point, {width, height})
        |> Enum.filter(fn neighbor -> Util.grid_val(grid, neighbor) != nil end)

      Enum.reduce(valid_neighbors, edges_acc, fn neighbor, inner_edges_acc ->
        existing = Map.get(inner_edges_acc, point, [])
        Map.put(inner_edges_acc, point, [{neighbor, 1}] ++ existing)
      end)
    end)
  end

  def pair_paths(grid) do
    {width, height} = Util.tuple_dimensions_2d(grid)
    graph = make_graph(grid)

    for x <- 0..(width - 1), y <- 0..(height - 1), Util.grid_val(grid, {x, y}) != nil do
      Util.Graph.dijkstras({x, y}, graph)
      |> Enum.reduce(Map.new(), fn {dest, cost}, acc ->
        paths =
          if {x, y} != dest do
            dfs(graph, [], {x, y}, dest, cost, MapSet.new())
            |> Enum.map(&path_to_seq/1)
          else
            [[]]
          end

        Map.put(acc, {Util.grid_val(grid, {x, y}), Util.grid_val(grid, dest)}, paths)
      end)
    end
    |> Enum.reduce(Map.new(), fn map, acc ->
      Map.merge(acc, map)
    end)
  end

  def seq_str(seq), do: Enum.join(seq, "")
end
