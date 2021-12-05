defmodule UtilTest do
  use ExUnit.Case, async: true

  doctest Util

  describe "safe_to_integer/2" do
    test "with 2 returns 2" do
      assert Util.safe_to_integer(2) == 2
    end

    test "with '2' returns 2" do
      assert Util.safe_to_integer("2") == 2
    end

    test "with '' returns nil" do
      refute Util.safe_to_integer("")
    end

    test "with '' with default" do
      assert Util.safe_to_integer("", 0) == 0
    end

    test "with nil returns nil" do
      refute Util.safe_to_integer(nil)
    end

    test "with nil and default 0 returns 0" do
      assert Util.safe_to_integer(nil, 0) == 0
    end

    test "with :atom returns nil" do
      refute Util.safe_to_integer(:atom)
    end

    test "with :atom and default 0 returns 0" do
      assert Util.safe_to_integer(:atom, 0) == 0
    end
  end

  describe "manhattan_distance/2" do
    test "examples" do
      assert Util.manhattan_distance({1, 1}, {2, 2}) == 2
      assert Util.manhattan_distance({-1, 1}, {2, -2}) == 6
      assert Util.manhattan_distance({10, 1}, {20, 2}) == 11
    end
  end

  describe "matrix_column_size/1" do
    test "gets matrix column size" do
      matrix = [
        [1, 2, 3],
        [1, 2, 3]
      ]

      assert Util.matrix_column_size(matrix) == 3
    end
  end

  describe "fetch_matrix_column/2" do
    test "gets matrix column" do
      matrix = [
        [1, 2, 3],
        [1, 2, 3]
      ]

      assert Util.fetch_matrix_column(matrix, 1) == [2, 2]
    end
  end
end
