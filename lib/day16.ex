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
  end

  def part2(input) do
    make_caches()

    grid = process_input(input)
    build_graph(grid)

    start_point = find_first(grid, :start)
    end_point = find_first(grid, :end)

    shortest_path(start_point, end_point)
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

    min_cost =
      dijkstras(distances, queue, end_point)
      |> Enum.filter(fn {{point, _direction}, _cost} ->
        point == end_point
      end)
      |> Enum.min_by(fn {_k, v} -> v end)
      |> elem(1)

    dfs(real_start, end_point, min_cost)
    |> Enum.flat_map(fn l -> l end)
    |> IO.inspect()
    |> Enum.uniq()
    |> IO.inspect()
    |> length()
  end

  @spec dijkstras(any(), any(), any()) :: any()
  def dijkstras(distances, queue, _) when map_size(queue) == 0 do
    distances
  end

  def dijkstras(distances, queue, target) do
    {{cur_point, cur_direction}, cur_distance} = Enum.min_by(queue, fn {_, dist} -> dist end)

    queue = Map.delete(queue, {cur_point, cur_direction})
    neighbors = :ets.match(:edges, {{{cur_point, cur_direction}, :"$1"}, :"$2"})
    # Update distances and queue for each neighbor
    {new_distances, new_queue} =
      Enum.reduce(neighbors, {distances, queue}, fn [neighbor, weight], {dist_acc, queue_acc} ->
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

  # NOTE: Do dijkstras for every point, then for every navigable point, see if start->cur + cur-> end = min distance
  def dfs(cur, target, fuel, path \\ [], visited \\ MapSet.new())
  def dfs(_, _, fuel, _, _) when fuel < 0, do: []

  def dfs({cur_pos, _}, target, fuel, path, _) when fuel == 0 do
    if cur_pos == target do
      [[cur_pos] ++ path]
    else
      []
    end
  end

  def dfs(cur, target, fuel, path, visited) do
    {cur_pos, _} = cur

    if cur in visited do
      []
    else
      visited = MapSet.put(visited, cur)
      neighbors = :ets.match(:edges, {{cur, :"$1"}, :"$2"})

      Enum.reduce(neighbors, [], fn [neighbor, weight], result_acc ->
        result = dfs(neighbor, target, fuel - weight, [cur_pos] ++ path, visited)
        result ++ result_acc
      end)
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
    |> Enum.each(fn {direction, _} ->
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
