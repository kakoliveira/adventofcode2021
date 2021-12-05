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

  describe "is_diagonal?/1" do
    test "verifies with horizontal vent line" do
      assert false == VentLine.is_diagonal?(@vent_line_example)
    end

    test "verifies with vertical vent line" do
      assert false ==
               VentLine.is_diagonal?(%VentLine{origin_x: 0, origin_y: 2, target_x: 0, target_y: 9})
    end

    test "verifies with diagonal vent line" do
      assert true ==
               VentLine.is_diagonal?(%VentLine{origin_x: 0, origin_y: 2, target_x: 2, target_y: 0})
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

    test "generates points of a right-up diagonal vent line" do
      vent_line = %VentLine{origin_x: 5, origin_y: 5, target_x: 8, target_y: 2}

      expected_points = [{5, 5}, {6, 4}, {7, 3}, {8, 2}]

      assert ^expected_points = VentLine.generate_points(vent_line)
    end

    test "generates points of a right-down diagonal vent line" do
      vent_line = %VentLine{origin_x: 4, origin_y: 4, target_x: 6, target_y: 6}

      expected_points = [{4, 4}, {5, 5}, {6, 6}]

      assert ^expected_points = VentLine.generate_points(vent_line)
    end

    test "generates points of a left-down diagonal vent line" do
      vent_line = %VentLine{origin_x: 4, origin_y: 4, target_x: 2, target_y: 6}

      expected_points = [{4, 4}, {3, 5}, {2, 6}]

      assert ^expected_points = VentLine.generate_points(vent_line)
    end
  end
end
