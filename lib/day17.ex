defmodule Aoc24.Day17 do
  defmodule State do
    defstruct [:registers, :instructions, :pc, :output]
  end

  def part1(input) do
    {registers, instructions} =
      parse_input(input)

    state =
      %State{registers: registers, instructions: instructions, pc: 0, output: []}
      |> IO.inspect()

    ""
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
    state
  end

  def bxl(state) do
    state
  end

  def bst(state) do
    state
  end

  def jnz(state) do
    state
  end

  def bxc(state) do
    state
  end

  def out(state) do
    state
  end

  def bdv(state) do
    state
  end

  def cdv(state) do
    state
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
