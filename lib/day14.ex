defmodule Aoc24.Day14 do
  defmodule Robot do
    defstruct [:position, :velocity]
  end

  def part1(input, opts \\ []) do
    width = Keyword.get(opts, :width, 101)
    height = Keyword.get(opts, :height, 103)

    process_input(input)
    |> Enum.map(fn robot -> sim(robot, width, height) end)
    |> quadrants(width, height)
    |> Enum.map(fn {_, v} -> length(v) end)
    |> Enum.reduce(1, fn n, acc -> n * acc end)
  end

  def part2(input, opts \\ []) do
    width = Keyword.get(opts, :width, 101)
    height = Keyword.get(opts, :height, 103)

    process_input(input)
    |> sim_till_tree(width, height)
  end

  def sim(robot, width, height) do
    Enum.reduce(1..100, robot, fn _, r -> move_robot(r, width, height) end)
  end

  def move_robot(r, width, height) do
    {x, y} = r.position
    {dx, dy} = r.velocity

    %Robot{
      r
      | position: wrap({x + dx, y + dy}, width, height)
    }
  end

  def sim_till_tree(robots, width, height, depth \\ 0) do
    tree = check_tree(robots, width, height)

    if Integer.mod(depth, 1_000) == 0 do
      IO.puts("At depth #{depth}")
    end

    if not tree do
      Enum.map(robots, fn r -> move_robot(r, width, height) end)
      |> sim_till_tree(width, height, depth + 1)
    else
      depth
    end
  end

  def check_tree(robots, width, height) do
    counts =
      Enum.reduce(robots, Map.new(), fn robot, acc ->
        Map.put(acc, robot.position, 1 + Map.get(acc, robot.position, 0))
      end)

    {result, _} =
      Enum.reduce(counts, {false, MapSet.new()}, fn {{x, y}, _}, {result, visited} ->
        if not result do
          {group, visited} = group_dfs(counts, {x, y}, visited, width, height)

          if group >= 200 do
            {true, visited}
          else
            {false, visited}
          end
        else
          {result, visited}
        end
      end)

    result
  end

  def group_dfs(counts, {x, y}, visited, width, height) do
    if MapSet.member?(visited, {x, y}) or not Map.has_key?(counts, {x, y}) do
      {0, visited}
    else
      visited = MapSet.put(visited, {x, y})

      neighbors =
        [
          {x - 1, y},
          {x, y - 1},
          {x + 1, y},
          {x, y + 1},
          {x - 1, y - 1},
          {x + 1, y + 1},
          {x - 1, y + 1},
          {x + 1, y - 1}
        ]
        |> Enum.filter(fn {a, b} -> Map.has_key?(counts, {a, b}) end)

      {group, visited} =
        Enum.reduce(neighbors, {0, visited}, fn neighbor, {acc, visited_acc} ->
          {g, v} = group_dfs(counts, neighbor, visited_acc, width, height)
          {g + acc, v}
        end)

      {Map.fetch!(counts, {x, y}) + group, visited}
    end
  end

  def print_robots(robots, width, height) do
    counts =
      Enum.reduce(robots, Map.new(), fn robot, acc ->
        Map.put(acc, robot.position, 1 + Map.get(acc, robot.position, 0))
      end)

    grid =
      for y <- 0..height do
        Enum.reduce((width - 1)..0//-1, [], fn x, acc ->
          if Map.has_key?(counts, {x, y}) do
            [Integer.to_string(Map.get(counts, {x, y}, "0"))] ++ acc
          else
            [" "] ++ acc
          end
        end)
      end

    Enum.map(grid, fn row ->
      IO.puts(Enum.join(row))
    end)

    robots
  end

  def wrap({x, y}, width, height) do
    {wrap(x, width), wrap(y, height)}
  end

  def wrap(val, bound) do
    case val do
      v when v < 0 -> bound + v
      v when v >= bound -> v - bound
      v -> v
    end
  end

  def quadrants(robots, width, height) do
    # Filter those in the middle
    half_width = Integer.floor_div(width, 2)
    half_height = Integer.floor_div(height, 2)

    robots
    |> Enum.filter(fn robot ->
      {x, y} = robot.position
      not (half_width == x or half_height == y)
    end)
    |> Enum.reduce(Map.new(), fn robot, acc ->
      quadrant =
        case robot.position do
          {x, y} when x <= half_width and y <= half_height -> 0
          {x, y} when x > half_width and y <= half_height -> 1
          {x, y} when x <= half_width and y > half_height -> 2
          {x, y} when x > half_width and y > half_height -> 3
        end

      Map.put(acc, quadrant, [robot] ++ Map.get(acc, quadrant, []))
    end)
  end

  def process_input(input) do
    String.split(input, "\n")
    |> Enum.flat_map(fn s -> Regex.scan(~r"p=(\d+),(\d+) v=(\d+|-\d+),(\d+|-\d+)", s) end)
    |> Enum.map(fn l ->
      [_ | rest] = l
      [x_pos, y_pos, x_vel, y_vel] = Enum.map(rest, &parseint/1)

      %Robot{
        position: {x_pos, y_pos},
        velocity: {x_vel, y_vel}
      }
    end)
  end

  def parseint(s) do
    elem(Integer.parse(s), 0)
  end
end
