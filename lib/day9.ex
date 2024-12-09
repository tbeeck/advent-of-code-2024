defmodule Aoc24.Day9 do
  def part1(input) do
    process_input(input)
    |> compact()
    |> IO.inspect(limit: :infinity)
    |> checksum()
  end

  def part2(_) do
    0
  end

  def compact([]), do: []
  def compact([t]), do: [t]

  def compact(blocks) do
    [first | rest] = blocks

    case first do
      {:file, _} ->
        [first | compact(rest)]

      {:free} ->
        last_i = find_last_file(rest)

        if last_i != -1 do
          file = Enum.at(rest, last_i)
          rest = Enum.slice(rest, 0..last_i-1)
          [file | compact(rest)]
        else
          []
        end
    end
  end

  def checksum(blocks) do
    blocks
    |> Enum.with_index()
    |> Enum.map(fn {elem, idx} ->
      case elem do
        {:file, id} -> id * idx
        _ -> 0
      end
    end)
    |> Enum.sum()
  end

  def find_last_file(blocks) do
    idx =
      blocks
      |> Enum.reverse()
      |> Enum.find_index(fn t ->
        elem(t, 0) == :file
      end)

    if idx != nil do
      length(blocks) - idx - 1
    else
      -1
    end
  end

  def process_input(input) do
    input
    |> String.graphemes()
    |> Enum.map(fn char ->
      {int, _} = Integer.parse(char)
      int
    end)
    |> Enum.with_index()
    |> Enum.flat_map(fn {size, idx} ->
      if Integer.mod(idx, 2) == 0 do
        for _ <- 1..size do
          {:file, Integer.floor_div(idx, 2)}
        end
      else
        for _ <- 1..size do
          {:free}
        end
      end
    end)
  end
end
