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
      file_path =
        File.cwd!()
        |> Path.join("input.txt")

      assert 1121 == Day1.solve(part: 1, file_path: file_path)
    end
  end
end
