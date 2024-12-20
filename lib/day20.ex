defmodule Aoc24.Day20 do
  alias Aoc24.Util

  def part1(input, opts \\ []) do
    min_saving = Keyword.get(opts, :min_saving, 100)

    grid =
      process_input(input)

    graph =
      make_graph(grid)

    start_point = Util.find_first_in_2d_tuple(grid, :start)
    end_point = Util.find_first_in_2d_tuple(grid, :end)

    start_distances = Util.Graph.dijkstras(start_point, graph)
    end_distances = Util.Graph.dijkstras(end_point, graph)

    find_1ps_cheats(grid, start_distances, end_distances, start_point)
    |> Enum.filter(fn {_p1, _p2, savings} -> savings >= min_saving end)
    |> IO.inspect(limit: :infinity)
    |> length()
  end

  def part2(input, opts \\ []) do
    min_saving = Keyword.get(opts, :min_saving, 100)

    grid =
      process_input(input)

    graph =
      make_graph(grid)

    start_point = Util.find_first_in_2d_tuple(grid, :start)
    end_point = Util.find_first_in_2d_tuple(grid, :end)

    start_distances = Util.Graph.dijkstras(start_point, graph)
    end_distances = Util.Graph.dijkstras(end_point, graph)

    find_20ps_cheats(grid, start_distances, end_distances, start_point)
    |> Enum.filter(fn {_, _, saving} -> saving >= min_saving end)
    |> Enum.sort_by(fn {_, _, saving} -> saving end)
    |> IO.inspect(limit: :infinity)
    |> length()
  end

  def find_20ps_cheats(grid, start_distances, end_distances, start) do
    {width, height} = Util.tuple_dimensions_2d(grid)

    tracks =
      for x <- 0..(width - 1),
          y <- 0..(height - 1),
          Util.grid_val(grid, {x, y}) != :wall,
          Map.has_key?(start_distances, {x, y}),
          do: {x, y}

    Enum.flat_map(tracks, fn start_point ->
      Util.radius_around(start_point, 20)
      |> Enum.filter(fn end_point -> Util.grid_val(grid, end_point) == :free end)
      |> Enum.map(fn end_point ->
        {start_point, end_point,
         time_saving(start_point, end_point, start_distances, end_distances, start)}
      end)
      |> Enum.filter(fn {_start, _end, saving} -> saving > 0 end)
      |> Enum.uniq_by(fn {s, e, _} -> {s, e} end)
    end)
  end

  def find_1ps_cheats(grid, start_distances, end_distances, start) do
    {width, height} = Util.tuple_dimensions_2d(grid)

    walls =
      for x <- 0..(width - 1),
          y <- 0..(height - 1),
          Util.grid_val(grid, {x, y}) == :wall,
          do: {x, y}

    Enum.flat_map(walls, fn wall ->
      good_neighbors =
        Util.valid_neighbors(wall, {width, height})
        |> Enum.filter(fn n -> Util.grid_val(grid, n) != :wall end)

      pair_combos(good_neighbors)
    end)
    |> Enum.map(fn {p1, p2} ->
      {p1, p2, time_saving(p1, p2, start_distances, end_distances, start)}
    end)
    |> Enum.filter(fn {_p1, _p2, saving} -> saving > 0 end)
    |> Enum.sort_by(fn {_, _, saving} -> saving end)
    |> Enum.dedup_by(fn {p1, p2, _} -> {p1, p2} end)
  end

  def time_saving(p1, p2, start_distances, end_distances, start) do
    dist1 = Map.get(start_distances, p1)
    dist2 = Map.get(end_distances, p2)
    Map.get(end_distances, start) - (dist2 + dist1 + Util.manhattan_distance(p1, p2))
  end

  def pair_combos(pairs) do
    Enum.flat_map(pairs, fn p1 ->
      Enum.reduce(pairs, [], fn p2, inner_acc ->
        if p1 != p2 do
          [{p1, p2}] ++ inner_acc
        else
          inner_acc
        end
      end)
    end)
  end

  def make_graph(grid) do
    {width, height} = Util.tuple_dimensions_2d(grid)

    for x <- 0..(width - 1), y <- 0..(height - 1) do
      {x, y}
    end
    |> Enum.filter(fn point -> Util.grid_val(grid, point) != :wall end)
    |> Enum.reduce(Map.new(), fn point, edges_acc ->
      valid_neighbors =
        Util.valid_neighbors(point, {width, height})
        |> Enum.filter(fn neighbor -> Util.grid_val(grid, neighbor) != :wall end)

      Enum.reduce(valid_neighbors, edges_acc, fn neighbor, inner_edges_acc ->
        existing = Map.get(inner_edges_acc, point, [])
        Map.put(inner_edges_acc, point, [{neighbor, 1}] ++ existing)
      end)
    end)
  end

  def process_input(input) do
    grid =
      String.split(input)
      |> Enum.map(fn row ->
        String.graphemes(row)
        |> Enum.map(fn char ->
          case char do
            "#" -> :wall
            "." -> :free
            "S" -> :start
            "E" -> :end
          end
        end)
        |> List.to_tuple()
      end)
      |> List.to_tuple()

    grid
  end
end
