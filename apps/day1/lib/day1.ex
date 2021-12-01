defmodule Day1 do
  @moduledoc """
  Day 1 puzzle solutions
  """

  defguard has_increased_depth?(previous_depth, current_depth) when current_depth > previous_depth

  def solve(part: 1, file_path: file_path) do
    measurements = read_measurements(file_path)

    solve(part: 1, measurements: measurements)
  end

  def solve(part: 1, measurements: measurements) do
    calculate_number_of_increases(measurements)
  end

  defp read_measurements(file_path) do
    file_path
    |> FileReader.read()
    |> Enum.map(&Util.safe_to_integer/1)
    |> FileReader.clean_content()
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

  defp reduce_number_of_increases(
         current_measurement,
         %{
           previous_measurement: nil
         } = state
       ) do
    update_previous_measurement(state, current_measurement)
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
       when has_increased_depth?(previous_measurement, current_measurement) do
    %{state | number_of_increases: state.number_of_increases + 1}
  end

  defp update_number_of_increases(state, _current_measurement), do: state

  defp update_previous_measurement(state, current_measurement) do
    %{state | previous_measurement: current_measurement}
  end
end
