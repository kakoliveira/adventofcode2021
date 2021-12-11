defmodule Day11Test do
  use ExUnit.Case, async: true

  describe "solve part 1" do
    test "base case" do
      input = [
        "5483143223",
        "2745854711",
        "5264556173",
        "6141336146",
        "6357385478",
        "4167524645",
        "2176841721",
        "6882881134",
        "4846848554",
        "5283751526"
      ]

      assert 1656 == Day11.solve(part: 1, octopus_energy_levels: input)
    end

    test "challange" do
      file_path = Path.join(File.cwd!(), "input.txt")

      assert 1749 == Day11.solve(part: 1, file_path: file_path)
    end
  end
end
