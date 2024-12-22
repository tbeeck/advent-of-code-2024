defmodule Aoc24.Day21 do
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
    codes =
      process_input(input)

      all_orders_of(["^", ">", "^"])
      |> IO.inspect()

    num_seqs =
      pair_paths(num_grid())
      |> IO.inspect(limit: :infinity)
      |> Map.put({"3", "7"}, ["<", "<", "^", "^"])

    dir_seqs =
      pair_paths(dir_grid())
      |> IO.inspect(limit: :infinity)

    Enum.map(codes, fn code ->
      final_code =
        code
        |> IO.inspect()
        |> make_code_sequence(num_seqs, 1, false)
        |> make_code_sequence(dir_seqs, 2, true)

      IO.inspect(length(final_code))
      num = Util.parseint(Enum.join(Enum.slice(code, 0..2), ""))
      num * length(final_code)
    end)
    |> IO.inspect()
    |> Enum.sum()
  end

  def make_code_sequence(code, _, times, _) when times < 1, do: code

  def make_code_sequence(code, seqs, times, sort?) do
    cur =
      Enum.chunk_every(["A"] ++ code, 2, 1, :discard)
      |> Enum.reduce([], fn [l, r], acc ->
        acc ++ Map.get(seqs, {l, r}) ++ ["A"]
      end)
      |> IO.inspect(width: 200, limit: :infinity)

    # |> IO.inspect(width: 200, limit: :infinity)
    IO.inspect(seq_str(cur))
    make_code_sequence(cur, seqs, times - 1, sort?)
  end

  def process_input(input) do
    input
    |> String.split()
    |> Enum.map(&String.graphemes/1)
  end

  def dfs(_graph, path, cur, target, fuel, _visited)
      when cur == target and fuel == 0,
      do: path ++ [cur]

  def dfs(graph, path, cur, target, fuel, visited) do
    if cur in visited or fuel <= 0 do
      nil
    else
      Enum.reduce(Map.get(graph, cur), nil, fn {neighbor, _cost}, acc ->
        if acc != nil do
          acc
        else
          dfs(graph, path ++ [cur], neighbor, target, fuel - 1, MapSet.put(visited, cur))
        end
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
          dfs(graph, [], {x, y}, dest, cost, MapSet.new())
          |> path_to_seq()
          |> all_orders_of()

        Map.put(acc, {Util.grid_val(grid, {x, y}), Util.grid_val(grid, dest)}, paths)
      end)
    end
    |> Enum.reduce(Map.new(), fn map, acc ->
      Map.merge(acc, map)
    end)
  end

  def seq_str(seq), do: Enum.join(seq, "")

  def all_orders_of(path) when length(path) == 0, do: []
  def all_orders_of(path) when length(path) == 1, do: [path]
  def all_orders_of([first | rest]) do
    remaining = all_orders_of(rest)
    Enum.reduce(remaining, [], fn l, acc ->
      acc ++ [[first] ++ l] ++ [l ++ [first]]
    end)
    |> Enum.uniq_by(fn l -> List.to_tuple(l) end)
  end

end
