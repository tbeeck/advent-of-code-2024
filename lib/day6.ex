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
    start = find_start(grid) |> List.first()

    result =
      %Grid{
        grid: grid,
        height: length(grid),
        width: length(List.first(grid)),
        visited: MapSet.new(),
        position: start,
        direction: 0
      }
      |> walk()

    MapSet.to_list(result.visited)
    |> Enum.map(fn {pos, _} -> pos end)
    |> Enum.dedup()
    |> IO.inspect()
    |> length()
  end

  def part2(input) do
    0
  end

  def walk(grid) do
    if {grid.position, grid.direction} in grid.visited do
      grid
    else
      walk(next_state(grid))
    end
  end

  def next_state(grid) do
    new_visited = MapSet.put(grid.visited, {grid.position, grid.direction})
    {forward, new_pos} = can_go_forward(grid)

    if forward do
      {a, b} = new_pos

      if not in_bounds(a, b, grid) do
        %Grid{grid | visited: new_visited}
      else
        %Grid{
          grid
          | visited: new_visited,
            position: new_pos
        }
      end
    else
      %Grid{
        grid
        | visited: new_visited,
          direction: Integer.mod(grid.direction + 1, length(directions()))
      }
    end
  end

  def can_go_forward(grid) do
    {row, col} = grid.position
    {d_row, d_col} = Enum.at(directions(), Integer.mod(grid.direction, length(directions())))
    {new_row, new_col} = {d_row + row, d_col + col}

    possible =
      not in_bounds(new_row, new_col, grid) or
        Enum.at(Enum.at(grid.grid, new_row), new_col) == "."

    {possible, {new_row, new_col}}
  end

  def in_bounds(row, col, grid) do
    0 <= row and row <= grid.height and 0 <= col and col <= grid.width
  end

  @spec find_start(any()) :: list()
  def find_start(grid) do
    for {row, i} <- Enum.with_index(grid),
        {val, j} <- Enum.with_index(row),
        val == "^",
        do: {i, j}
  end

  def make_grid(input) do
    input
    |> String.split()
    |> Enum.map(fn line -> String.graphemes(line) end)
    |> IO.inspect()
  end
end
