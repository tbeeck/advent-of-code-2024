defmodule Aoc24.Day24 do
  def part1(input) do
    process_input(input)
    |> get_wire_val("z")
  end

  def part2(input) do
    values = process_input(input)

    target = get_wire_val(values, "x") + get_wire_val(values, "y")
    current = get_wire_val(values, "z")
    t_str = Integer.to_string(target, 2)
    c_str = Integer.to_string(current, 2)
    max_len = max(String.length(t_str), String.length(c_str))
    IO.puts("#{t_str |> String.pad_leading(max_len, "0")}")
    IO.puts("#{c_str |> String.pad_leading(max_len, "0")}")

    values
    |> set_input_wires(1, 1)
    |> IO.inspect()
    |> get_wire_val("z")
    |> IO.inspect()

    ""
  end

  def set_input_wires(values, x_val, y_val) do
    {new_vals, _} =
      Enum.reduce_while(0..63, {values, x_val}, fn i, {acc, cur_x} ->
        x_key =
          "x" <> (Integer.to_string(i) |> String.pad_leading(2, "0"))

        case Map.get(values, x_key) do
          nil -> {:halt, {acc, 0}}
          _ -> {:cont, {Map.put(acc, x_key, Integer.mod(cur_x, 2)), Integer.floor_div(cur_x, 2)}}
        end
      end)

    {new_vals, _} =
      Enum.reduce_while(0..63, {new_vals, y_val}, fn i, {acc, cur_y} ->
        y_key =
          "y" <> (Integer.to_string(i) |> String.pad_leading(2, "0"))

        case Map.get(values, y_key) do
          nil -> {:halt, {acc, 0}}
          _ -> {:cont, {Map.put(acc, y_key, Integer.mod(cur_y, 2)), Integer.floor_div(cur_y, 2)}}
        end
      end)

    new_vals
  end

  def get_wire_val(values, prefix) do
    Enum.reduce_while(0..63, 0, fn i, acc ->
      key =
        prefix <> (Integer.to_string(i) |> String.pad_leading(2, "0"))

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
