defmodule Aoc24.Day22 do
  def part1(input) do
    starts =
      process_input(input)

    Enum.map(starts, fn n -> nth_secret(n, 2000) end)
    |> Enum.sum()
  end

  def part2(input) do
    0
  end

  def next_n_secrets(_, n) when n == 0, do: []

  def next_n_secrets(num, n) do
    next = next_secret(num)
    [next] ++ next_n_secrets(next, n - 1)
  end

  def nth_secret(num, n) when n == 0, do: num

  def nth_secret(num, n) do
    next_secret(num)
    |> nth_secret(n - 1)
  end

  def next_secret(num) do
    a =
      (num * 64)
      |> mix(num)
      |> prune()

    # b
    b =
      Integer.floor_div(a, 32)
      |> mix(a)
      |> prune()

    # c
    (b * 2048)
    |> mix(b)
    |> prune()
  end

  def mix(a, b) do
    Bitwise.bxor(a, b)
  end

  def prune(a) do
    Integer.mod(a, 16_777_216)
  end

  def process_input(input) do
    input
    |> String.split()
    |> Enum.map(&String.to_integer/1)
  end
end
