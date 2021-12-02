defmodule Day2Test do
  use ExUnit.Case, async: true

  describe "solve part 1" do
    test "base case" do
      input = [
        "forward 5",
        "down 5",
        "forward 8",
        "up 3",
        "down 8",
        "forward 2"
      ]

      assert 150 == Day2.solve(part: 1, commands: input)
    end

    test "challange" do
      file_path = Path.join(File.cwd!(), "input.txt")

      assert 2_102_357 == Day2.solve(part: 1, file_path: file_path)
    end
  end

  describe "solve part 2" do
    test "base case" do
      input = [
        "forward 5",
        "down 5",
        "forward 8",
        "up 3",
        "down 8",
        "forward 2"
      ]

      assert 900 == Day2.solve(part: 2, commands: input)
    end

    test "challange" do
      file_path = Path.join(File.cwd!(), "input.txt")

      assert 2_101_031_224 == Day2.solve(part: 2, file_path: file_path)
    end
  end
end
