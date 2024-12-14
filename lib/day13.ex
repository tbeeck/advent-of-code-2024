defmodule Aoc24.Day13 do
  defmodule Question do
    defstruct [:a_deltas, :b_deltas, :target]
  end

  def part1(input) do
    process_input(input)
    |> Enum.map(&search_p1/1)
    |> Enum.sum()
  end

  def part1_optimized(input) do
    process_input(input)
    |> Enum.map(&search_p2/1)
    |> Enum.sum()
  end

  def part2(input) do
    offset = 10_000_000_000_000

    process_input(input)
    |> Enum.map(fn question ->
      %Question{
        question
        | target: add_tuples(question.target, {offset, offset})
      }
    end)
    |> Enum.map(&search_p2/1)
    |> Enum.sum()
  end

  def search_p1(question) do
    answers =
      for a <- 0..100, b <- 0..100 do
        {a, b}
      end
      |> Enum.filter(fn {a, b} ->
        end_state(question, a, b) == question.target
      end)
      |> Enum.map(fn {a, b} -> end_cost(a, b) end)

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

  def end_state(question, a, b) do
    add_tuples(n_steps(a, question.a_deltas), n_steps(b, question.b_deltas))
  end

  def end_cost(a, b), do: a * 3 + b

  def search_p2(question) do
    x_equation = x_eq(question)
    y_equation = y_eq(question)
    result = intersection(x_equation, y_equation)

    case result do
      {:parallel} ->
        0

      {:ok, {a, b}} when a < 0 or b < 0 ->
        0

      {:ok, {a, b}} ->
        # Floating point inprecision -- loop over pairs within a reasonable range
        # and verify an answer
        answers =
          for real_a <- (a - 100)..(a + 100),
              real_b <- (b - 100)..(b + 100),
              end_state(question, real_a, real_b) == question.target do
            end_cost(real_a, real_b)
          end

        if length(answers) < 1 do
          0
        else
          Enum.at(answers, 0)
        end
    end
  end

  def x_eq(question) do
    {x_a, _} = question.a_deltas
    {x_b, _} = question.b_deltas
    {t_x, _} = question.target
    # (t_x - x_a * a) / x_b
    # mx + c
    m = -x_a / x_b
    c = t_x / x_b
    {m, c}
  end

  def y_eq(question) do
    {_, y_a} = question.a_deltas
    {_, y_b} = question.b_deltas
    {_, t_y} = question.target
    # (t_y - y_a * a) / y_b
    # mx + c
    m = -y_a / y_b
    c = t_y / y_b
    {m, c}
  end

  def intersection({m1, b1}, {m2, b2}) do
    if m1 == m2 do
      {:parallel}
    else
      x = floor((b2 - b1) / (m1 - m2))
      y = floor(m1 * x + b1)
      {:ok, {x, y}}
    end
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
