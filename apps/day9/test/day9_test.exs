defmodule Day9Test do
  use ExUnit.Case, async: true

  describe "solve part 1" do
    test "base case" do
      input = [
        "2199943210",
        "3987894921",
        "9856789892",
        "8767896789",
        "9899965678"
      ]

      assert 15 == Day9.solve(part: 1, heightmap: input)
    end

    test "challange" do
      file_path = Path.join(File.cwd!(), "input.txt")

      assert 489 == Day9.solve(part: 1, file_path: file_path)
    end
  end

  describe "solve part 2" do
    test "base case" do
      input = [
        "2199943210",
        "3987894921",
        "9856789892",
        "8767896789",
        "9899965678"
      ]

      assert 1134 == Day9.solve(part: 2, heightmap: input)
    end

    test "challange" do
      file_path = Path.join(File.cwd!(), "input.txt")

      assert 1_056_330 == Day9.solve(part: 2, file_path: file_path)
    end
  end
end
