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

      assert output == 224
    end

    test "part 2 example", %{test: test_name} do
      {:ok, contents} = File.read("./test/support/day2/example_part1.txt")

      output =
        contents
        |> Aoc24.Day2.part2()
        |> print_out(test_name)

      assert output == 4
    end

    test "part 2 input", %{test: test_name} do
      {:ok, contents} = File.read("./test/support/day2/input_part1.txt")

      output =
        contents
        |> Aoc24.Day2.part2()
        |> print_out(test_name)

      assert output == 293
    end

    test "all inc or dec" do
      assert Aoc24.Day2.all_inc_or_dec([1, 2, 3, 4, 5])
      assert Aoc24.Day2.all_inc_or_dec([5, 4, 3, 2, 1])
      assert Aoc24.Day2.all_inc_or_dec([5, 4, 3, 2, 0])
      assert Aoc24.Day2.all_inc_or_dec([1])
      refute Aoc24.Day2.all_inc_or_dec([1, 10, 11, 12, 11])
    end

    test "differences ok" do
      assert Aoc24.Day2.differences_ok([1, 2, 3, 4, 5])
      assert Aoc24.Day2.differences_ok([1, 2, 3, 4, 6])
      assert Aoc24.Day2.differences_ok([1, 2, 3, 4, 7])
      assert Aoc24.Day2.differences_ok([1])
      refute Aoc24.Day2.differences_ok([1, 2, 3, 4, 8])
      refute Aoc24.Day2.differences_ok([1, 10, 11, 12])
    end

    test "differences ok with removal" do
      assert Aoc24.Day2.ok_with_deletes([1, 2, 3, 4, 5])
      assert Aoc24.Day2.ok_with_deletes([1, 2, 3, 4, 6])
      assert Aoc24.Day2.ok_with_deletes([1, 2, 3, 4, 7])
      assert Aoc24.Day2.ok_with_deletes([1])
      assert Aoc24.Day2.ok_with_deletes([1, 2, 3, 4, 8])
      assert Aoc24.Day2.ok_with_deletes([1, 10, 11, 12])
      refute Aoc24.Day2.ok_with_deletes([1, 10, 11, 12, 20])
      refute Aoc24.Day2.ok_with_deletes([1, 2, 7, 8, 9])
      refute Aoc24.Day2.ok_with_deletes([9, 7, 6, 2, 1])
    end
  end

  describe "Day 3" do
    test "day 3 part 1 example", %{test: test_name} do
      input = "xmul(2,4)%&mul[3,7]!@^do_not_mul(5,5)+mul(32,64]then(mul(11,8)mul(8,5))"

      output =
        input
        |> Aoc24.Day3.part1()
        |> print_out(test_name)

      assert output == 161
    end

    test "day 3 part 1 input", %{test: test_name} do
      {:ok, contents} = File.read("./test/support/day3/input_part1.txt")

      output =
        contents
        |> Aoc24.Day3.part1()
        |> print_out(test_name)

      assert output == 180_233_229
    end

    test "day 3 part 2 example", %{test: test_name} do
      input = "xmul(2,4)%&mul[3,7]!@^do_not_mul(5,5)+mul(32,64]then(mul(11,8)mul(8,5))"

      output =
        input
        |> Aoc24.Day3.part2()
        |> print_out(test_name)

      assert output == 48
    end

    test "day 3 part 2 input", %{test: test_name} do
      {:ok, contents} = File.read("./test/support/day3/input_part1.txt")

      output =
        contents
        |> Aoc24.Day3.part2()
        |> print_out(test_name)

      assert output == nil
    end
  end

  defp print_out(output, test) do
    IO.puts("#{Atom.to_string(test)}:\t#{Integer.to_string(output)}")
    output
  end
end
