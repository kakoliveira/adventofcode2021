defmodule Util.MatrixTest do
  use ExUnit.Case, async: true

  alias Util.Matrix

  describe "column_size/1" do
    test "gets matrix column size" do
      matrix = [
        [1, 2, 3],
        [1, 2, 3]
      ]

      assert Matrix.column_size(matrix) == 3
    end
  end

  describe "fetch_column/2" do
    test "gets matrix column" do
      matrix = [
        [1, 2, 3],
        [1, 2, 3]
      ]

      assert Matrix.fetch_column(matrix, 1) == [2, 2]
    end
  end
end
