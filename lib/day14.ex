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

  def part2(input) do
    0
  end

  def sim(robot, width, height) do
    Enum.reduce(1..100, robot, fn _, r ->
      {x, y} = r.position
      {dx, dy} = r.velocity

      %Robot{
        robot
        | position: wrap({x + dx, y + dy}, width, height)
      }
    end)
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
