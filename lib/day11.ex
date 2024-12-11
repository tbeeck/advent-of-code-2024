defmodule Aoc24.Day11 do
  alias Aoc24.Day11.EtsCache
  def part1(input) do
    stones =
      process_input(input)

    blink(stones, 25)
    |> length()
  end

  def blink(stones, 0) when is_list(stones), do: stones

  def blink(stones, times) when is_list(stones) and is_integer(times) do
    result = Enum.flat_map(stones, fn stone -> blink(stone) end)
    blink(result, times - 1)
  end

  @spec blink(integer()) :: list()
  def blink(stone) when is_integer(stone) do
    if stone == 0 do
      [1]
    else
      if even_digits?(stone) do
        split_digits(stone)
      else
        [stone * 2024]
      end
    end
  end

  def part2(input) do
    Aoc24.Day11.EtsCache.start_link()
    stones =
      process_input(input)

    stones
    |> Enum.map(fn stone -> EtsCache.get_count({stone, 75}) end)
    |> Enum.sum()
  end

  @spec blink_count(integer(), integer(), map()) :: {integer(), map()}
  def blink_count(_, 0, memo) do
    {1, memo}
  end

  @spec blink_count(integer(), integer(), map()) :: {integer(), map()}
  def blink_count(stone, 1, memo) do
    if stone == 0 do
      {1, Map.put(memo, {stone, 1}, 1)}
    else
      if even_digits?(stone) do
        {2, Map.put(memo, {stone, 1}, 2)}
      else
        {1, Map.put(memo, {stone, 1}, 1)}
      end
    end
  end

  @spec blink_count(integer(), integer(), map()) :: {integer(), map()}
  def blink_count(stone, times, memo) do
    if {stone, times} in memo do
      {Map.get(memo, {stone, times}), memo}
    else
      {total, memo} =
        blink(stone)
        |> Enum.reduce({0, memo}, fn new_stone, {acc_count, acc_memo} ->
          {count, acc_memo} = blink_count(new_stone, times - 1, acc_memo)
          {acc_count + count, acc_memo}
        end)

      {total, Map.put(memo, {stone, times}, total)}
    end
  end

  def even_digits?(num) do
    Integer.mod(String.length(Integer.to_string(num)), 2) == 0
  end

  def split_digits(num) do
    s = Integer.to_string(num)
    half = Integer.floor_div(String.length(s), 2)

    String.split_at(s, half)
    |> Tuple.to_list()
    |> Enum.map(fn s ->
      elem(Integer.parse(s), 0)
    end)
  end

  def process_input(input) do
    input
    |> String.split()
    |> Enum.map(fn s -> elem(Integer.parse(s), 0) end)
  end

  defmodule EtsCache do
    def start_link do
      :ets.new(:memo_table, [:named_table, :public, :set])
    end

    def get_count(arg) do
      case :ets.lookup(:memo_table, arg) do
        [{^arg, result}] ->
          result

        [] ->
          {stone, times} = arg
          result = cached_blink_count(stone, times)
          :ets.insert(:memo_table, {arg, result})
          result
      end
    end

    @spec cached_blink_count(integer(), integer()) :: integer()
    def cached_blink_count(_, 0) do
      1
    end

    @spec cached_blink_count(integer(), integer()) :: integer()
    def cached_blink_count(stone, 1) do
      if stone == 0 do
        1
      else
        if Aoc24.Day11.even_digits?(stone) do
          2
        else
          1
        end
      end
    end

    @spec cached_blink_count(integer(), integer()) :: integer()
    def cached_blink_count(stone, times) do
      total =
        Aoc24.Day11.blink(stone)
        |> Enum.reduce(0, fn new_stone, acc_count ->
          count = get_count({new_stone, times - 1})
          acc_count + count
        end)

      :ets.insert(:memo_table, {{stone, times}, total})
      total
    end
  end
end
