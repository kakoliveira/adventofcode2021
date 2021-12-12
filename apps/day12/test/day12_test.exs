defmodule Day12Test do
  use ExUnit.Case, async: true

  describe "solve part 1" do
    test "base case" do
      input = [
        "start-A",
        "start-b",
        "A-c",
        "A-b",
        "b-d",
        "A-end",
        "b-end"
      ]

      assert 10 == Day12.solve(part: 1, edges: input)
    end

    test "larger base case" do
      input = [
        "dc-end",
        "HN-start",
        "start-kj",
        "dc-start",
        "dc-HN",
        "LN-dc",
        "HN-end",
        "kj-sa",
        "kj-HN",
        "kj-dc"
      ]

      assert 19 == Day12.solve(part: 1, edges: input)
    end

    test "another larger base case" do
      input = [
        "fs-end",
        "he-DX",
        "fs-he",
        "start-DX",
        "pj-DX",
        "end-zg",
        "zg-sl",
        "zg-pj",
        "pj-he",
        "RW-he",
        "fs-DX",
        "pj-RW",
        "zg-RW",
        "start-pj",
        "he-WI",
        "zg-he",
        "pj-fs",
        "start-RW"
      ]

      assert 226 == Day12.solve(part: 1, edges: input)
    end

    test "challange" do
      file_path = Path.join(File.cwd!(), "input.txt")

      assert 3298 == Day12.solve(part: 1, file_path: file_path)
    end
  end

  describe "solve part 2" do
    test "base case" do
      input = [
        "start-A",
        "start-b",
        "A-c",
        "A-b",
        "b-d",
        "A-end",
        "b-end"
      ]

      assert 36 == Day12.solve(part: 2, edges: input)
    end

    test "larger base case" do
      input = [
        "dc-end",
        "HN-start",
        "start-kj",
        "dc-start",
        "dc-HN",
        "LN-dc",
        "HN-end",
        "kj-sa",
        "kj-HN",
        "kj-dc"
      ]

      assert 103 == Day12.solve(part: 2, edges: input)
    end

    test "another larger base case" do
      input = [
        "fs-end",
        "he-DX",
        "fs-he",
        "start-DX",
        "pj-DX",
        "end-zg",
        "zg-sl",
        "zg-pj",
        "pj-he",
        "RW-he",
        "fs-DX",
        "pj-RW",
        "zg-RW",
        "start-pj",
        "he-WI",
        "zg-he",
        "pj-fs",
        "start-RW"
      ]

      assert 3509 == Day12.solve(part: 2, edges: input)
    end

    test "challange" do
      file_path = Path.join(File.cwd!(), "input.txt")

      assert 93_572 == Day12.solve(part: 2, file_path: file_path)
    end
  end
end
