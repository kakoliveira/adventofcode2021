defmodule Day3 do
  @moduledoc """
  Day 3 puzzle solutions
  """

  @doc """
      * `:part` - Possible values: `1` or `2`. Represents both parts of the puzzle.
      * `:file_path` - When defined, the diagnostic report is read from this file instead of the next option.
      * `:diagnostic_report` - List of binay numbers.
  """
  @spec solve(Keyword.t()) :: integer()
  def solve(part: part, file_path: file_path) do
    diagnostic_report = read_diagnostic_report(file_path)

    solve(part: part, diagnostic_report: diagnostic_report)
  end

  def solve(part: 1, diagnostic_report: diagnostic_report) do
    calculate_power_consumption(diagnostic_report)
  end

  defp read_diagnostic_report(file_path) do
    file_path
    |> FileReader.read()
    |> FileReader.clean_content()
  end

  defp calculate_power_consumption(diagnostic_report) do
    %{gamma_rate: gamma_rate, epsilon_rate: epsilon_rate} = calculate_rates(diagnostic_report)

    integer_from_binary(gamma_rate) * integer_from_binary(epsilon_rate)
  end

  defp calculate_rates(diagnostic_report) do
    state = %{gamma_rate: "", epsilon_rate: ""}

    binary_matrix = Enum.map(diagnostic_report, &String.split(&1, "", trim: true))

    last_column_index = get_last_column_index(binary_matrix)

    Enum.reduce(0..last_column_index, state, fn column, state ->
      %{"0" => num_zeros, "1" => num_ones} =
        binary_matrix
        |> fetch_column(column)
        |> Enum.frequencies()

      update_state(state, num_zeros, num_ones)
    end)
  end

  defp get_last_column_index(binary_matrix) do
    binary_matrix
    |> List.first()
    |> length()
    |> Kernel.-(1)
  end

  defp fetch_column(matrix, column) do
    Enum.map(matrix, &Enum.at(&1, column))
  end

  defp update_state(state, num_zeros, num_ones) do
    if num_zeros > num_ones do
      %{state | gamma_rate: "#{state.gamma_rate}0", epsilon_rate: "#{state.epsilon_rate}1"}
    else
      %{state | gamma_rate: "#{state.gamma_rate}1", epsilon_rate: "#{state.epsilon_rate}0"}
    end
  end

  defp integer_from_binary(binary) do
    {decimal_integer, _} = Integer.parse(binary, 2)
    decimal_integer
  end
end
