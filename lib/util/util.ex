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

  @spec radius_around({integer(), integer()}, integer()) :: [{integer(), integer()}, ...]
  def radius_around({x, y}, r) do
    for a <- (x - r)..(x + r),
        b <- (y - r)..(y + r),
        manhattan_distance({x, y}, {a, b}) <= r,
        {a, b} != {x, y},
        do: {a, b}
  end

  @spec manhattan_distance({integer(), integer()}, {integer(), integer()}) :: integer()
  def manhattan_distance({a, b}, {c, d}) do
    abs(a - c) + abs(b - d)
  end

  @spec all_orders_of(list()) :: [list(), ...]
  def all_orders_of(l) when length(l) == 0, do: []
  def all_orders_of(l) when length(l) == 1, do: [l]

  def all_orders_of([first | rest]) do
    remaining = all_orders_of(rest)

    Enum.reduce(remaining, [], fn l, acc ->
      acc ++ [[first] ++ l] ++ [l ++ [first]]
    end)
    |> Enum.uniq_by(fn l -> List.to_tuple(l) end)
  end

  # Choose combinations
  @spec choose(list(any()), integer()) :: list(list(any()))
  def choose(_, n) when n == 0, do: []
  @spec choose(list(any()), integer()) :: list(list(any()))
  def choose(vals, n) when n == 1, do: Enum.map(vals, fn val -> {val} end)

  @spec choose(list(any()), integer()) :: list(list(any()))
  def choose(vals, n) do
    next_groups =
      choose(vals, n - 1)

    Enum.flat_map(next_groups, fn group ->
      existing = MapSet.new(Tuple.to_list(group))

      Enum.map(vals, fn val ->
        if val in existing do
          nil
        else
          Tuple.insert_at(group, 0, val)
          |> Tuple.to_list()
          |> Enum.sort()
          |> List.to_tuple()
        end
      end)
    end)
    |> Enum.filter(fn group -> group != nil end)
    |> Enum.map(fn t -> t |> Tuple.to_list() |> Enum.sort() |> List.to_tuple() end)
    |> Enum.uniq()
  end
end
