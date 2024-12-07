defmodule Aoc24.Day6 do
  defmodule Grid do
    defstruct [:width, :height, :grid, :position, :visited, :direction, :ends_in_cycle]
  end

  def directions do
    [
      {-1, 0},
      {0, 1},
      {1, 0},
      {0, -1}
    ]
  end

  def new_grid(input) do
    grid_list = make_grid(input)
    start = find_start(grid_list) |> List.first()

    %Grid{
      grid: grid_list,
      height: length(grid_list),
      width: length(List.first(grid_list)),
      visited: MapSet.new(),
      position: start,
      direction: 0,
      ends_in_cycle: true
    }
  end

  def part1(input) do
    result =
      new_grid(input)
      |> walk()

    MapSet.to_list(result.visited)
    |> Enum.map(fn {pos, _} -> pos end)
    |> Enum.sort()
    |> Enum.dedup()
    |> length()
  end

  def part2(input) do
    grid = new_grid(input)

    for row <- 0..(grid.height - 1), col <- 0..(grid.width - 1) do
      {row, col}
    end
    |> Task.async_stream(
      fn {row, col} ->
        if can_try_block?(grid, row, col) do
          temp_grid = fill_grid_with_coords([{row, col}], grid, "#")
          %{ends_in_cycle: ends_in_cycle} = walk(temp_grid)
          ends_in_cycle
        else
          false
        end
      end,
      max_concurrency: System.schedulers_online(),
      timeout: :infinity
    )
    |> Enum.map(fn {:ok, result} -> result end)
    |> Enum.frequencies()
    |> Map.get(true, 0)
  end

  def walk(grid) do
    if {grid.position, grid.direction} in grid.visited do
      grid
    else
      walk(next_state(grid))
    end
  end

  def can_try_block?(grid, row, col) do
    char = Enum.at(Enum.at(grid.grid, row), col)
    char == "."
  end

  def print_filled_grid(coords, grid) do
    fill_grid_with_coords(coords, grid, "X")
    |> IO.inspect()

    coords
  end

  def fill_grid_with_coords(coords, grid, char) do
    coords
    |> Enum.reduce(grid, fn {row, col}, acc_grid ->
      new_grid =
        List.replace_at(
          acc_grid.grid,
          row,
          List.replace_at(Enum.at(acc_grid.grid, row), col, char)
        )

      %Grid{
        acc_grid
        | grid: new_grid
      }
    end)
  end

  def next_state(grid) do
    new_visited = MapSet.put(grid.visited, {grid.position, grid.direction})
    {forward, new_pos} = can_go_forward(grid)

    if forward do
      {row, col} = new_pos

      if not in_bounds(row, col, grid) do
        %Grid{grid | visited: new_visited, ends_in_cycle: false}
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

    if in_bounds(new_row, new_col, grid) do
      char = Enum.at(Enum.at(grid.grid, new_row), new_col)
      {char != "#", {new_row, new_col}}
    else
      {true, {new_row, new_col}}
    end
  end

  def in_bounds(row, col, grid) do
    0 <= row and row < grid.height and 0 <= col and col < grid.width
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
  end
end
