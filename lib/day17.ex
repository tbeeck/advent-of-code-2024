defmodule Aoc24.Day17 do
  defmodule State do
    defstruct [:registers, :instructions, :pc, :output]
  end

  def part1(input) do
    {registers, instructions} =
      parse_input(input)

    state =
      %State{registers: registers, instructions: instructions, pc: 0, output: []}
      |> sim()

    Enum.join(state.output, ",")
  end

  def part2(input) do
    ""
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
end
