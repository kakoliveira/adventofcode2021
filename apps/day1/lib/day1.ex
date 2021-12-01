defmodule Day1 do
  @moduledoc """
  Day 1 puzzle solutions
  """

  defguard has_increased_depth?(previous_depth, current_depth) when current_depth > previous_depth

  @doc """
      * `:part` - Possible values: `1` or `2`. Represents both parts of the puzzle.
      * `:file_path` - When defined, measurements are read from this file instead of the next option.
      * `:measurements` - List of measurements.
  """
  @spec solve(Keyword.t()) :: integer()
  def solve(part: part, file_path: file_path) do
    measurements = read_measurements(file_path)

    solve(part: part, measurements: measurements)
  end

  def solve(part: 1, measurements: measurements) do
    calculate_number_of_increases(measurements)
  end

  def solve(part: 2, measurements: measurements) do
    measurements
    |> arranje_with_sliding_window(size: 3)
    |> calculate_number_of_increases()
  end

  defp read_measurements(file_path) do
    file_path
    |> FileReader.read()
    |> Enum.map(&Util.safe_to_integer/1)
    |> FileReader.clean_content()
  end

  defp arranje_with_sliding_window(measurements, size: window_size)
       when length(measurements) < window_size do
    []
  end

  defp arranje_with_sliding_window(measurements, size: window_size) do
    new_measurement = calculate_new_measurement(measurements, window_size)

    remaining_measurements = Enum.drop(measurements, 1)

    [new_measurement] ++ arranje_with_sliding_window(remaining_measurements, size: window_size)
  end

  defp calculate_new_measurement(measurements, window_size) do
    measurements
    |> Enum.take(window_size)
    |> Enum.sum()
  end

  defp calculate_number_of_increases(measurements) do
    state = %{
      previous_measurement: nil,
      number_of_increases: 0
    }

    measurements
    |> Enum.reduce(state, &reduce_number_of_increases/2)
    |> Map.get(:number_of_increases)
  end

  defp reduce_number_of_increases(current_measurement, state) do
    state
    |> update_number_of_increases(current_measurement)
    |> update_previous_measurement(current_measurement)
  end

  defp update_number_of_increases(
         %{
           previous_measurement: previous_measurement
         } = state,
         current_measurement
       )
       when not is_nil(previous_measurement) and
              has_increased_depth?(previous_measurement, current_measurement) do
    %{state | number_of_increases: state.number_of_increases + 1}
  end

  defp update_number_of_increases(state, _current_measurement), do: state

  defp update_previous_measurement(state, current_measurement) do
    %{state | previous_measurement: current_measurement}
  end
end
