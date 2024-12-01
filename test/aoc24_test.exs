defmodule Aoc24Test do
  use ExUnit.Case
  doctest Aoc24

  describe "Day 1" do
    test "example input" do
      {:ok, contents} = File.read("./test/support/day1/example.txt")

      output =
        contents
        |> Aoc24.Day1.day1()
      IO.inspect(output)
      assert output == 11
    end

    test "round 1 input" do
      {:ok, contents} = File.read("./test/support/day1/input.txt")

      output =
        contents
        |> Aoc24.Day1.day1()
      IO.inspect(output)
      assert output == nil
    end
  end
end
