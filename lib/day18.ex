defmodule Aoc24.Day18 do
  alias Aoc24.Util

  def part1(input, opts \\ []) do
    count = Keyword.get(opts, :count, 1024)
    # Inclusive
    width = Keyword.get(opts, :width, 70)
    height = Keyword.get(opts, :height, 70)

    walls =
      input
      |> process_input()
      |> Enum.slice(0..(count - 1))

    graph =
      grid_graph(walls, {width, height})

    Util.Graph.dijkstras({0, 0}, graph)
    |> Map.get({width, height}, :infinity)
  end

  def part2(input, opts \\ []) do
    # Inclusive
    dimensions = {
      Keyword.get(opts, :width, 70),
      Keyword.get(opts, :height, 70)
    }

    destination = dimensions

    walls = process_input(input)
    wall_set = MapSet.new(walls)

    graph = grid_graph(walls, dimensions)

    print_grid(dimensions, walls)

    uf =
      make_uf(graph, dimensions)

    {coord, _, _} =
      Enum.reduce(Enum.reverse(walls), {nil, uf, wall_set}, fn wall, {result, uf_acc, wall_acc} ->
        if result != nil do
          {result, uf_acc, wall_acc}
        else
          {uf_acc, wall_acc} = remove_wall(uf_acc, wall, wall_acc, dimensions)
          print_grid(dimensions, wall_acc)

          if Util.Graph.UnionFind.connected?(
               uf_acc,
               keyof({0, 0}, dimensions),
               keyof(destination, dimensions)
             ) do
            {wall, uf_acc, wall_acc}
          else
            {result, uf_acc, wall_acc}
          end
        end
      end)

    "#{elem(coord, 0)},#{elem(coord, 1)}"
  end

  def remove_wall(uf, wall, walls, dimensions) do
    {width, height} = dimensions

    new_connections =
      Util.neighbors_of(wall)
      |> Enum.filter(fn p -> Util.in_bounds?(p, {width + 1, height + 1}) and p not in walls end)

    new_uf =
      Enum.reduce(new_connections, uf, fn p, uf_acc ->
        Util.Graph.UnionFind.union(uf_acc, keyof(wall, dimensions), keyof(p, dimensions))
      end)

    {new_uf, MapSet.delete(walls, wall)}
  end

  def make_uf(graph, {width, height}) do
    uf = Util.Graph.UnionFind.new((width + 1) * (height + 1))

    Enum.reduce(graph, uf, fn {src, dests}, uf_acc ->
      Enum.reduce(dests, uf_acc, fn {dest, _}, inner_uf_acc ->
        Util.Graph.UnionFind.union(
          inner_uf_acc,
          keyof(src, {width, height}),
          keyof(dest, {width, height})
        )
      end)
    end)
  end

  def keyof({x, y}, {width, _}) do
    y * (width + 1) + x
  end

  def print_grid({width, height}, walls) do
    for y <- 0..height do
      Enum.reduce(0..width, [], fn x, acc ->
        if {x, y} in walls do
          acc ++ ["#"]
        else
          acc ++ ["."]
        end
      end)
      |> Enum.join(" ")
    end
  end

  def grid_graph(walls, {width, height}) do
    navigable =
      for x <- 0..width,
          y <- 0..height,
          {x, y} not in walls,
          do: {x, y}

    navigable
    |> Enum.map(fn pair ->
      neighbors =
        Util.neighbors_of(pair)
        |> Enum.filter(fn n ->
          Util.in_bounds?(n, {width + 1, height + 1}) and n not in walls
        end)
        |> Enum.map(fn n -> {n, 1} end)

      {pair, neighbors}
    end)
    |> Enum.reduce(Map.new(), fn {pair, neighbors}, acc -> Map.put(acc, pair, neighbors) end)
  end

  def process_input(input) do
    input
    |> String.split()
    |> Enum.map(fn s ->
      String.split(s, ",")
      |> Enum.map(&Util.parseint/1)
      |> List.to_tuple()
    end)
  end
end
