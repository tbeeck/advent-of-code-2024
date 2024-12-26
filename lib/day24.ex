defmodule Aoc24.Day24 do
  def part1(input) do
    process_input(input)
    |> get_wire_val("z")
  end

  def part2(input) do
    values = process_input(input)

    Enum.reduce(0..45, {values, MapSet.new()}, fn i, {values_acc, pins_acc} ->
      z_key = wire_key("z", i)
      IO.puts("-- #{z_key} --")

      expression_names =
        Enum.reduce(values_acc, MapSet.new(), fn {k, _}, acc ->
          Map.put(acc, build_expr(values_acc, k) |> normalize_expr(), k)
        end)

      correct_pin =
        build_pin(i)
        |> normalize_expr()

      real_pin =
        build_expr(values_acc, z_key)
        |> normalize_expr()

      if real_pin != correct_pin do
        want =
          determine_composition(expression_names, correct_pin)

        {a, b} = find_swap(expression_names, correct_pin, real_pin)

        {values_acc |> swap_pins(a, b), MapSet.put(pins_acc, a) |> MapSet.put(b)}
      else
        {values_acc, pins_acc}
      end
    end)
    |> elem(1)
    |> Enum.filter(fn t -> t != nil and t != "z45" end)
    |> Enum.sort()
    |> Enum.join(",")
  end

  def find_swap(_, a, b) when is_binary(a) and is_binary(b) do
    if a == b do
      nil
    else
      {a, b}
    end
  end

  def find_swap(names, a, b) when is_binary(a) and not is_binary(b) do
    {a, Map.get(names, b)}
  end

  def find_swap(names, a, b) when not is_binary(a) and is_binary(b) do
    {Map.get(names, a), b}
  end

  def find_swap(names, a, b) do
    {a_op, a_lhs, a_rhs} = a
    {b_op, b_lhs, b_rhs} = b

    cond do
      a_op != b_op -> {Map.get(names, a), Map.get(names, b)}
      a_lhs == b_lhs -> find_swap(names, a_rhs, b_rhs)
      a_lhs == b_rhs -> find_swap(names, a_rhs, b_lhs)
      a_rhs == b_rhs -> find_swap(names, a_lhs, b_lhs)
      a_rhs == b_lhs -> find_swap(names, a_lhs, b_rhs)
    end
  end

  def determine_composition(_, expr) when is_binary(expr), do: expr

  def determine_composition(names, expr) do
    case Map.get(names, expr) do
      name when is_binary(name) ->
        name

      nil ->
        {op, lhs, rhs} = expr

        {op, determine_composition(names, lhs), determine_composition(names, rhs)}
        |> normalize_expr()
    end
  end

  def swap_pins(values, a, b) do
    a_old = Map.get(values, a)
    b_old = Map.get(values, b)

    values
    |> Map.put(b, a_old)
    |> Map.put(a, b_old)
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

  def build_expr(values, name) do
    case Map.get(values, name) do
      {op, lhs, rhs} ->
        {op, build_expr(values, lhs), build_expr(values, rhs)}
        |> normalize_expr()

      _ ->
        name
    end
    |> normalize_expr()
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
