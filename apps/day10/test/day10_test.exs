defmodule Day10Test do
  use ExUnit.Case, async: true

  describe "solve part 1" do
    test "base case" do
      input = [
        "[({(<(())[]>[[{[]{<()<>>",
        "[(()[<>])]({[<{<<[]>>(",
        "{([(<{}[<>[]}>{[]{[(<()>",
        "(((({<>}<{<{<>}{[]{[]{}",
        "[[<[([]))<([[{}[[()]]]",
        "[{[{({}]{}}([{[{{{}}([]",
        "{<[[]]>}<{[{[{[]{()[[[]",
        "[<(<(<(<{}))><([]([]()",
        "<{([([[(<>()){}]>(<<{{",
        "<{([{{}}[<[[[<>{}]]]>[]]"
      ]

      assert 26_397 == Day10.solve(part: 1, navigation_subsystem: input)
    end

    test "challange" do
      file_path = Path.join(File.cwd!(), "input.txt")

      assert 367_059 == Day10.solve(part: 1, file_path: file_path)
    end
  end
end
