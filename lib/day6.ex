defmodule Aoc24.Day6 do
  defmodule Grid do
    defstruct [:width, :height, :grid, :position, :visited, :direction]
  end
  def directions do
    [
      {-1, 0},
      {0, 1},
      {1, 0},
      {0, -1}
    ]
  end

  def part1(input) do
    grid = make_grid(input)
    height = length(grid)
    width = length(List.first(grid))
    start = find_start(grid)
    grid_struct = %Grid{
      width: width,
      height: height,
      grid: grid,
      visited: MapSet.new([start]),
      position: start,
      direction: 0
    }
    |> IO.inspect()

    0
  end

  def part2(input) do
    0
  end

  def find_start(grid) do
    for {row, i} <- Enum.with_index(grid),
        {val, j} <- Enum.with_index(row),
        val == "^", do: {i, j}
  end

  def make_grid(input) do
    input
    |> String.split()
    |> Enum.map(fn line -> String.graphemes(line) end)
    |> IO.inspect()
  end
end
