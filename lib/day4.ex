defmodule Aoc24.Day4 do
  def directions() do
    [
      {0, 1},
      {1, 0},
      {0, -1},
      {-1, 0},
      {1, 1},
      {1, -1},
      {-1, 1},
      {-1, -1}
    ]
  end

  def part1(input) when is_binary(input) do
    build_wordsearch(input)
    |> unique_finds("XMAS")
    |> Map.keys()
    |> length()
  end

  def part2(input) when is_binary(input) do
    build_wordsearch(input)
    |> unique_x_finds("MAS")
    |> Map.keys()
    |> length()
  end

  def unique_x_finds(wordsearch, word) do
    height = length(wordsearch)
    width = length(Enum.at(wordsearch, 0))

    for x <- 0..(width - 1), y <- 0..(height - 1) do
      if found_x_word?(wordsearch, x, y, word) do
        {x, y}
      end
    end
    |> Enum.filter(fn t -> not is_nil(t) end)
    |> Map.new(fn
      {x, y} -> {{x, y}, word}
    end)
  end

  def found_x_word?(wordsearch, x, y, word) do
    topleft_start = found_word?(wordsearch, x-1, y-1, 1, 1, word)
    topright_start = found_word?(wordsearch, x+1, y-1, -1, 1, word)
    bottomleft_start = found_word?(wordsearch, x-1, y+1, 1, -1, word)
    bottomright_start = found_word?(wordsearch, x+1, y+1, -1, -1, word)
    (topleft_start and bottomleft_start) or
    (topright_start and bottomright_start) or
    (bottomleft_start and bottomright_start) or
    (topleft_start and topright_start)
  end

  def unique_finds(wordsearch, word) do
    height = length(wordsearch)
    width = length(Enum.at(wordsearch, 0))

    for x <- 0..(width - 1), y <- 0..(height - 1), {dx, dy} <- directions() do
      if found_word?(wordsearch, x, y, dx, dy, word) do
        {x, y, dx, dy}
      end
    end
    |> Enum.filter(fn t -> not is_nil(t) end)
    |> Map.new(fn
      {x, y, dx, dy} -> {{x, y, dx, dy}, word}
    end)
  end

  def found_word?(wordsearch, x, y, dx, dy, word) do
    Enum.with_index(String.graphemes(word))
    |> Enum.all?(fn {char, index} ->
      nx = x + index * dx
      ny = y + index * dy

      if nx < 0 or nx >= length(wordsearch) or ny < 0 or ny >= length(Enum.at(wordsearch, 0)) do
        false
      else
        Enum.at(Enum.at(wordsearch, nx), ny) == char
      end
    end)
  end

  def build_wordsearch(input) when is_binary(input) do
    input
    |> String.split("\n")
    |> Enum.map(&String.trim/1)
    |> Enum.map(&String.graphemes/1)
  end
end
