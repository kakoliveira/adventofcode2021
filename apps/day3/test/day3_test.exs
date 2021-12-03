defmodule Day3Test do
  use ExUnit.Case, async: true

  describe "solve part 1" do
    test "base case" do
      input = [
        "00100",
        "11110",
        "10110",
        "10111",
        "10101",
        "01111",
        "00111",
        "11100",
        "10000",
        "11001",
        "00010",
        "01010"
      ]

      assert 198 == Day3.solve(part: 1, diagnostic_report: input)
    end

    test "challange" do
      file_path = Path.join(File.cwd!(), "input.txt")

      assert 3_882_564 == Day3.solve(part: 1, file_path: file_path)
    end
  end
end
