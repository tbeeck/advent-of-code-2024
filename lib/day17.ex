defmodule Aoc24.Day17 do
  defmodule Vm do
    defmodule State do
      defstruct [:registers, :instructions, :pc, :output]
    end

    def sim(state) when state.pc >= tuple_size(state.instructions) do
      state
    end

    def sim(state) do
      instr = elem(state.instructions, state.pc)

      next =
        case instr do
          0 -> adv(state)
          1 -> bxl(state)
          2 -> bst(state)
          3 -> jnz(state)
          4 -> bxc(state)
          5 -> out(state)
          6 -> bdv(state)
          7 -> cdv(state)
        end

      sim(next)
    end

    def adv(state) do
      numerator = Map.fetch!(state.registers, "A")
      denomenator = Integer.pow(2, get_combo_op(state))
      new_registers = Map.put(state.registers, "A", Integer.floor_div(numerator, denomenator))

      %State{
        state
        | registers: new_registers,
          pc: state.pc + 2
      }
    end

    def bxl(state) do
      result = Bitwise.bxor(Map.fetch!(state.registers, "B"), get_literal_op(state))
      new_registers = Map.put(state.registers, "B", result)

      %State{
        state
        | registers: new_registers,
          pc: state.pc + 2
      }
    end

    def bst(state) do
      result = Integer.mod(get_combo_op(state), 8)
      new_registers = Map.put(state.registers, "B", result)

      %State{
        state
        | registers: new_registers,
          pc: state.pc + 2
      }
    end

    def jnz(state) do
      new_pc =
        if Map.fetch!(state.registers, "A") != 0 do
          get_literal_op(state)
        else
          state.pc + 2
        end

      %State{
        state
        | pc: new_pc
      }
    end

    def bxc(state) do
      result = Bitwise.bxor(Map.fetch!(state.registers, "B"), Map.fetch!(state.registers, "C"))
      new_registers = Map.put(state.registers, "B", result)

      %State{
        state
        | registers: new_registers,
          pc: state.pc + 2
      }
    end

    def out(state) do
      val = Integer.mod(get_combo_op(state), 8)

      %State{
        state
        | output: state.output ++ [val],
          pc: state.pc + 2
      }
    end

    def bdv(state) do
      numerator = Map.fetch!(state.registers, "A")
      denomenator = Integer.pow(2, get_combo_op(state))
      new_registers = Map.put(state.registers, "B", Integer.floor_div(numerator, denomenator))

      %State{
        state
        | registers: new_registers,
          pc: state.pc + 2
      }
    end

    def cdv(state) do
      numerator = Map.fetch!(state.registers, "A")
      denomenator = Integer.pow(2, get_combo_op(state))
      new_registers = Map.put(state.registers, "C", Integer.floor_div(numerator, denomenator))

      %State{
        state
        | registers: new_registers,
          pc: state.pc + 2
      }
    end

    def get_combo_op(state) do
      combo_val(state, elem(state.instructions, state.pc + 1))
    end

    def get_literal_op(state) do
      elem(state.instructions, state.pc + 1)
    end

    def combo_val(state, val) do
      case val do
        0 -> 0
        1 -> 1
        2 -> 2
        3 -> 3
        4 -> Map.fetch!(state.registers, "A")
        5 -> Map.fetch!(state.registers, "B")
        6 -> Map.fetch!(state.registers, "C")
      end
    end
  end

  def part1(input) do
    {registers, instructions} =
      parse_input(input)

    state =
      %Vm.State{registers: registers, instructions: instructions, pc: 0, output: []}
      |> Vm.sim()

    Enum.join(state.output, ",")
  end

  def part2(input) do
    {_, instructions} =
      parse_input(input)

    l = Tuple.to_list(instructions)

    find(l, make_sim(instructions))
    |> Enum.min()
  end

  def make_sim(instructions) do
    f = fn a ->
      result =
        %Vm.State{
          registers: %{"A" => a, "B" => 0, "C" => 0},
          instructions: instructions,
          pc: 0,
          output: []
        }
        |> Vm.sim()

      result.output
    end

    f
  end

  def result_of(a, instructions) do
    instructions = List.to_tuple(instructions)

    result =
      %Vm.State{
        registers: %{"A" => a, "B" => 0, "C" => 0},
        instructions: instructions,
        pc: 0,
        output: []
      }
      |> Vm.sim()

    result.output
  end

  def find(instructions, simulator) when length(instructions) == 1 do
    matches_in_range(1..7, instructions, simulator)
  end

  def find(instructions, simulator) do
    [_ | rest] = instructions
    matches = find(rest, simulator)
    len = length(instructions)

    Enum.reduce(matches, [], fn match, acc ->
      next_range_start = 8 * (match - length_start_offset(len - 1)) + length_start_offset(len)

      matches_in_range(next_range_start..(next_range_start + 8), instructions, simulator) ++
        acc
    end)
  end

  def length_start_offset(n) when n <= 0 do
    1
  end

  def length_start_offset(n) do
    Integer.pow(8, n)
  end

  def matches_in_range(range, instructions, simulator) do
    Enum.reduce(range, [], fn n, acc ->
      r = simulator.(n)

      if common_end(r, instructions) do
        [n] ++ acc
      else
        acc
      end
    end)
  end

  def parse_input(input) do
    [first, second] = String.split(input, "\n\n")
    a_pat = ~r"Register A: (\d+)\nRegister B: (\d+)\nRegister C: (\d+)"
    b_pat = ~r"Program: (.*)$"
    [_ | regs] = List.first(Regex.scan(a_pat, first))
    [_ | instrs] = List.first(Regex.scan(b_pat, second))
    [a, b, c] = Enum.map(regs, &parseint/1)

    instrs =
      List.first(instrs)
      |> String.split(",")
      |> Enum.map(&parseint/1)
      |> List.to_tuple()

    {%{"A" => a, "B" => b, "C" => c}, instrs}
  end

  def parseint(s) do
    elem(Integer.parse(s), 0)
  end

  def common_start(_, []) do
    true
  end

  def common_start([], _) do
    true
  end

  def common_start(l, r) do
    [a | l_rest] = l
    [b | r_rest] = r

    if a == b do
      common_start(l_rest, r_rest)
    else
      false
    end
  end

  def common_end(l, r), do: common_start(Enum.reverse(l), Enum.reverse(r))
end
