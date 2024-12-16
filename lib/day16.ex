defmodule Aoc24.Day16 do
  def make_caches() do
    :ets.new(:edges, [:named_table, :public, :set])
  end

  def part1(input) do
    make_caches()

    grid = process_input(input)
    build_graph(grid)

    start_point = find_first(grid, :start)
    end_point = find_first(grid, :end)

    shortest_path(start_point, end_point)
    0
  end

  def part2(input) do
    make_caches()
    0
  end

  def shortest_path(start_point, end_point) do
    real_start = {start_point, :right}

    distances =
      :ets.tab2list(:edges)
      |> Enum.reduce(%{}, fn {{source, destination}, _weight}, acc ->
        Map.put_new(acc, source, :infinity)
        |> Map.put_new(destination, :infinity)
      end)
      |> Map.put(real_start, 0)

    queue = %{real_start => 0}
    dijkstras(distances, queue, end_point)
  end

  @spec dijkstras(any(), any(), any()) :: any()
  def dijkstras(_, queue, _) when map_size(queue) == 0 do
    :infinity
  end

  def dijkstras(distances, queue, target) do
    {{cur_point, cur_direction}, cur_distance} = Enum.min_by(queue, fn {_, dist} -> dist end)

    if cur_point == target do
      directions()
      |> Enum.map(fn d -> Map.get(distances, {target, d}, :infinity) end)
      |> Enum.filter(fn v -> is_integer(v) end)
      |> Enum.min()
    else
      queue = Map.delete(queue, {cur_point, cur_direction})
      neighbors = :ets.match(:edges, {{{cur_point, cur_direction}, :"$1"}, :"$2"})
      # Update distances and queue for each neighbor
      {new_distances, new_queue} =
        Enum.reduce(neighbors, {distances, queue}, fn [neighbor, weight],
                                                      {dist_acc, queue_acc} ->
          alt_distance = cur_distance + weight

          if alt_distance < Map.get(dist_acc, neighbor, :infinity) do
            {
              Map.put(dist_acc, neighbor, alt_distance),
              Map.put(queue_acc, neighbor, alt_distance)
            }
          else
            {dist_acc, queue_acc}
          end
        end)

      # Recur with updated distances, queue, and predecessors
      dijkstras(new_distances, new_queue, target)
    end
  end

  def build_graph(grid) do
    {width, height} = dimensions(grid)

    for x <- 0..(width - 1), y <- 0..(height - 1) do
      if can_nav_to(grid, {x, y}) do
        add_edges(grid, {x, y})
      end
    end
  end

  def add_edges(grid, src) do
    Enum.with_index(directions())
    |> Enum.each(fn {direction, i} ->
      target = new_position(src, direction)

      if can_nav_to(grid, target) do
        add_edge({src, direction}, {target, direction}, 1)
      end

      case direction do
        :up -> [:left, :right]
        :down -> [:left, :right]
        :left -> [:up, :down]
        :right -> [:up, :down]
      end
      |> Enum.each(fn inner_direction ->
        add_edge({src, direction}, {src, inner_direction}, 1000)
      end)
    end)
  end

  def add_edge(src, target, cost) do
    :ets.insert(:edges, {{src, target}, cost})
    :ok
  end

  def can_nav_to(grid, point) do
    in_bounds?(grid, point) and grid_val(grid, point) not in [:wall, nil]
  end

  def grid_val(grid, {x, y}) do
    if in_bounds?(grid, {x, y}) do
      elem(elem(grid, y), x)
    else
      nil
    end
  end

  def directions() do
    [
      :up,
      :right,
      :down,
      :left
    ]
  end

  def new_position({x, y}, direction) do
    {dx, dy} =
      case direction do
        :up -> {0, -1}
        :down -> {0, 1}
        :left -> {-1, 0}
        :right -> {1, 0}
      end

    {x + dx, y + dy}
  end

  def in_bounds?(grid, {x, y}) do
    height = tuple_size(grid)
    width = tuple_size(elem(grid, 0))
    0 <= y and y < height and 0 <= x and x < width
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

  def find_first(grid, value) do
    {width, height} = dimensions(grid)

    vals =
      for x <- 0..(width - 1),
          y <- 0..(height - 1),
          grid_val(grid, {x, y}) == value,
          do: {x, y}

    List.first(vals)
  end

  def dimensions(grid) do
    height = tuple_size(grid)
    width = tuple_size(elem(grid, 0))
    {width, height}
  end
end
