defmodule VentLineTest do
  use ExUnit.Case, async: true

  @vent_line_example %VentLine{origin_x: 0, origin_y: 9, target_x: 5, target_y: 9}

  describe "new/1" do
    test "parses vent line" do
      input = "0,9 -> 5,9"

      expected_board = @vent_line_example

      assert ^expected_board = VentLine.new(input)
    end
  end

  describe "is_horizontal?/1" do
    test "verifies if vent line segment is horizontal" do
      assert true == VentLine.is_horizontal?(@vent_line_example)
    end
  end

  describe "is_vertical?/1" do
    test "verifies if vent line segment is vertical" do
      assert true ==
               VentLine.is_vertical?(%VentLine{origin_x: 0, origin_y: 2, target_x: 0, target_y: 9})
    end
  end

  describe "generate_points/1" do
    test "generates points of a vertical vent line" do
      vent_line = %VentLine{origin_x: 0, origin_y: 2, target_x: 0, target_y: 4}

      expected_points = [{0, 2}, {0, 3}, {0, 4}]

      assert ^expected_points = VentLine.generate_points(vent_line)
    end

    test "generates points of a horizontal vent line" do
      expected_points = [{0, 9}, {1, 9}, {2, 9}, {3, 9}, {4, 9}, {5, 9}]

      assert ^expected_points = VentLine.generate_points(@vent_line_example)
    end
  end
end
