defmodule Aoc24Test do
  use ExUnit.Case
  doctest Aoc24

  describe "Day 1" do
    test "part 1 example" do
      {:ok, contents} = File.read("./test/support/day1/example_part1.txt")

      output =
        contents
        |> Aoc24.Day1.part1()

      IO.inspect(output)
      assert output == 11
    end

    test "part 1 input" do
      {:ok, contents} = File.read("./test/support/day1/input_part1.txt")

      output =
        contents
        |> Aoc24.Day1.part1()

      IO.inspect(output)
      assert output == 1_834_060
    end

    test "part 2 example" do
      {:ok, contents} = File.read("./test/support/day1/example_part2.txt")

      output =
        contents
        |> Aoc24.Day1.part2()

      IO.inspect(output)
      assert output == 31
    end

    test "part 2 input" do
      {:ok, contents} = File.read("./test/support/day1/input_part2.txt")

      output =
        contents
        |> Aoc24.Day1.part2()

      IO.inspect(output)
      assert output == 21607792
    end
  end
end
