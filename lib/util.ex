defmodule Aoc24.Util do
  @spec parseint(binary()) :: integer()
  def parseint(s) do
    elem(Integer.parse(s), 0)
  end
end
