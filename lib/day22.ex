defmodule Aoc24.Day22 do
  def part1(input) do
    starts = process_input(input)

    Enum.map(starts, fn n -> nth_secret(n, 2000) end)
    |> Enum.sum()
  end

  def part2(input) do
    starts = process_input(input)

    buyer_seqs =
      Enum.map(starts, fn start ->
        seqs =
          price_changes(start, 1999)
          |> Enum.chunk_every(4, 1, :discard)
          |> Enum.reduce(MapSet.new(), fn seq, acc ->
            MapSet.put(acc, seq)
          end)

        {start, seqs}
      end)

    all_seqs =
      Enum.reduce(buyer_seqs, Map.new(), fn {buyer, seqs}, acc ->
        IO.puts("Buyer seqs: #{buyer}, #{MapSet.size(seqs)}")

        cur =
          Enum.reduce(seqs, Map.new(), fn seq, inner_acc ->
            old_value = Map.get(inner_acc, seq, 0)
            raw_seq = Enum.map(seq, &elem(&1, 0))
            Map.put(inner_acc, raw_seq, max(old_value, List.last(seq) |> elem(1)))
          end)

        Map.merge(acc, cur, fn _, v1, v2 ->
          v1 + v2
        end)
      end)
      |> IO.inspect()

    all_seqs
    |> Enum.max_by(fn {k, v} -> v end)
    |> elem(1)
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

  def price_changes(_, n) when n == 0, do: []

  def price_changes(num, n) do
    next = next_secret(num)
    delta = Integer.mod(next, 10) - Integer.mod(num, 10)
    [{delta, Integer.mod(next, 10)}] ++ price_changes(next, n - 1)
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
