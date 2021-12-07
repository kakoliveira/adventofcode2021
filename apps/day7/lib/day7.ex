defmodule Day7 do
  @moduledoc """
  Day 7 puzzle solutions
  """

  @doc """
      * `:part` - Possible values: `1` or `2`. Represents both parts of the puzzle.
      * `:file_path` - When defined, crab positions are read from this file instead of the next option.
      * `:crab_positions` - List of crab horizontal positions.
  """
  @spec solve(Keyword.t()) :: integer()
  def solve(part: part, file_path: file_path) do
    crab_positions = read_crab_positions(file_path)

    solve(part: part, crab_positions: crab_positions)
  end

  def solve(part: 1, crab_positions: crab_positions) do
    calculate_fuel_usage(crab_positions)
  end

  defp read_crab_positions(file_path) do
    file_path
    |> FileReader.read()
    |> List.first()
    |> String.split(",", trim: true)
    |> Enum.map(&Util.safe_to_integer/1)
    |> FileReader.clean_content()
  end

  defp calculate_fuel_usage(crab_positions) do
    crab_positions
    |> calculate_best_horizontal_position()
    |> then(&calculate_fuel_usage(crab_positions, &1))
  end

  defp calculate_best_horizontal_position(crab_positions) do
    positions = Enum.sort(crab_positions)

    calculate_median(positions, length(positions))
  end

  defp calculate_median(positions, sample_size) when rem(sample_size, 2) == 0 do
    mid_point = sample_size / 2

    Enum.at(positions, floor(mid_point))
  end

  defp calculate_median(positions, sample_size) do
    mid_point = sample_size / 2

    (Enum.at(positions, floor(mid_point)) +
       Enum.at(positions, ceil(mid_point))) / 2
  end

  defp calculate_fuel_usage(crab_positions, target_position) do
    Enum.reduce(crab_positions, 0, fn crab_position, fuel ->
      abs(crab_position - target_position) + fuel
    end)
  end
end
