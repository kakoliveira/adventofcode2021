defmodule Day13Test do
  use ExUnit.Case, async: true

  describe "solve part 1" do
    test "base case" do
      input = [
        "6,10",
        "0,14",
        "9,10",
        "0,3",
        "10,4",
        "4,11",
        "6,0",
        "6,12",
        "4,1",
        "0,13",
        "10,12",
        "3,4",
        "3,0",
        "8,4",
        "1,10",
        "2,14",
        "8,10",
        "9,0",
        "fold along y=7",
        "fold along x=5"
      ]

      assert 17 == Day13.solve(part: 1, sheet: input)
    end

    test "challange" do
      file_path = Path.join(File.cwd!(), "input.txt")

      assert 827 == Day13.solve(part: 1, file_path: file_path)
    end
  end

  describe "solve part 2" do
    test "base case" do
      input = [
        "6,10",
        "0,14",
        "9,10",
        "0,3",
        "10,4",
        "4,11",
        "6,0",
        "6,12",
        "4,1",
        "0,13",
        "10,12",
        "3,4",
        "3,0",
        "8,4",
        "1,10",
        "2,14",
        "8,10",
        "9,0",
        "fold along y=7",
        "fold along x=5"
      ]

      assert 16 == Day13.solve(part: 2, sheet: input)
    end

    test "challange" do
      file_path = Path.join(File.cwd!(), "input.txt")

      # EAHKRECP
      assert 104 == Day13.solve(part: 2, file_path: file_path)
    end
  end
end
