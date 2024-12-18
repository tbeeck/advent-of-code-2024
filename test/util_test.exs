defmodule Aoc24Test do
  use ExUnit.Case
  doctest Aoc24

  describe "Union find" do
    test "basic union find" do
      alias Aoc24.Util.Graph.UnionFind

      uf =
        UnionFind.new(5)
        |> UnionFind.union(0, 1)

      assert UnionFind.connected?(uf, 0, 1)
    end

    test "once removed union find" do
      alias Aoc24.Util.Graph.UnionFind

      uf =
        UnionFind.new(5)
        |> UnionFind.union(0, 1)

      refute UnionFind.connected?(uf, 0, 2)
      uf = UnionFind.union(uf, 1, 2)
      assert UnionFind.connected?(uf, 0, 2)
    end
  end
end
