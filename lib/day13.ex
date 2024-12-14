defmodule Aoc24.Day13 do
  defmodule Question do
    defstruct [:a_deltas, :b_deltas, :target]
  end

  def part1(input) do
    process_input(input)
    |> Enum.map(&search/1)
    |> Enum.sum()
  end

  def part2(_) do
    0
  end

  def search(question) do
    answers =
      for a <- 0..100, b <- 0..100 do
        {a, b}
      end
      |> Enum.filter(fn {a, b} ->
        end_state = add_tuples(n_steps(a, question.a_deltas), n_steps(b, question.b_deltas))
        end_state == question.target
      end)
      |> Enum.map(fn {a, b} -> a * 3 + b end)

    if length(answers) < 1 do
      0
    else
      Enum.min(answers)
    end
  end

  def n_steps(n, {x_step, y_step}) do
    {x_step * n, y_step * n}
  end

  def add_tuples({a, b}, {c, d}) do
    {a + c, b + d}
  end

  def process_input(input) do
    pattern =
      ~r"Button A: X\+(\d+), Y\+(\d+)\nButton B: X\+(\d+), Y\+(\d+)\nPrize: X=(\d+), Y=(\d+)"

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
