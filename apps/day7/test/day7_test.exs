defmodule Day7Test do
  use ExUnit.Case, async: true

  describe "solve part 1" do
    test "base case" do
      input = [16, 1, 2, 0, 4, 2, 7, 1, 2, 14]

      assert 37 == Day7.solve(part: 1, crab_positions: input)
    end

    test "challange" do
      file_path = Path.join(File.cwd!(), "input.txt")

      assert 328_262 == Day7.solve(part: 1, file_path: file_path)
    end
  end
end
