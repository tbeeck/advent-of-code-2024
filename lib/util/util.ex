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
end
