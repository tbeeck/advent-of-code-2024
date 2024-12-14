defmodule Aoc24.Day13 do
  defmodule Question do
    defstruct [:a_deltas, :b_deltas, :target]
  end

  def part1(input) do
    process_input(input)
    0
  end

  def part2(input) do
    0
  end

  def process_input(input) do
    pattern =
      ~r"Button A: X\+(\d+), Y\+(\d+)\nButton B: X\+(\d+), Y\+(\d+)\nPrize: X=(\d+), Y=(\d+)"
      |> IO.inspect()

    input
    |> String.split("\n\n")
    |> Enum.flat_map(fn s -> Regex.scan(pattern, s) end)
    |> Enum.map(fn l ->
      [_ | rest] = l
      [x1, y1, x2, y2, xp, yp] = Enum.map(rest, &parseint/1)

      %Question{
        a_deltas: {x1, y1},
        b_deltas: {x2, y2},
        target: {xp, yp}
      }
    end)
  end

  def parseint(s) do
    elem(Integer.parse(s), 0)
  end
end
