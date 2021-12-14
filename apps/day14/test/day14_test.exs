defmodule Day14Test do
  use ExUnit.Case, async: true

  describe "solve part 1" do
    test "base case" do
      input = [
        "NNCB",
        "CH -> B",
        "HH -> N",
        "CB -> H",
        "NH -> C",
        "HB -> C",
        "HC -> B",
        "HN -> C",
        "NN -> C",
        "BH -> H",
        "NC -> B",
        "NB -> B",
        "BN -> B",
        "BB -> N",
        "BC -> B",
        "CC -> N",
        "CN -> C"
      ]

      # "NCNBCHB"
      # "NBCCNBBBCBHCB"
      # "NBBBCNCCNBBNBNBBCHBHHBCHB"
      # "NBBNBNBBCCNBCNCCNBBNBBNBBBNBBNBBCBHCBHHNHCBBCBHCB"

      assert 1588 == Day14.solve(part: 1, polymerization: input)
    end

    test "challange" do
      file_path = Path.join(File.cwd!(), "input.txt")

      assert 3230 == Day14.solve(part: 1, file_path: file_path)
    end
  end

  describe "solve part 2" do
    test "base case" do
      input = [
        "NNCB",
        "CH -> B",
        "HH -> N",
        "CB -> H",
        "NH -> C",
        "HB -> C",
        "HC -> B",
        "HN -> C",
        "NN -> C",
        "BH -> H",
        "NC -> B",
        "NB -> B",
        "BN -> B",
        "BB -> N",
        "BC -> B",
        "CC -> N",
        "CN -> C"
      ]

      assert 2_188_189_693_529 == Day14.solve(part: 2, polymerization: input)
    end

    test "challange" do
      file_path = Path.join(File.cwd!(), "input.txt")

      assert 3230 == Day14.solve(part: 2, file_path: file_path)
    end
  end
end
