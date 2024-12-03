defmodule Aoc24.Day2 do
  def part1(input) do
    split_reports(input)
    |> Enum.map(fn r -> check_report(r) end)
    |> Enum.frequencies()
    |> Map.get(true, 0)
  end

  defp check_report(report) do
    length(report) > 0 and
      all_inc_or_dec(report) and
      differences_ok(report)
  end

  def differences_ok(report) do
    report
    |> Enum.chunk_every(2, 1)
    |> Enum.map(fn l ->
      if length(l) == 1 do
        true
      else
        [a, b] = l
        abs(a - b) <= 3
      end
    end)
    |> Enum.all?()
  end

  def all_inc_or_dec(report) do
    inc =
      report
      |> Enum.chunk_every(2, 1)
      |> Enum.map(fn l ->
        if length(l) == 1 do
          true
        else
          [a, b] = l
          a < b
        end
      end)
      |> Enum.all?()

    dec =
      report
      |> Enum.chunk_every(2, 1)
      |> Enum.map(fn l ->
        if length(l) == 1 do
          true
        else
          [a, b] = l
          a > b
        end
      end)
      |> Enum.all?()

    inc or dec
  end

  defp split_reports(input) do
    input
    |> String.split("\n")
    |> Enum.map(fn s -> String.split(s) end)
    |> Enum.map(fn nums ->
      Enum.map(nums, fn num ->
        {val, _} = Integer.parse(num)
        val
      end)
    end)
  end
end
