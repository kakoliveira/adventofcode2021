defmodule VentLine do
  @moduledoc """
    Simple struct to keep relevant state of the Vent line segment
  """

  defstruct [:origin_x, :origin_y, :target_x, :target_y]

  @type t :: %VentLine{}

  @doc """
    Builds a VentLine struct from a string
  """
  @spec new(String.t() | list(String.t())) :: t()
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

  @doc """
    Verifies if the vent line is diagonal
  """
  @spec is_diagonal?(t()) :: boolean()
  def is_diagonal?(vent_line) do
    not is_horizontal?(vent_line) and not is_vertical?(vent_line)
  end

  defp is_horizontal?(%VentLine{origin_y: origin_y, target_y: target_y}) do
    origin_y == target_y
  end

  defp is_vertical?(%VentLine{origin_x: origin_x, target_x: target_x}) do
    origin_x == target_x
  end

  @doc """
    Generates all the points that belong to the given vent line
  """
  @spec generate_points(t()) :: list(tuple())
  def generate_points(vent_line) do
    points =
      if is_diagonal?(vent_line) do
        diagonal_generate_points(vent_line)
      else
        naive_generate_points(vent_line)
      end

    List.flatten(points)
  end

  defp naive_generate_points(%VentLine{
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
  end

  defp diagonal_generate_points(%VentLine{
         origin_x: origin_x,
         origin_y: origin_y,
         target_x: target_x,
         target_y: target_y
       }) do
    delta_x = target_x - origin_x
    delta_y = target_y - origin_y

    if abs(delta_x) !== abs(delta_y) do
      raise ArgumentError
    end

    Enum.map(
      0..abs(delta_x),
      &{apply_delta(origin_x, &1, delta_x), apply_delta(origin_y, &1, delta_y)}
    )
  end

  defp apply_delta(coordinate, shift, orientation) when orientation >= 0 do
    coordinate + shift
  end

  defp apply_delta(coordinate, shift, _orientation) do
    coordinate - shift
  end
end
