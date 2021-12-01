defmodule Day1Test do
  use ExUnit.Case, async: true

  describe "solve part 1" do
    test "base case" do
      input = [
        199,
        200,
        208,
        210,
        200,
        207,
        240,
        269,
        260,
        263
      ]

      assert 7 == Day1.solve(part: 1, measurements: input)
    end

    test "challange" do
      file_path = Path.join(File.cwd!(), "input.txt")

      assert 1121 == Day1.solve(part: 1, file_path: file_path)
    end
  end

  describe "solve part 2" do
    test "base case" do
      input = [
        199,
        200,
        208,
        210,
        200,
        207,
        240,
        269,
        260,
        263
      ]

      assert 5 == Day1.solve(part: 2, measurements: input)
    end

    test "challange" do
      file_path = Path.join(File.cwd!(), "input.txt")

      assert 1065 == Day1.solve(part: 2, file_path: file_path)
    end
  end
end
