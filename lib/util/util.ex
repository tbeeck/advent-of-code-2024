defmodule Aoc24.Util do
  @spec parseint(binary()) :: integer()
  def parseint(s) do
    elem(Integer.parse(s), 0)
  end

  @spec neighbors_of({integer(), integer()}) :: [{integer(), integer()}, ...]
  def neighbors_of(origin) do
    directions()
    |> Enum.map(fn d -> new_position(origin, d) end)
  end

  @spec in_bounds?({integer(), integer()}, {integer(), integer()}) :: boolean()
  def in_bounds?({x, y}, {width, height}) do
    0 <= x and x < width and 0 <= y and y < height
  end

  @spec valid_neighbors({integer(), integer()}, any()) :: [{integer(), integer()}, ...]
  def valid_neighbors(origin, dimensions) do
    neighbors_of(origin)
    |> Enum.filter(fn n -> in_bounds?(n, dimensions) end)
  end

  @spec directions() :: [:down | :left | :right | :up, ...]
  def directions() do
    [
      :up,
      :right,
      :down,
      :left
    ]
  end

  @spec new_position({number(), number()}, :down | :left | :right | :up) :: {number(), number()}
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

  @spec find_first_in_2d_tuple(tuple(), any()) :: {integer(), integer()} | nil
  def find_first_in_2d_tuple(grid, value) do
    {width, height} = tuple_dimensions_2d(grid)

    vals =
      for x <- 0..(width - 1),
          y <- 0..(height - 1),
          grid_val(grid, {x, y}) == value,
          do: {x, y}

    List.first(vals, nil)
  end

  @spec tuple_dimensions_2d(tuple()) :: {integer(), integer()}
  def tuple_dimensions_2d(grid) do
    height = tuple_size(grid)
    width = tuple_size(elem(grid, 0))
    {width, height}
  end

  @spec grid_val(tuple(), {integer(), integer()}) :: any() | nil
  def grid_val(grid, {x, y}) do
    dims = tuple_dimensions_2d(grid)

    if in_bounds?({x, y}, dims) do
      elem(elem(grid, y), x)
    else
      nil
    end
  end
end