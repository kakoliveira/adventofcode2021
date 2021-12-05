defmodule Day5Test do
  use ExUnit.Case, async: true

  describe "solve part 1" do
    test "base case" do
      input = [
        "0,9 -> 5,9",
        "8,0 -> 0,8",
        "9,4 -> 3,4",
        "2,2 -> 2,1",
        "7,0 -> 7,4",
        "6,4 -> 2,0",
        "0,9 -> 2,9",
        "3,4 -> 1,4",
        "0,0 -> 8,8",
        "5,5 -> 8,2"
      ]

      assert 5 == Day5.solve(part: 1, vent_lines: input)
    end

    test "challange" do
      file_path = Path.join(File.cwd!(), "input.txt")

      assert 5169 == Day5.solve(part: 1, file_path: file_path)
    end
  end

  describe "solve part 2" do
    test "base case" do
      input = [
        "0,9 -> 5,9",
        "8,0 -> 0,8",
        "9,4 -> 3,4",
        "2,2 -> 2,1",
        "7,0 -> 7,4",
        "6,4 -> 2,0",
        "0,9 -> 2,9",
        "3,4 -> 1,4",
        "0,0 -> 8,8",
        "5,5 -> 8,2"
      ]

      assert 12 == Day5.solve(part: 2, vent_lines: input)
    end

    test "challange" do
      file_path = Path.join(File.cwd!(), "input.txt")

      assert 22_083 == Day5.solve(part: 2, file_path: file_path)
    end
  end
end
