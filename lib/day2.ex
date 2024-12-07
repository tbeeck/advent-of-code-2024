defmodule Aoc24.Day2 do
  def part1(input) do
    split_reports(input)
    |> Enum.map(fn r -> check_report(r) end)
    |> Enum.frequencies()
    |> Map.get(true, 0)
  end

  def part2(input) do
    split_reports(input)
    |> Enum.map(fn r -> check_report_2(r) end)
    |> Enum.frequencies()
    |> Map.get(true, 0)
  end

  defp check_report(report) do
    length(report) > 0 and
      all_inc_or_dec(report) and
      differences_ok(report)
  end

  defp check_report_2(report) do
    length(report) > 0 and
      ok_with_deletes(report)
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

  def ok_with_deletes(report) do
    ok =
      Enum.map(0..(length(report) - 1), fn i ->
        List.delete_at(report, i)
      end)
      |> Enum.any?(fn new_report -> differences_ok(new_report) and all_inc_or_dec(new_report) end)

    (all_inc_or_dec(report) and differences_ok(report)) or ok
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
