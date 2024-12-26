defmodule Aoc24Test do
  use ExUnit.Case
  doctest Aoc24

  describe "Day 1" do
    test "part 1 example", %{test: test_name} do
      output = do_test(test_name, "day1/example.txt", &Aoc24.Day1.part1/1)
      assert output == 11
    end

    test "part 1 input", %{test: test_name} do
      output = do_test(test_name, "day1/input.txt", &Aoc24.Day1.part1/1)
      assert output == 1_834_060
    end

    test "part 2 example", %{test: test_name} do
      output = do_test(test_name, "day1/example.txt", &Aoc24.Day1.part2/1)
      assert output == 31
    end

    test "part 2 input", %{test: test_name} do
      output = do_test(test_name, "day1/input.txt", &Aoc24.Day1.part2/1)
      assert output == 21_607_792
    end
  end

  describe "Day 2" do
    test "part 1 example", %{test: test_name} do
      output = do_test(test_name, "day2/example.txt", &Aoc24.Day2.part1/1)
      assert output == 2
    end

    test "part 1 input", %{test: test_name} do
      output = do_test(test_name, "day2/input.txt", &Aoc24.Day2.part1/1)
      assert output == 224
    end

    test "part 2 example", %{test: test_name} do
      output = do_test(test_name, "day2/example.txt", &Aoc24.Day2.part2/1)
      assert output == 4
    end

    test "part 2 input", %{test: test_name} do
      output = do_test(test_name, "day2/input.txt", &Aoc24.Day2.part2/1)
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
      output = do_test(test_name, "day3/example.txt", &Aoc24.Day3.part1/1)
      assert output == 161
    end

    test "day 3 part 1 input", %{test: test_name} do
      output = do_test(test_name, "day3/input.txt", &Aoc24.Day3.part1/1)
      assert output == 180_233_229
    end

    test "day 3 part 2 example", %{test: test_name} do
      output = do_test(test_name, "day3/example.txt", &Aoc24.Day3.part2/1)
      assert output == 48
    end

    test "day 3 part 2 input", %{test: test_name} do
      output = do_test(test_name, "day3/input.txt", &Aoc24.Day3.part2/1)
      assert output == 95_411_583
    end

    test "valid ranges" do
      assert Aoc24.Day3.valid_ranges([0, 5], [4, 10]) == [{0, 4}, {5, 10}]
    end
  end

  describe "Day 4" do
    test "part 1 example", %{test: test_name} do
      output = do_test(test_name, "day4/example.txt", &Aoc24.Day4.part1/1)
      assert output == 18
    end

    test "part 1 input", %{test: test_name} do
      output = do_test(test_name, "day4/input.txt", &Aoc24.Day4.part1/1)
      assert output == 2644
    end

    test "part 2 example", %{test: test_name} do
      output = do_test(test_name, "day4/example.txt", &Aoc24.Day4.part2/1)
      assert output == 9
    end

    test "part 2 input", %{test: test_name} do
      output = do_test(test_name, "day4/input.txt", &Aoc24.Day4.part2/1)
      assert output == 1952
    end
  end

  describe "Day 5" do
    test "part 1 example", %{test: test_name} do
      output = do_test(test_name, "day5/example.txt", &Aoc24.Day5.part1/1)
      assert output == 143
    end

    test "part 1 input", %{test: test_name} do
      output = do_test(test_name, "day5/input.txt", &Aoc24.Day5.part1/1)
      assert output == 6267
    end

    test "part 2 example", %{test: test_name} do
      output = do_test(test_name, "day5/example.txt", &Aoc24.Day5.part2/1)
      assert output == 123
    end

    test "part 2 input", %{test: test_name} do
      output = do_test(test_name, "day5/input.txt", &Aoc24.Day5.part2/1)
      assert output == 5184
    end
  end

  describe "Day 6" do
    test "part 1 example", %{test: test_name} do
      output = do_test(test_name, "day6/example.txt", &Aoc24.Day6.part1/1)
      assert output == 41
    end

    test "part 1 input", %{test: test_name} do
      output = do_test(test_name, "day6/input.txt", &Aoc24.Day6.part1/1)
      assert output == 5516
    end

    test "part 2 example", %{test: test_name} do
      output = do_test(test_name, "day6/example.txt", &Aoc24.Day6.part2/1)
      assert output == 6
    end

    test "part 2 input", %{test: test_name} do
      output = do_test(test_name, "day6/input.txt", &Aoc24.Day6.part2/1)
      assert output == 2008
    end
  end

  describe "Day 7" do
    test "part 1 example", %{test: test_name} do
      output = do_test(test_name, "day7/example.txt", &Aoc24.Day7.part1/1)
      assert output == 3749
    end

    test "part 1 input", %{test: test_name} do
      output = do_test(test_name, "day7/input.txt", &Aoc24.Day7.part1/1)
      assert output == 2_314_935_962_622
    end

    test "part 2 example", %{test: test_name} do
      output = do_test(test_name, "day7/example.txt", &Aoc24.Day7.part2/1)
      assert output == 11387
    end

    test "part 2 input", %{test: test_name} do
      output = do_test(test_name, "day7/input.txt", &Aoc24.Day7.part2/1)
      assert output == 401_477_450_831_495
    end
  end

  describe "Day 8" do
    test "part 1 example", %{test: test_name} do
      output = do_test(test_name, "day8/example.txt", &Aoc24.Day8.part1/1)
      assert output == 14
    end

    test "part 1 input", %{test: test_name} do
      output = do_test(test_name, "day8/input.txt", &Aoc24.Day8.part1/1)
      assert output == 228
    end

    test "part 2 example", %{test: test_name} do
      output = do_test(test_name, "day8/example.txt", &Aoc24.Day8.part2/1)
      assert output == 34
    end

    test "part 2 input", %{test: test_name} do
      output = do_test(test_name, "day8/input.txt", &Aoc24.Day8.part2/1)
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
      output = do_test(test_name, "day9/example.txt", &Aoc24.Day9.part1/1)
      assert output == 1928
    end

    @tag timeout: :infinity
    test "part 1 input", %{test: test_name} do
      output = do_test(test_name, "day9/input.txt", &Aoc24.Day9.part1/1)
      assert output == 6_211_348_208_140
    end

    test "part 2 example", %{test: test_name} do
      output = do_test(test_name, "day9/example.txt", &Aoc24.Day9.part2/1)
      assert output == 2858
    end

    @tag timeout: :infinity
    test "part 2 input", %{test: test_name} do
      output = do_test(test_name, "day9/input.txt", &Aoc24.Day9.part2/1)
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
      output = do_test(test_name, "day10/example.txt", &Aoc24.Day10.part1/1)
      assert output == 36
    end

    test "part 1 input", %{test: test_name} do
      output = do_test(test_name, "day10/input.txt", &Aoc24.Day10.part1/1)
      assert output == 667
    end

    test "part 2 example", %{test: test_name} do
      output = do_test(test_name, "day10/example.txt", &Aoc24.Day10.part2/1)
      assert output == 81
    end

    test "part 2 input", %{test: test_name} do
      output = do_test(test_name, "day10/input.txt", &Aoc24.Day10.part2/1)
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
      output = do_test(test_name, "day11/example.txt", &Aoc24.Day11.part1/1)
      assert output == 55312
    end

    test "part 1 input", %{test: test_name} do
      output = do_test(test_name, "day11/input.txt", &Aoc24.Day11.part1/1)
      assert output == 185_205
    end

    test "original example with memo" do
      {:ok, contents} = File.read("./test/support/day11/example.txt")

      stones = Aoc24.Day11.process_input(contents)
      output = Aoc24.Day11.do_blinks(stones, 25)

      assert output == 55312
    end

    test "part 2 input", %{test: test_name} do
      output = do_test(test_name, "day11/input.txt", &Aoc24.Day11.part2/1)
      assert output == 221_280_540_398_419
    end
  end

  describe "Day 12" do
    test "part 1 example", %{test: test_name} do
      output = do_test(test_name, "day12/example.txt", &Aoc24.Day12.part1/1)
      assert output == 1930
    end

    test "part 1 input", %{test: test_name} do
      output = do_test(test_name, "day12/input.txt", &Aoc24.Day12.part1/1)
      assert output == 1_396_298
    end

    test "part 2 example", %{test: test_name} do
      output = do_test(test_name, "day12/example.txt", &Aoc24.Day12.part2/1)
      assert output == 1206
    end

    test "part 2 input", %{test: test_name} do
      output = do_test(test_name, "day12/input.txt", &Aoc24.Day12.part2/1)
      assert output == 853_588
    end
  end

  describe "Day 13" do
    test "part 1 example", %{test: test_name} do
      output = do_test(test_name, "day13/example.txt", &Aoc24.Day13.part1/1)
      assert output == 480
    end

    test "part 1 input", %{test: test_name} do
      output = do_test(test_name, "day13/input.txt", &Aoc24.Day13.part1/1)
      assert output == 29517
    end

    test "part 2 backtest", %{test: test_name} do
      output = do_test(test_name, "day13/example.txt", &Aoc24.Day13.part1_optimized/1)
      assert output == 480

      output = do_test(test_name, "day13/input.txt", &Aoc24.Day13.part1_optimized/1)
      assert output == 29517
    end

    test "part 2 example", %{test: test_name} do
      output = do_test(test_name, "day13/example.txt", &Aoc24.Day13.part2/1)
      assert output == 875_318_608_908
    end

    test "part 2 input", %{test: test_name} do
      output = do_test(test_name, "day13/input.txt", &Aoc24.Day13.part2/1)
      assert output == 103_570_327_981_381
    end
  end

  describe "Day 14" do
    test "wrap" do
      assert Aoc24.Day14.wrap({0, 0}, 11, 7) == {0, 0}
      assert Aoc24.Day14.wrap({-1, 0}, 11, 7) == {10, 0}
      assert Aoc24.Day14.wrap({-2, 0}, 11, 7) == {9, 0}
      assert Aoc24.Day14.wrap({-2, -2}, 11, 7) == {9, 5}
      assert Aoc24.Day14.wrap({11, 7}, 11, 7) == {0, 0}
      assert Aoc24.Day14.wrap({11, 7}, 11, 7) == {0, 0}
      assert Aoc24.Day14.wrap({10 + 2, 6 - 3}, 11, 7) == {1, 3}
    end

    test "part 1 example", %{test: test_name} do
      output = do_test(test_name, "day14/example.txt", &Aoc24.Day14.part1/2, width: 11, height: 7)
      assert output == 12
    end

    test "part 1 input", %{test: test_name} do
      output = do_test(test_name, "day14/input.txt", &Aoc24.Day14.part1/1)
      assert output == 220_971_520
    end

    test "part 2 input", %{test: test_name} do
      output = do_test(test_name, "day14/input.txt", &Aoc24.Day14.part2/1)
      assert output == 6355
    end
  end

  describe "Day 15" do
    test "part 1 small example", %{test: test_name} do
      output = do_test(test_name, "day15/example_small.txt", &Aoc24.Day15.part1/1)
      assert output == 2028
    end

    test "part 1 large example", %{test: test_name} do
      output = do_test(test_name, "day15/example_large.txt", &Aoc24.Day15.part1/1)
      assert output == 10092
    end

    test "part 1 input", %{test: test_name} do
      output = do_test(test_name, "day15/input.txt", &Aoc24.Day15.part1/1)
      assert output == 1_514_333
    end

    test "part 2 small example", %{test: test_name} do
      output = do_test(test_name, "day15/example_small_p2.txt", &Aoc24.Day15.part2/1)
      assert output == 618
    end

    test "part 2 large example", %{test: test_name} do
      output = do_test(test_name, "day15/example_large.txt", &Aoc24.Day15.part2/1)
      assert output == 9021
    end

    test "part 2 input", %{test: test_name} do
      output = do_test(test_name, "day15/input.txt", &Aoc24.Day15.part2/1)
      assert output == 1_528_453
    end
  end

  describe "Day 16" do
    test "part 1 example", %{test: test_name} do
      output = do_test(test_name, "day16/example.txt", &Aoc24.Day16.part1/1)
      assert output == 7036
    end

    test "part 1 example 2", %{test: test_name} do
      output = do_test(test_name, "day16/example_2.txt", &Aoc24.Day16.part1/1)
      assert output == 11048
    end

    @tag timeout: :infinity
    test "part 1 input", %{test: test_name} do
      output = do_test(test_name, "day16/input.txt", &Aoc24.Day16.part1/1)
      assert output == 102_504
    end

    test "part 2 example", %{test: test_name} do
      output = do_test(test_name, "day16/example.txt", &Aoc24.Day16.part2/1)
      assert output == 45
    end

    test "part 2 example 2", %{test: test_name} do
      output = do_test(test_name, "day16/example_2.txt", &Aoc24.Day16.part2/1)
      assert output == 64
    end

    @tag timeout: :infinity, skip: "Takes 15 minutes"
    test "part 2 input", %{test: test_name} do
      output = do_test(test_name, "day16/input.txt", &Aoc24.Day16.part2/1)
      assert output == 535
    end
  end

  describe "Day 17" do
    test "part 1 example", %{test: test_name} do
      output = do_test(test_name, "day17/example.txt", &Aoc24.Day17.part1/1)
      assert output == "4,6,3,5,6,3,5,2,1,0"
    end

    test "part 1 input", %{test: test_name} do
      output = do_test(test_name, "day17/input.txt", &Aoc24.Day17.part1/1)
      assert output == "7,3,0,5,7,1,4,0,5"
    end

    test "part 2 example", %{test: test_name} do
      output = do_test(test_name, "day17/example_p2.txt", &Aoc24.Day17.part2/1)
      assert output == 117_440
    end

    test "part 2 input", %{test: test_name} do
      output = do_test(test_name, "day17/input.txt", &Aoc24.Day17.part2/1)
      assert output == 202_972_175_280_682
    end
  end

  describe "Day 18" do
    test "part 1 example", %{test: test_name} do
      output =
        do_test(test_name, "day18/example.txt", &Aoc24.Day18.part1/2,
          count: 12,
          width: 6,
          height: 6
        )

      assert output == 22
    end

    test "part 1 input", %{test: test_name} do
      output = do_test(test_name, "day18/input.txt", &Aoc24.Day18.part1/1)
      assert output == 248
    end

    test "part 2 example", %{test: test_name} do
      output =
        do_test(test_name, "day18/example.txt", &Aoc24.Day18.part2/2,
          width: 6,
          height: 6
        )

      assert output == "6,1"
    end

    test "part 2 input", %{test: test_name} do
      output = do_test(test_name, "day18/input.txt", &Aoc24.Day18.part2/1)

      assert output == "32,55"
    end
  end

  describe "Day 19" do
    test "part 1 example", %{test: test_name} do
      output = do_test(test_name, "day19/example.txt", &Aoc24.Day19.part1/1)
      assert output == 6
    end

    test "part 1 input", %{test: test_name} do
      output = do_test(test_name, "day19/input.txt", &Aoc24.Day19.part1/1)
      assert output == 247
    end

    test "part 2 example", %{test: test_name} do
      output = do_test(test_name, "day19/example.txt", &Aoc24.Day19.part2/1)
      assert output == 16
    end

    test "part 2 input", %{test: test_name} do
      output = do_test(test_name, "day19/input.txt", &Aoc24.Day19.part2/1)
      assert output == 692_596_560_138_745
    end
  end

  describe "Day 20" do
    test "part 1 example", %{test: test_name} do
      output = do_test(test_name, "day20/example.txt", &Aoc24.Day20.part1/2, min_saving: 0)
      assert output == 44
    end

    test "part 1 input", %{test: test_name} do
      output = do_test(test_name, "day20/input.txt", &Aoc24.Day20.part1/1)
      assert output == 1289
    end

    test "part 2 example", %{test: test_name} do
      output = do_test(test_name, "day20/example.txt", &Aoc24.Day20.part2/2, min_saving: 50)
      assert output == 285
    end

    test "part 2 input", %{test: test_name} do
      output = do_test(test_name, "day20/input.txt", &Aoc24.Day20.part2/1)
      assert output == 982_425
    end
  end

  describe "Day 21" do
    test "part 1 example", %{test: test_name} do
      output = do_test(test_name, "day21/example.txt", &Aoc24.Day21.part1/1)
      assert output == 126_384
    end

    test "part 1 input", %{test: test_name} do
      output = do_test(test_name, "day21/input.txt", &Aoc24.Day21.part1/1)
      assert output == 246_990
    end

    test "part 2 input", %{test: test_name} do
      output = do_test(test_name, "day21/input.txt", &Aoc24.Day21.part2/1)
      assert output == 306_335_137_543_664
    end
  end

  describe "Day 22" do
    test "123" do
      assert Aoc24.Day22.next_n_secrets(123, 10) == [
               15_887_950,
               16_495_136,
               527_345,
               704_524,
               1_553_684,
               12_683_156,
               11_100_544,
               12_249_484,
               7_753_432,
               5_908_254
             ]
    end

    test "part 1 example", %{test: test_name} do
      output = do_test(test_name, "day22/example.txt", &Aoc24.Day22.part1/1)
      assert output == 37_327_623
    end

    test "part 1 input", %{test: test_name} do
      output = do_test(test_name, "day22/input.txt", &Aoc24.Day22.part1/1)
      assert output == 20_068_964_552
    end

    test "part 2 example", %{test: test_name} do
      output = do_test(test_name, "day22/example_p2.txt", &Aoc24.Day22.part2/1)
      assert output == 23
    end

    test "price changes" do
      assert Aoc24.Day22.price_changes(123, 9) == [
               {-3, 0},
               {6, 6},
               {-1, 5},
               {-1, 4},
               {0, 4},
               {2, 6},
               {-2, 6},
               {0, 4},
               {-2, 2}
             ]
    end

    test "part 2 input", %{test: test_name} do
      output = do_test(test_name, "day22/input.txt", &Aoc24.Day22.part2/1)
      assert output == 2246
    end
  end

  describe "Day 23" do
    test "part 1 example", %{test: test_name} do
      output = do_test(test_name, "day23/example.txt", &Aoc24.Day23.part1/1)
      assert output == 7
    end

    test "part 1 input", %{test: test_name} do
      output = do_test(test_name, "day23/input.txt", &Aoc24.Day23.part1/1)
      assert output == 1330
    end

    test "part 2 example", %{test: test_name} do
      output = do_test(test_name, "day23/example.txt", &Aoc24.Day23.part2/1)
      assert output == "co,de,ka,ta"
    end

    test "part 2 input", %{test: test_name} do
      output = do_test(test_name, "day23/input.txt", &Aoc24.Day23.part2/1)
      assert output == "hl,io,ku,pk,ps,qq,sh,tx,ty,wq,xi,xj,yp"
    end
  end

  describe "Day 24" do
    test "part 1 example small", %{test: test_name} do
      output = do_test(test_name, "day24/example_small.txt", &Aoc24.Day24.part1/1)
      assert output == 4
    end

    test "part 1 example large", %{test: test_name} do
      output = do_test(test_name, "day24/example_large.txt", &Aoc24.Day24.part1/1)
      assert output == 2024
    end

    test "part 1 input", %{test: test_name} do
      output = do_test(test_name, "day24/input.txt", &Aoc24.Day24.part1/1)
      assert output == 48_508_229_772_400
    end

    test "part 2 input", %{test: test_name} do
      output = do_test(test_name, "day24/input.txt", &Aoc24.Day24.part2/1)
      assert output == "cqr,ncd,nfj,qnw,vkg,z15,z20,z37"
    end
  end

  describe "Day 25" do
    test "part 1 example", %{test: test_name} do
      output = do_test(test_name, "day25/example.txt", &Aoc24.Day25.part1/1)
      assert output == 3
    end

    test "part 1 input", %{test: test_name} do
      output = do_test(test_name, "day25/input.txt", &Aoc24.Day25.part1/1)
      assert output == 0
    end
  end

  defp do_test(test, input_path, func, opts \\ []) do
    {:ok, contents} = File.read(Path.join(["./test", "support", input_path]))

    f =
      case length(opts) do
        0 -> fn -> func.(contents) end
        _ -> fn -> func.(contents, opts) end
      end

    {time, value} = :timer.tc(f)
    print_result(test, value, time)
    value
  end

  defp print_result(test, value, time) do
    time_format = :erlang.float_to_binary(time / 1_000_000, decimals: 3)
    IO.puts("#{time_format}s\t#{Atom.to_string(test)}:\t\t#{value}")
    value
  end
end
