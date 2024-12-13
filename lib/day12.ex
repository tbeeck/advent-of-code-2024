defmodule Aoc24.Day12 do
  defmodule Grid do
    defstruct [:grid, :width, :height, :visited, :regions]
  end

  def part1(input) do
    grid =
      process_input(input)
      |> make_regions()

    cost(grid, &region_cost_p1/2)
  end

  def part2(input) do
    grid =
      process_input(input)
      |> make_regions()

    cost(grid, &region_cost_p2/2)
  end

  def cost(grid, region_cost_func) do
    grid.regions
    |> Enum.map(fn {_, region} -> region_cost_func.(grid, region) end)
    |> Enum.sum()
  end

  def region_cost_p1(grid, region) do
    perimeter =
      region
      |> Enum.map(fn pair -> edges(grid, pair) end)
      |> Enum.sum()

    length(region) * perimeter
  end

  def region_cost_p2(grid, region) do
    length(region) * sides(grid, region)
  end

  def make_regions(grid) do
    for i <- 0..(grid.height - 1), j <- 0..(grid.width - 1) do
      {i, j}
    end
    |> Enum.reduce(grid, fn {i, j}, grid -> dfs(grid, {i, j}, {i, j}) end)
  end

  def dfs(grid, {i, j}, start_point) do
    if {i, j} in grid.visited do
      grid
    else
      grid = %Grid{grid | visited: MapSet.put(grid.visited, {i, j})}

      grid =
        matching_neighbors(grid, {i, j})
        |> Enum.reduce(grid, fn {a, b}, grid_acc -> dfs(grid_acc, {a, b}, start_point) end)

      region = [{i, j}] ++ Map.get(grid.regions, start_point, [])

      %Grid{
        grid
        | regions: Map.put(grid.regions, start_point, region)
      }
    end
  end

  def matching_neighbors(grid, {i, j}) do
    [{i + 1, j}, {i - 1, j}, {i, j + 1}, {i, j - 1}]
    |> Enum.filter(fn {a, b} -> in_bounds?(grid, {a, b}) end)
    |> Enum.filter(fn {a, b} -> elem(elem(grid.grid, i), j) == elem(elem(grid.grid, a), b) end)
  end

  def mismatched_neighbors(grid, {i, j}) do
    [{i + 1, j}, {i - 1, j}, {i, j + 1}, {i, j - 1}]
    |> Enum.filter(fn {a, b} -> in_bounds?(grid, {a, b}) end)
    |> Enum.filter(fn {a, b} -> elem(elem(grid.grid, i), j) != elem(elem(grid.grid, a), b) end)
  end

  def edges(grid, {i, j}) do
    [{i + 1, j}, {i - 1, j}, {i, j + 1}, {i, j - 1}]
    |> Enum.filter(fn {a, b} ->
      !in_bounds?(grid, {a, b}) or elem(elem(grid.grid, i), j) != elem(elem(grid.grid, a), b)
    end)
    |> length()
  end

  def sides(grid, region) do
    region
    |> Enum.map(fn pair -> corners(grid, pair) end)
    |> Enum.sum()
  end

  def corners(grid, {i, j}) do
    val = val_at(grid, {i, j})

    outer_corners =
      [
        [{i - 1, j}, {i, j - 1}],
        [{i - 1, j}, {i, j + 1}],
        [{i + 1, j}, {i, j + 1}],
        [{i + 1, j}, {i, j - 1}]
      ]
      |> Enum.count(fn [p1, p2] ->
        (not in_bounds?(grid, p1) or val_at(grid, p1) != val) and
          (not in_bounds?(grid, p2) or val_at(grid, p2) != val)
      end)

    inner_corners =
      [
        [{i - 1, j - 1}, [{i, j - 1}, {i - 1, j}]],
        [{i - 1, j + 1}, [{i - 1, j}, {i, j + 1}]],
        [{i + 1, j - 1}, [{i, j - 1}, {i + 1, j}]],
        [{i + 1, j + 1}, [{i + 1, j}, {i, j + 1}]]
      ]
      |> Enum.filter(fn [pair | _] -> in_bounds?(grid, pair) and val_at(grid, pair) != val end)
      |> Enum.count(fn [_, matchers] ->
        Enum.all?(matchers, fn pair -> val_at(grid, pair) == val end)
      end)

    outer_corners + inner_corners
  end

  def val_at(grid, {a, b}) do
    elem(elem(grid.grid, a), b)
  end

  def in_bounds?(grid, {a, b}) do
    0 <= a and a < grid.height and 0 <= b and b < grid.width
  end

  def process_input(input) do
    chart =
      input
      |> String.split()
      |> Enum.map(fn s -> String.graphemes(s) |> List.to_tuple() end)
      |> List.to_tuple()

    %Grid{
      height: tuple_size(chart),
      width: tuple_size(elem(chart, 0)),
      grid: chart,
      visited: MapSet.new(),
      regions: %{}
    }
  end
end
