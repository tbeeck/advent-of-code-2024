defmodule Aoc24.Day9 do
  def part1(input) do
    process_input(input)
    |> compact()
    |> checksum()
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
          rest = Enum.slice(rest, 0..(last_i - 1))
          [file | compact(rest)]
        else
          []
        end
    end
  end

  def part2(input) do
    process_input_p2(input)
    |> compact_p2()
    |> expand()
    |> checksum()
  end

  def compact_p2([]), do: []
  def compact_p2([t]), do: [t]

  def compact_p2(blocks) do
    [first | rest] = blocks

    case first do
      {:file, _, _} ->
        [first | compact_p2(rest)]

      {:free, size} ->
        last_i = find_fitting_file(rest, size)

        if last_i != -1 do
          {:file, f_size, id} = Enum.at(rest, last_i)
          rest = List.replace_at(rest, last_i, {:free, f_size})

          if f_size < size do
            [{:file, f_size, id}] ++ compact_p2([{:free, size - f_size}] ++ rest)
          else
            [{:file, f_size, id}] ++ [compact_p2(rest)]
          end
        else
          [first | compact_p2(rest)]
        end
    end
  end

  def find_fitting_file(blocks, size) do
    idx =
      blocks
      |> Enum.reverse()
      |> Enum.find_index(fn
        {:file, f_size, _} -> f_size <= size
        {:free, _} -> false
      end)

    if idx != nil do
      length(blocks) - idx - 1
    else
      -1
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
        List.duplicate({:file, Integer.floor_div(idx, 2)}, size)
      else
        List.duplicate({:free}, size)
      end
    end)
  end

  def process_input_p2(input) do
    input
    |> String.graphemes()
    |> Enum.map(fn char ->
      {int, _} = Integer.parse(char)
      int
    end)
    |> Enum.with_index()
    |> Enum.map(fn {size, idx} ->
      if Integer.mod(idx, 2) == 0 do
        {:file, size, Integer.floor_div(idx, 2)}
      else
        {:free, size}
      end
    end)
  end

  def expand([]), do: []

  def expand(t) when is_tuple(t) do
    case t do
      {:file, size, id} -> List.duplicate({:file, id}, size)
      {:free, size} -> List.duplicate({:free}, size)
    end
  end

  def expand(blocks) do
    [first | rest] = blocks
    cur = expand(first)
    cur ++ expand(rest)
  end
end
