defmodule Aoc24Test do
  use ExUnit.Case
  doctest Aoc24

  describe "Day 1" do
    test "part 1 example", %{test: test_name} do
      {:ok, contents} = File.read("./test/support/day1/example.txt")

      output =
        contents
        |> Aoc24.Day1.part1()
        |> print_out(test_name)

      assert output == 11
    end

    test "part 1 input", %{test: test_name} do
      {:ok, contents} = File.read("./test/support/day1/input.txt")

      output =
        contents
        |> Aoc24.Day1.part1()
        |> print_out(test_name)

      assert output == 1_834_060
    end

    test "part 2 example", %{test: test_name} do
      {:ok, contents} = File.read("./test/support/day1/example.txt")

      output =
        contents
        |> Aoc24.Day1.part2()
        |> print_out(test_name)

      assert output == 31
    end

    test "part 2 input", %{test: test_name} do
      {:ok, contents} = File.read("./test/support/day1/input.txt")

      output =
        contents
        |> Aoc24.Day1.part2()
        |> print_out(test_name)

      assert output == 21_607_792
    end
  end

  describe "Day 2" do
    test "part 1 example", %{test: test_name} do
      {:ok, contents} = File.read("./test/support/day2/example.txt")

      output =
        contents
        |> Aoc24.Day2.part1()
        |> print_out(test_name)

      assert output == 2
    end

    test "part 1 input", %{test: test_name} do
      {:ok, contents} = File.read("./test/support/day2/input.txt")

      output =
        contents
        |> Aoc24.Day2.part1()
        |> print_out(test_name)

      assert output == 224
    end

    test "part 2 example", %{test: test_name} do
      {:ok, contents} = File.read("./test/support/day2/example.txt")

      output =
        contents
        |> Aoc24.Day2.part2()
        |> print_out(test_name)

      assert output == 4
    end

    test "part 2 input", %{test: test_name} do
      {:ok, contents} = File.read("./test/support/day2/input.txt")

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
      {:ok, contents} = File.read("./test/support/day3/input.txt")

      output =
        contents
        |> Aoc24.Day3.part1()
        |> print_out(test_name)

      assert output == 180_233_229
    end

    test "day 3 part 2 example", %{test: test_name} do
      input = "xmul(2,4)&mul[3,7]!^don't()_mul(5,5)+mul(32,64](mul(11,8)undo()?mul(8,5))"

      output =
        input
        |> Aoc24.Day3.part2()
        |> print_out(test_name)

      assert output == 48
    end

    test "day 3 part 2 input", %{test: test_name} do
      {:ok, contents} = File.read("./test/support/day3/input.txt")

      output =
        contents
        |> Aoc24.Day3.part2()
        |> print_out(test_name)

      assert output == 95_411_583
    end

    test "valid ranges" do
      assert Aoc24.Day3.valid_ranges([0, 5], [4, 10]) == [{0, 4}, {5, 10}]
    end
  end

  describe "Day 4" do
    test "part 1 example", %{test: test_name} do
      {:ok, contents} = File.read("./test/support/day4/example.txt")

      output =
        contents
        |> Aoc24.Day4.part1()
        |> print_out(test_name)

      assert output == 18
    end

    test "part 1 input", %{test: test_name} do
      {:ok, contents} = File.read("./test/support/day4/input.txt")

      output =
        contents
        |> Aoc24.Day4.part1()
        |> print_out(test_name)

      assert output == 2644
    end

    test "part 2 example", %{test: test_name} do
      {:ok, contents} = File.read("./test/support/day4/example.txt")

      output =
        contents
        |> Aoc24.Day4.part2()
        |> print_out(test_name)

      assert output == 9
    end

    test "part 2 input", %{test: test_name} do
      {:ok, contents} = File.read("./test/support/day4/input.txt")

      output =
        contents
        |> Aoc24.Day4.part2()
        |> print_out(test_name)

      assert output == 1952
    end
  end

  describe "Day 5" do
    test "part 1 example", %{test: test_name} do
      {:ok, contents} = File.read("./test/support/day5/example.txt")

      output =
        contents
        |> Aoc24.Day5.part1()
        |> print_out(test_name)

      assert output == 143
    end

    test "part 1 input", %{test: test_name} do
      {:ok, contents} = File.read("./test/support/day5/input.txt")

      output =
        contents
        |> Aoc24.Day5.part1()
        |> print_out(test_name)

      assert output == 6267
    end

    test "part 2 example", %{test: test_name} do
      {:ok, contents} = File.read("./test/support/day5/example.txt")

      output =
        contents
        |> Aoc24.Day5.part2()
        |> print_out(test_name)

      assert output == 123
    end

    test "part 2 input", %{test: test_name} do
      {:ok, contents} = File.read("./test/support/day5/input.txt")

      output =
        contents
        |> Aoc24.Day5.part2()
        |> print_out(test_name)

      assert output == 5184
    end
  end

  describe "Day 6" do
    test "part 1 example", %{test: test_name} do
      {:ok, contents} = File.read("./test/support/day6/example.txt")

      output =
        contents
        |> Aoc24.Day6.part1()
        |> print_out(test_name)

      assert output == 41
    end

    test "part 1 input", %{test: test_name} do
      {:ok, contents} = File.read("./test/support/day6/input.txt")

      output =
        contents
        |> Aoc24.Day6.part1()
        |> print_out(test_name)

      assert output == 5516
    end

    test "part 2 example", %{test: test_name} do
      {:ok, contents} = File.read("./test/support/day6/example.txt")

      output =
        contents
        |> Aoc24.Day6.part2()
        |> print_out(test_name)

      assert output == 6
    end

    test "part 2 input", %{test: test_name} do
      {:ok, contents} = File.read("./test/support/day6/input.txt")

      output =
        contents
        |> Aoc24.Day6.part2()
        |> print_out(test_name)

      assert output == 2008
    end
  end

  describe "Day 7" do
    test "part 1 example", %{test: test_name} do
      {:ok, contents} = File.read("./test/support/day7/example.txt")

      output =
        contents
        |> Aoc24.Day7.part1()
        |> print_out(test_name)

      assert output == 3749
    end

    test "part 1 input", %{test: test_name} do
      {:ok, contents} = File.read("./test/support/day7/input.txt")

      output =
        contents
        |> Aoc24.Day7.part1()
        |> print_out(test_name)

      assert output == 2_314_935_962_622
    end

    test "part 2 example", %{test: test_name} do
      {:ok, contents} = File.read("./test/support/day7/example.txt")

      output =
        contents
        |> Aoc24.Day7.part2()
        |> print_out(test_name)

      assert output == 11387
    end

    test "part 2 input", %{test: test_name} do
      {:ok, contents} = File.read("./test/support/day7/input.txt")

      output =
        contents
        |> Aoc24.Day7.part2()
        |> print_out(test_name)

      assert output == 401_477_450_831_495
    end
  end

  describe "Day 8" do
    test "part 1 example", %{test: test_name} do
      {:ok, contents} = File.read("./test/support/day8/example.txt")

      output =
        contents
        |> Aoc24.Day8.part1()
        |> print_out(test_name)

      assert output == 14
    end

    test "part 1 input", %{test: test_name} do
      {:ok, contents} = File.read("./test/support/day8/input.txt")

      output =
        contents
        |> Aoc24.Day8.part1()
        |> print_out(test_name)

      assert output == 228
    end

    test "part 2 example", %{test: test_name} do
      {:ok, contents} = File.read("./test/support/day8/example.txt")

      output =
        contents
        |> Aoc24.Day8.part2()
        |> print_out(test_name)

      assert output == 34
    end

    test "part 2 input", %{test: test_name} do
      {:ok, contents} = File.read("./test/support/day8/input.txt")

      output =
        contents
        |> Aoc24.Day8.part2()
        |> print_out(test_name)

      assert output == 766
    end

    test "antnnae" do
      input = """
      T.........
      ...T......
      .T........
      ..........
      ..........
      ..........
      ..........
      ..........
      ..........
      ..........
      """

      assert Aoc24.Day8.part2(input) == 9
    end
  end

  describe "Day 9" do
    test "basic example" do
      assert Aoc24.Day9.part1("12345") == 60
    end

    test "part 1 example", %{test: test_name} do
      {:ok, contents} = File.read("./test/support/day9/example.txt")

      output =
        contents
        |> Aoc24.Day9.part1()
        |> print_out(test_name)

      assert output == 1928
    end

    @tag timeout: :infinity
    test "part 1 input", %{test: test_name} do
      {:ok, contents} = File.read("./test/support/day9/input.txt")

      output =
        contents
        |> Aoc24.Day9.part1()
        |> print_out(test_name)

      assert output == 6_211_348_208_140
    end

    test "part 2 example", %{test: test_name} do
      {:ok, contents} = File.read("./test/support/day9/example.txt")

      output =
        contents
        |> Aoc24.Day9.part2()
        |> print_out(test_name)

      assert output == 2858
    end

    @tag timeout: :infinity
    test "part 2 input", %{test: test_name} do
      {:ok, contents} = File.read("./test/support/day9/input.txt")

      output =
        contents
        |> Aoc24.Day9.part2()
        |> print_out(test_name)

      assert output == 6_239_783_302_560
    end
  end

  describe "Day 10" do
    test "simple" do
      input = """
      0123
      1234
      8765
      9876
      """

      assert Aoc24.Day10.part1(input) == 1
    end

    test "part 1 example", %{test: test_name} do
      {:ok, contents} = File.read("./test/support/day10/example.txt")

      output =
        contents
        |> Aoc24.Day10.part1()
        |> print_out(test_name)

      assert output == 36
    end

    test "part 1 input", %{test: test_name} do
      {:ok, contents} = File.read("./test/support/day10/input.txt")

      output =
        contents
        |> Aoc24.Day10.part1()
        |> print_out(test_name)

      assert output == 667
    end

    test "part 2 example", %{test: test_name} do
      {:ok, contents} = File.read("./test/support/day10/example.txt")

      output =
        contents
        |> Aoc24.Day10.part2()
        |> print_out(test_name)

      assert output == 81
    end

    test "part 2 input", %{test: test_name} do
      {:ok, contents} = File.read("./test/support/day10/input.txt")

      output =
        contents
        |> Aoc24.Day10.part2()
        |> print_out(test_name)

      assert output == 1344
    end
  end

  describe "Day 11" do
    test "basic" do
      assert Aoc24.Day11.blink([125, 17], 6) == [
               2_097_446_912,
               14168,
               4048,
               2,
               0,
               2,
               4,
               40,
               48,
               2024,
               40,
               48,
               80,
               96,
               2,
               8,
               6,
               7,
               6,
               0,
               3,
               2
             ]
    end

    test "part 1 example", %{test: test_name} do
      {:ok, contents} = File.read("./test/support/day11/example.txt")

      output =
        contents
        |> Aoc24.Day11.part1()
        |> print_out(test_name)

      assert output == 55312
    end

    test "part 1 input", %{test: test_name} do
      {:ok, contents} = File.read("./test/support/day11/input.txt")

      output =
        contents
        |> Aoc24.Day11.part1()
        |> print_out(test_name)

      assert output == 185_205
    end

    test "original example with memo" do
      {:ok, contents} = File.read("./test/support/day11/example.txt")

      stones = Aoc24.Day11.process_input(contents)
      output = Aoc24.Day11.do_blinks(stones, 25)

      assert output == 55312
    end

    @tag timeout: :infinity
    test "part 2 input", %{test: test_name} do
      {:ok, contents} = File.read("./test/support/day11/input.txt")

      output =
        contents
        |> Aoc24.Day11.part2()
        |> print_out(test_name)

      assert output == 221280540398419
    end
  end

  defp print_out(output, test) do
    IO.puts("#{Atom.to_string(test)}:\t#{Integer.to_string(output)}")
    output
  end
end
