defmodule Aoc24.Util do
  @spec parseint(binary()) :: integer()
  def parseint(s) do
    elem(Integer.parse(s), 0)
  end

  @spec neighbors_of({integer(), integer()}) :: [{integer(), integer()}, ...]
  def neighbors_of({x, y}) do
    [
      {x + 1, y},
      {x, y + 1},
      {x - 1, y},
      {x, y - 1}
    ]
  end

  @spec in_bounds?({integer(), integer()}, {integer(), integer()}) :: boolean()
  def in_bounds?({x, y}, {width, height}) do
    0 <= x and x < width and 0 <= y and y < height
  end
end
