defmodule Aoc24.Day18 do
  alias Aoc24.Util

  def part1(input, opts \\ []) do
    count = Keyword.get(opts, :count, 1024)
    # Inclusive
    width = Keyword.get(opts, :width, 70)
    height = Keyword.get(opts, :height, 70)

    walls =
      input
      |> process_input()
      |> Enum.slice(0..(count - 1))

    graph =
      grid_graph(walls, {width, height})
      |> IO.inspect()

    Util.Graph.dijkstras({0, 0}, graph)
    |> Map.get({width, height}, :infinity)
  end

  def grid_graph(walls, {width, height}) do
    navigable =
      for x <- 0..width,
          y <- 0..height,
          {x, y} not in walls,
          do: {x, y}

    navigable
    |> Enum.map(fn pair ->
      neighbors =
        Util.neighbors_of(pair)
        |> Enum.filter(fn n ->
          Util.in_bounds?(n, {width + 1, height + 1}) and n not in walls
        end)
        |> Enum.map(fn n -> {n, 1} end)

      {pair, neighbors}
    end)
    |> Enum.reduce(Map.new(), fn {pair, neighbors}, acc -> Map.put(acc, pair, neighbors) end)
  end

  def process_input(input) do
    input
    |> String.split()
    |> Enum.map(fn s ->
      String.split(s, ",")
      |> Enum.map(&Util.parseint/1)
      |> List.to_tuple()
    end)
  end
end
