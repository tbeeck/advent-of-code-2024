defmodule Aoc24.Day8 do
  def part1(input) do
    grid = process_input(input)
    nodes = node_map(grid) |> IO.inspect()
    coord_map = antinode_coords(nodes, grid)

    coord_map
    |> Enum.flat_map(fn {_, v} -> v end)
    |> Enum.sort()
    |> Enum.dedup()
    |> IO.inspect()
    |> length()
  end

  def part2(input) do
    0
  end

  def in_bounds({y, x}, grid) do
    height = length(grid)
    width = length(List.first(grid))
    0 <= y and y < height and 0 <= x and x < width
  end

  def antinode_coords(antinode_map, grid) do
    make_pairs = fn l ->
      for i <- 0..(length(l) - 1), j <- (i + 1)..(length(l) - 1) do
        if j < length(l) and i != j do
          {Enum.at(l, i), Enum.at(l, j)}
        end
      end
      |> Enum.filter(fn e -> e != nil end)
    end

    Enum.reduce(antinode_map, Map.new(), fn {char, nodes}, acc ->
      Map.put(
        acc,
        char,
        make_pairs.(nodes)
        |> Enum.flat_map(fn {t1, t2} -> antinodes_for(t1, t2) end)
        |> Enum.sort()
        |> Enum.dedup()
        |> Enum.filter(fn pair -> in_bounds(pair, grid) end)
        |> IO.inspect()
        |> Enum.filter(fn pair -> not Enum.member?(nodes, pair) end)
        |> IO.inspect()
      )
    end)
  end

  def antinodes_for({y1, x1}, {y2, x2}) do
    {dy, dx} = {y2 - y1, x2 - x1}
    [{y2 + dy, x2 + dx}, {y1 - dy, x1 - dx}]
  end

  def node_map(grid) do
    height = length(grid)
    width = length(List.first(grid))

    for i <- 0..(height - 1), j <- 0..(width - 1) do
      {i, j, Enum.at(Enum.at(grid, i), j)}
    end
    |> Enum.reduce(Map.new(), fn {row, col, char}, acc ->
      if char != "." do
        new_list = List.insert_at(Map.get(acc, char, []), 0, {row, col})
        Map.put(acc, char, new_list)
      else
        acc
      end
    end)
  end

  def process_input(input) do
    input
    |> String.split()
    |> Enum.map(fn line -> String.graphemes(line) end)
  end
end
