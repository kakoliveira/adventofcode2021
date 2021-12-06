defmodule Day6Test do
  use ExUnit.Case, async: true

  describe "solve part 1" do
    test "base intermediate case" do
      input = "3,4,3,1,2"

      assert 26 == Day6.solve(part: 1, lanternfishes: input, number_of_cycles: 18)
    end

    test "base case" do
      input = "3,4,3,1,2"

      assert 5934 == Day6.solve(part: 1, lanternfishes: input, number_of_cycles: 80)
    end

    test "challange" do
      file_path = Path.join(File.cwd!(), "input.txt")

      assert 365_131 == Day6.solve(part: 1, file_path: file_path, number_of_cycles: 80)
    end
  end

  describe "solve part 2" do
    test "base case" do
      input = "3,4,3,1,2"

      assert 26_984_457_539 == Day6.solve(part: 2, lanternfishes: input, number_of_cycles: 256)
    end

    test "challange" do
      file_path = Path.join(File.cwd!(), "input.txt")

      assert 1_650_309_278_600 == Day6.solve(part: 2, file_path: file_path, number_of_cycles: 256)
    end
  end
end
