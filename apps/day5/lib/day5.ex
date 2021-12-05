defmodule Day5 do
  @moduledoc """
  Day 5 puzzle solutions
  """

  @doc """
      * `:part` - Possible values: `1` or `2`. Represents both parts of the puzzle.
      * `:file_path` - When defined, the vent_lines data is read from this file instead of the next option.
      * `:vent_lines` - Vent line segments.
  """
  @spec solve(Keyword.t()) :: integer()
  def solve(part: part, file_path: file_path) do
    vent_lines = read_vent_lines_data(file_path)

    solve(part: part, vent_lines: vent_lines)
  end

  def solve(part: 1, vent_lines: vent_lines) do
    vent_lines
    |> parse_vent_lines()
    |> discard_diagonal_vent_lines()
    |> get_intercting_points()
    |> Enum.frequencies()
    |> Enum.filter(fn {_key, value} -> value >= 2 end)
    |> Enum.count()
  end

  defp read_vent_lines_data(file_path) do
    file_path
    |> FileReader.read()
    |> FileReader.clean_content()
  end

  defp parse_vent_lines(vent_lines) do
    Enum.map(vent_lines, &VentLine.new/1)
  end

  defp discard_diagonal_vent_lines(vent_lines) do
    Enum.filter(vent_lines, fn vent_line ->
      VentLine.is_horizontal?(vent_line) or VentLine.is_vertical?(vent_line)
    end)
  end

  defp get_intercting_points(vent_lines) do
    Enum.flat_map(vent_lines, &VentLine.generate_points/1)
  end
end
