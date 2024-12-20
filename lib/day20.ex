defmodule Aoc24.Day20 do
  alias Aoc24.Util

  def part1(input) do
    grid =
      process_input(input)
      |> IO.inspect(width: 200)

    start_point = Util.find_first_in_2d_tuple(grid, :start)
    end_point = Util.find_first_in_2d_tuple(grid, :end)
    0
  end

  def process_input(input) do
    grid =
      String.split(input)
      |> Enum.map(fn row ->
        String.graphemes(row)
        |> Enum.map(fn char ->
          case char do
            "#" -> :wall
            "." -> :free
            "S" -> :start
            "E" -> :end
          end
        end)
        |> List.to_tuple()
      end)
      |> List.to_tuple()

    grid
  end
end
