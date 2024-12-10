defmodule Aoc24.Day10 do
  defmodule Grid do
    defstruct [:width, :height, :grid, :visited]
  end

  def part1(input) do
    map = process_input(input)

    grid = %Grid{
      grid: map,
      height: tuple_size(map),
      width: tuple_size(elem(map, 0)),
      visited: MapSet.new()
    }

    for row <- 0..(grid.height - 1), col <- 0..(grid.width - 1) do
      if elem(elem(grid.grid, row), col) == 0 do
        IO.inspect({row, col})
        nines = dfs(grid, {row, col})
        |> Enum.sort()
        |> Enum.dedup()
        |> IO.inspect()
        length(nines)
      else
        0
      end
    end
    |> Enum.sum()
  end

  def dfs(grid, {row, col}) do
    if not in_bounds?(grid, {row, col}) or visited?(grid, {row, col}) do
      []
    else
      val = elem(elem(grid.grid, row), col)
      grid = %Grid{grid | visited: MapSet.put(grid.visited, {row, col})}

      neighbors =
        [
          {row + 1, col},
          {row, col + 1},
          {row - 1, col},
          {row, col - 1}
        ]

      results =
        neighbors
        |> Enum.filter(fn {a, b} -> in_bounds?(grid, {a, b}) end)
        |> Enum.filter(fn {a, b} -> not visited?(grid, {a, b}) end)
        |> Enum.filter(fn {a, b} -> elem(elem(grid.grid, a), b) == val+1 end)
        |> Enum.flat_map(fn {a, b} -> dfs(grid, {a, b}) end)

      if elem(elem(grid.grid, row), col) == 9 do
        [{row, col}]
      else
        results
      end
    end
  end

  def in_bounds?(grid, {row, col}) do
    0 <= col and col < grid.width and 0 <= row and row < grid.height
  end

  def visited?(grid, {row, col}) do
    {row, col} in grid.visited
  end

  def part2(input) do
    0
  end

  def process_input(input) do
    input
    |> String.split()
    |> Enum.map(&String.graphemes/1)
    |> Enum.map(fn l ->
      Enum.map(l, fn n -> Integer.parse(n) |> elem(0) end)
    end)
    |> Enum.map(&List.to_tuple/1)
    |> List.to_tuple()
  end
end
