defmodule Aoc24.Day15 do
  defmodule State do
    defstruct [:grid, :position]
  end

  def part1(input) do
    {state, directions, _} =
      process_input(input, &parse_grid_p1/1)

    end_state =
      Enum.reduce(directions, state, fn direction, state_acc ->
        if can_move?(state_acc, state_acc.position, direction) do
          do_robot_move(state_acc, direction)
        else
          state_acc
        end
      end)

    score(end_state)
  end

  def part2(input) do
    {state, directions, _} = process_input(input, &parse_grid_p2/1)

    end_state =
      Enum.reduce(directions, state, fn direction, state_acc ->
        if can_move?(state_acc, state_acc.position, direction) do
          do_robot_move(state_acc, direction)
        else
          state_acc
        end
      end)

    score(end_state)
  end

  def score(state) do
    Enum.map(state.grid, fn {{x, y}, val} ->
      if val in [:box, :box_l] do
        100 * y + x
      else
        0
      end
    end)
    |> Enum.sum()
  end

  def do_robot_move(state, direction) do
    state =
      do_move(state, state.position, direction)

    new_pos = new_position(state.position, direction)

    %State{
      state
      | position: new_pos
    }
  end

  def do_move(state, position, direction) do
    cur_val = Map.get(state.grid, position, :free)

    if cur_val == :free do
      state
    else
      new_pos = new_position(position, direction)

      state =
        if direction in [:up, :down] and cur_val in [:box_l, :box_r] do
          case cur_val do
            :box_l ->
              do_move(state, new_position(new_pos, :right), direction)
              |> do_move(new_pos, direction)

            :box_r ->
              do_move(state, new_position(new_pos, :left), direction)
              |> do_move(new_pos, direction)
          end
        else
          do_move(state, new_pos, direction)
        end

      val = Map.get(state.grid, position)

      new_grid =
        if direction in [:up, :down] and cur_val in [:box_l, :box_r] do
          case cur_val do
            :box_l ->
              Map.delete(state.grid, position)
              |> Map.delete(new_position(position, :right))
              |> Map.put(new_pos, val)
              |> Map.put(new_position(new_pos, :right), :box_r)

            :box_r ->
              Map.delete(state.grid, position)
              |> Map.delete(new_position(position, :left))
              |> Map.put(new_pos, val)
              |> Map.put(new_position(new_pos, :left), :box_l)
          end
        else
          Map.delete(state.grid, position)
          |> Map.put(new_pos, val)
        end

      %State{state | grid: new_grid}
    end
  end

  def can_move?(state, position, direction) do
    new_pos = new_position(position, direction)
    new_val = Map.get(state.grid, new_pos, :free)

    case new_val do
      :free ->
        true

      :box ->
        can_move?(state, new_pos, direction)

      :box_l ->
        if direction == :up or direction == :down do
          other_pos =
            new_position(position, direction)
            |> new_position(:right)

          can_move?(state, new_pos, direction) and
            can_move?(state, other_pos, direction)
        else
          can_move?(state, new_pos, direction)
        end

      :box_r ->
        if direction == :up or direction == :down do
          other_pos =
            new_position(position, direction)
            |> new_position(:left)

          can_move?(state, new_pos, direction) and
            can_move?(state, other_pos, direction)
        else
          can_move?(state, new_pos, direction)
        end

      _ ->
        false
    end
  end

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

  def find_robot(grid) do
    elem(
      Enum.find(grid, fn {_, val} ->
        val == :robot
      end),
      0
    )
  end

  def process_input(input, grid_parser) do
    parsed_grid = grid_parser.(input)
    directions = parse_directions(input)

    state = %State{
      grid: parsed_grid,
      position: find_robot(parsed_grid)
    }

    {width, height} = dimensions(parsed_grid)
    {state, directions, {width, height}}
  end

  def parse_grid_p1(input) do
    [grid | _] = String.split(input, "\n\n")

    String.split(grid)
    |> Enum.with_index()
    |> Enum.reduce(Map.new(), fn {row, y}, acc ->
      Enum.with_index(String.graphemes(row))
      |> Enum.reduce(acc, fn {char, x}, inner_acc ->
        case char do
          "#" -> Map.put(inner_acc, {x, y}, :wall)
          "O" -> Map.put(inner_acc, {x, y}, :box)
          "@" -> Map.put(inner_acc, {x, y}, :robot)
          _ -> inner_acc
        end
      end)
    end)
  end

  def parse_grid_p2(input) do
    [grid | _] = String.split(input, "\n\n")

    String.split(grid)
    |> Enum.with_index()
    |> Enum.reduce(Map.new(), fn {row, y}, acc ->
      String.graphemes(row)
      |> Enum.reduce([], fn char, inner_acc ->
        case char do
          "#" -> [:wall, :wall] ++ inner_acc
          # will get reversed
          "O" -> [:box_r, :box_l] ++ inner_acc
          "@" -> [:free, :robot] ++ inner_acc
          "." -> [:free, :free] ++ inner_acc
        end
      end)
      |> Enum.reverse()
      |> Enum.with_index()
      |> Enum.reduce(acc, fn {val, x}, inner_acc ->
        if val != :free do
          Map.put(inner_acc, {x, y}, val)
        else
          inner_acc
        end
      end)
    end)
  end

  def parse_directions(input) do
    [_, directions] = String.split(input, "\n\n")

    String.split(directions)
    |> Enum.join()
    |> String.graphemes()
    |> Enum.map(fn char ->
      case char do
        "^" -> :up
        "v" -> :down
        "<" -> :left
        ">" -> :right
      end
    end)
  end

  def dimensions(grid) do
    Enum.reduce(grid, {0, 0}, fn {{x, y}, _}, {max_x, max_y} ->
      {max(x + 1, max_x), max(y + 1, max_y)}
    end)
  end

  def draw_grid(state, {width, height}) do
    for y <- 0..(height - 1) do
      Enum.reduce(0..(width - 1), [], fn x, acc ->
        char =
          case Map.get(state.grid, {x, y}) do
            :wall -> "#"
            :robot -> "@"
            :box -> "O"
            :box_l -> "["
            :box_r -> "]"
            nil -> "."
          end

        [char] ++ acc
      end)
      |> Enum.reverse()
    end
    |> IO.inspect(limit: :infinity)

    state
  end
end
