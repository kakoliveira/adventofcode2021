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
    calculate_fuel_usage(crab_positions, fuel_consumption: :constant)
  end

  def solve(part: 2, crab_positions: crab_positions) do
    calculate_fuel_usage(crab_positions, fuel_consumption: :linear)
  end

  defp read_crab_positions(file_path) do
    file_path
    |> FileReader.read()
    |> List.first()
    |> String.split(",", trim: true)
    |> Enum.map(&Util.safe_to_integer/1)
    |> FileReader.clean_content()
  end

  defp calculate_fuel_usage(crab_positions, opts) do
    crab_positions
    |> calculate_best_horizontal_position(opts)
    |> then(&calculate_fuel_usage(crab_positions, &1, opts))
  end

  defp calculate_fuel_usage(crab_positions, target_position, fuel_consumption: :constant) do
    Enum.reduce(crab_positions, 0, fn crab_position, fuel ->
      abs(crab_position - target_position) + fuel
    end)
  end

  defp calculate_fuel_usage(crab_positions, target_position, fuel_consumption: :linear) do
    Enum.reduce(crab_positions, 0, fn crab_position, fuel ->
      fuel + linear_consumption(crab_position, target_position)
    end)
  end

  defp linear_consumption(crab_position, target_position) do
    distance = abs(crab_position - target_position)

    Enum.sum(1..distance)
  end

  defp calculate_best_horizontal_position(crab_positions, fuel_consumption: :constant) do
    positions = Enum.sort(crab_positions)

    calculate_median(positions, length(positions))
  end

  defp calculate_best_horizontal_position(crab_positions, fuel_consumption: :linear) do
    calculate_media(crab_positions)
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

  defp calculate_media(crab_positions) do
    num_positions = length(crab_positions)

    crab_positions
    |> Enum.sum()
    |> Kernel./(num_positions)
    |> round(down_on_draw: true)
  end

  defp round(number, down_on_draw: true) do
    number
    |> Kernel.-(0.1)
    |> round()
  end

  defp round(number, _), do: round(number)
end
