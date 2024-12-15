defmodule Aoc24.Day15 do
  defmodule State do
    defstruct [:grid, :position]
  end

  def part1(input) do
    {state, directions, dimensions} =
      process_input(input)

    end_state =
      Enum.reduce(directions, state, fn direction, state_acc ->
        if can_move?(state_acc, state_acc.position, direction) do
          do_robot_move(state_acc, direction, dimensions)
        else
          state_acc
        end
      end)

    Enum.map(end_state.grid, fn {{x, y}, val} ->
      if val == :box do
        (100 * y + x)
        |> IO.inspect()
      else
        0
      end
    end)
    |> Enum.sum()
  end

  def do_robot_move(state, direction, dimensions) do
    state =
      do_move(state, state.position, direction)
      |> draw_grid(dimensions)

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
      state = do_move(state, new_pos, direction)

      val = Map.get(state.grid, position)

      new_grid =
        Map.delete(state.grid, position)
        |> Map.put(new_pos, val)

      %State{state | grid: new_grid}
    end
  end

  def can_move?(state, position, direction) do
    new_pos = new_position(position, direction)

    case Map.get(state, new_pos, :free) do
      :edge -> true
      :free -> true
      :box -> can_move?(state, new_pos, direction)
      _ -> false
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

  def part2(input) do
    0
  end

  def find_robot(grid) do
    elem(
      Enum.find(grid, fn {_, val} ->
        val == :robot
      end),
      0
    )
  end

  def process_input(input) do
    [grid, directions] = String.split(input, "\n\n")

    parsed_grid =
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

    height =
      String.split(grid)
      |> length()

    width =
      String.split(grid)
      |> Enum.at(0)
      |> String.graphemes()
      |> length()

    directions =
      String.graphemes(directions)
      |> Enum.map(fn char ->
        case char do
          "^" -> :up
          "v" -> :down
          "<" -> :left
          ">" -> :right
        end
      end)

    state = %State{
      grid: parsed_grid,
      position: find_robot(parsed_grid)
    }

    {state, directions, {width, height}}
  end

  def draw_grid(state, {width, height}) do
    for y <- 0..(height - 1) do
      Enum.reduce(0..(width - 1), [], fn x, acc ->
        char =
          case Map.get(state.grid, {x, y}) do
            :wall -> "#"
            :robot -> "@"
            :box -> "O"
            nil -> "."
          end

        [char] ++ acc
      end)
      |> Enum.reverse()
    end
    |> IO.inspect()

    state
  end
end
