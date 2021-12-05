defmodule VentLine do
  @moduledoc """
    Simple struct to keep relevant state of the Vent line segment
  """

  defstruct [:origin_x, :origin_y, :target_x, :target_y]

  def new(line_segment) when is_binary(line_segment) do
    line_segment
    |> String.split(" -> ", trim: true)
    |> new()
  end

  def new([origin_coordinates, target_coordinates]) do
    [origin_x, origin_y] = parse_coordinates(origin_coordinates)
    [target_x, target_y] = parse_coordinates(target_coordinates)

    %VentLine{origin_x: origin_x, origin_y: origin_y, target_x: target_x, target_y: target_y}
  end

  defp parse_coordinates(coordinates) do
    coordinates
    |> String.split(",", trim: true)
    |> Enum.map(&Util.safe_to_integer/1)
  end

  def is_horizontal?(%VentLine{origin_y: origin_y, target_y: target_y}) do
    origin_y == target_y
  end

  def is_vertical?(%VentLine{origin_x: origin_x, target_x: target_x}) do
    origin_x == target_x
  end

  def generate_points(%VentLine{
        origin_x: origin_x,
        origin_y: origin_y,
        target_x: target_x,
        target_y: target_y
      }) do
    for x <- origin_x..target_x do
      for y <- origin_y..target_y do
        {x, y}
      end
    end
    |> List.flatten()
  end
end
