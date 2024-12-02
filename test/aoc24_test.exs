defmodule Aoc24Test do
  use ExUnit.Case
  doctest Aoc24

  describe "Day 1" do
    test "part 1 example", %{test: test_name} do
      {:ok, contents} = File.read("./test/support/day1/example_part1.txt")

      output =
        contents
        |> Aoc24.Day1.part1()
        |> print_out(test_name)

      assert output == 11
    end

    test "part 1 input", %{test: test_name} do
      {:ok, contents} = File.read("./test/support/day1/input_part1.txt")

      output =
        contents
        |> Aoc24.Day1.part1()
        |> print_out(test_name)

      assert output == 1_834_060
    end

    test "part 2 example", %{test: test_name} do
      {:ok, contents} = File.read("./test/support/day1/example_part2.txt")

      output =
        contents
        |> Aoc24.Day1.part2()
        |> print_out(test_name)

      assert output == 31
    end

    test "part 2 input", %{test: test_name} do
      {:ok, contents} = File.read("./test/support/day1/input_part2.txt")

      output =
        contents
        |> Aoc24.Day1.part2()
        |> print_out(test_name)

      assert output == 21_607_792
    end
  end

  describe "Day 2" do
    test "part 1 example", %{test: test_name} do
      {:ok, contents} = File.read("./test/support/day2/example_part1.txt")

      output =
        contents
        |> Aoc24.Day2.part1()
        |> print_out(test_name)

      assert output == 2
    end

    test "part 1 input", %{test: test_name} do
      {:ok, contents} = File.read("./test/support/day2/input_part1.txt")

      output =
        contents
        |> Aoc24.Day2.part1()
        |> print_out(test_name)

      assert output == nil
    end
  end

  defp print_out(output, test) do
    IO.puts("#{Atom.to_string(test)}:\t#{Integer.to_string(output)}")
    output
  end

end
