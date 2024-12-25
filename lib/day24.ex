defmodule Aoc24.Day24 do
  def part1(input) do
    process_input(input)
    |> get_wire_val("z")
  end

  def part2(input) do
    values = process_input(input)

    values
    |> print_state()

    Enum.map(0..45, fn i ->
      z_key = wire_key("z", i)
      IO.puts("-- #{z_key} --")

      real_pin =
        build_expr(values, z_key)
        |> normalize_expr()

      build_pin =
        build_pin(i)
        |> normalize_expr()

      if build_pin != real_pin do
        IO.inspect(build_pin, limit: :infinity)
        IO.inspect(real_pin, limit: :infinity)
      end

      # build_expr(values, z_key)
      # |> IO.inspect(limit: :infinity)
    end)

    ""
  end

  def build_pin(bit) when bit == 0 do
    {:xor, "x00", "y00"}
  end

  def build_pin(bit) when bit == 1 do
    {:xor, {:and, "x00", "y00"}, {:xor, "x01", "y01"}}
  end

  def build_pin(bit) when bit == 2 do
    {:xor, {:or, {:and, {:and, "x00", "y00"}, {:xor, "x01", "y01"}}, {:and, "x01", "y01"}},
     {:xor, "x02", "y02"}}
  end

  def build_pin(bit) do
    {carry_term, xor_term} = get_carry_xor_terms(build_pin(bit - 1))
    x_n = wire_key("x", bit)
    y_n = wire_key("y", bit)
    x_n1 = wire_key("x", bit - 1)
    y_n1 = wire_key("y", bit - 1)
    {:xor, {:or, {:and, x_n1, y_n1}, {:and, carry_term, xor_term}}, {:xor, x_n, y_n}}
  end

  def get_carry_xor_terms(expr) do
    {_op, t1, t2} = expr

    case t1 do
      {:or, _, _} -> {t1, t2}
      {:xor, _, _} -> {t2, t1}
    end
  end

  def print_state(values) do
    target = get_wire_val(values, "x") + get_wire_val(values, "y")
    current = get_wire_val(values, "z")
    t_str = Integer.to_string(target, 2) |> String.pad_leading(64, "0")
    c_str = Integer.to_string(current, 2) |> String.pad_leading(64, "0")
    IO.puts("Target\t#{t_str} - #{target}")
    IO.puts("Current\t#{c_str} - #{current}")
    print_mismatches(values)
  end

  def print_mismatches(values) do
    target = get_wire_val(values, "x") + get_wire_val(values, "y")
    current = get_wire_val(values, "z")
    mismatches = mismatched_bit_indexes(target, current)
    IO.puts("Mismatches at: #{Enum.join(mismatches, ", ")}\n")
  end

  def mismatched_bit_indexes(a, b, depth \\ 0)
  def mismatched_bit_indexes(a, b, _) when a == b, do: []

  def mismatched_bit_indexes(a, b, depth) do
    remaining =
      mismatched_bit_indexes(Integer.floor_div(a, 2), Integer.floor_div(b, 2), depth + 1)

    if Integer.mod(a, 2) != Integer.mod(b, 2) do
      [depth] ++ remaining
    else
      remaining
    end
  end

  def build_expr_names(values, name) do
    case Map.get(values, name) do
      {op, lhs, rhs} ->
        {op, {lhs, build_expr_names(values, lhs)}, {rhs, build_expr_names(values, rhs)}}

      int ->
        int
    end
  end

  def build_expr(values, name) do
    case Map.get(values, name) do
      {op, lhs, rhs} -> {op, build_expr(values, lhs), build_expr(values, rhs)}
      _ -> name
    end
  end

  def normalize_expr(expr) do
    case expr do
      {op, lhs, rhs} when is_binary(lhs) and is_binary(rhs) ->
        [small, big] = [lhs, rhs] |> Enum.sort()
        {op, small, big}

      {op, lhs, rhs} when is_binary(lhs) ->
        {op, lhs, normalize_expr(rhs)}

      {op, lhs, rhs} when is_binary(rhs) ->
        {op, rhs, normalize_expr(lhs)}

      {op, lhs, rhs} ->
        [small, big] = [lhs, rhs] |> Enum.sort() |> Enum.map(&normalize_expr/1)
        {op, small, big}

      bin ->
        bin
    end
  end

  def relevant_wires(val) when is_integer(val), do: MapSet.new()
  def relevant_wires({name, val}) when is_integer(val), do: MapSet.new([name])

  def relevant_wires({_op, {lhs_name, lhs}, {rhs_name, rhs}}) do
    MapSet.union(relevant_wires(lhs), relevant_wires(rhs))
    |> MapSet.put(lhs_name)
    |> MapSet.put(rhs_name)
  end

  def set_input_wires(values, x_val, y_val) do
    {new_vals, _} =
      Enum.reduce_while(0..63, {values, x_val}, fn i, {acc, cur_x} ->
        x_key =
          wire_key("x", i)

        case Map.get(values, x_key) do
          nil -> {:halt, {acc, 0}}
          _ -> {:cont, {Map.put(acc, x_key, Integer.mod(cur_x, 2)), Integer.floor_div(cur_x, 2)}}
        end
      end)

    {new_vals, _} =
      Enum.reduce_while(0..63, {new_vals, y_val}, fn i, {acc, cur_y} ->
        y_key =
          wire_key("y", i)

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

  def wire_key(prefix, index) do
    prefix <> (Integer.to_string(index) |> String.pad_leading(2, "0"))
  end
end
