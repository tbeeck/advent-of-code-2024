defmodule Aoc24.Day24 do
  def part1(input) do
    values =
      process_input(input)
      |> IO.inspect()

    Enum.reduce_while(0..63, 0, fn i, acc ->
      key =
        ("z" <> (Integer.to_string(i) |> String.pad_leading(2, "0")))
        |> IO.inspect()

      case Map.get(values, key) do
        nil -> {:halt, acc}
        _ -> {:cont, acc + Bitwise.bsl(eval(key, values), i)}
      end
    end)
  end

  def eval(value, values) do
    case Map.get(values, value) do
      {op, lhs, rhs} ->
        apply_op(op, eval(lhs, values), eval(rhs, values))

      int ->
        int
    end
  end

  def apply_op(op, a, b) do
    case op do
      :and -> Bitwise.band(a, b)
      :or -> Bitwise.bor(a, b)
      :xor -> Bitwise.bxor(a, b)
    end
  end

  def process_input(input) do
    [initial_vals, exprs] = String.split(input, "\n\n")

    values =
      initial_vals
      |> String.split("\n")
      |> Enum.map(fn line ->
        [l, r] = String.split(line, ": ")

        {l, String.to_integer(r)}
      end)
      |> Enum.reduce(Map.new(), fn {k, v}, acc -> Map.put(acc, k, v) end)

    exprs
    |> String.split("\n")
    |> Enum.map(fn line ->
      # ntg XOR fgs -> mjb
      line_pat = ~r"(.{3}) (XOR|AND|OR) (.{3}) -> (.{3})"

      [[_, lhs, op, rhs, val]] =
        Regex.scan(line_pat, line)

      op =
        String.downcase(op)
        |> String.to_atom()

      {lhs, rhs, op, val}
    end)
    |> Enum.reduce(values, fn {lhs, rhs, op, val}, acc ->
      Map.put(acc, val, {op, lhs, rhs})
    end)
  end
end
