defmodule Day3 do
  @moduledoc """
  Day 3 puzzle solutions
  """

  @doc """
      * `:part` - Possible values: `1` or `2`. Represents both parts of the puzzle.
      * `:file_path` - When defined, the diagnostic report is read from this file instead of the next option.
      * `:diagnostic_report` - List of binary numbers.
  """
  @spec solve(Keyword.t()) :: integer()
  def solve(part: part, file_path: file_path) do
    diagnostic_report = read_diagnostic_report(file_path)

    solve(part: part, diagnostic_report: diagnostic_report)
  end

  def solve(part: 1, diagnostic_report: diagnostic_report) do
    calculate_power_consumption(diagnostic_report)
  end

  def solve(part: 2, diagnostic_report: diagnostic_report) do
    calculate_life_support_rating(diagnostic_report)
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

    binary_matrix = build_binary_matrix(diagnostic_report)

    last_column_index = get_last_column_index(binary_matrix)

    Enum.reduce(0..last_column_index, state, fn column, state ->
      %{"0" => num_zeros, "1" => num_ones} = get_column_frequencies(binary_matrix, column)

      update_state(state, num_zeros, num_ones)
    end)
  end

  defp build_binary_matrix(diagnostic_report) do
    Enum.map(diagnostic_report, &String.split(&1, "", trim: true))
  end

  defp get_last_column_index(binary_matrix) do
    binary_matrix
    |> Util.Matrix.column_size()
    |> Kernel.-(1)
  end

  defp get_column_frequencies(binary_matrix, column) do
    binary_matrix
    |> Util.Matrix.fetch_column(column)
    |> Enum.frequencies()
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

  defp calculate_life_support_rating(diagnostic_report) do
    %{oxygen_generator_rating: oxygen_generator_rating, co2_scrubber_rating: co2_scrubber_rating} =
      calculate_ratings(diagnostic_report)

    integer_from_binary(oxygen_generator_rating) * integer_from_binary(co2_scrubber_rating)
  end

  defp calculate_ratings(diagnostic_report) do
    binary_matrix = build_binary_matrix(diagnostic_report)

    %{
      oxygen_generator_rating: find_rating(binary_matrix, 0, :oxygen_generator_rating),
      co2_scrubber_rating: find_rating(binary_matrix, 0, :co2_scrubber_rating)
    }
  end

  defp find_rating([binany_list], _column, _rating), do: Enum.join(binany_list)

  defp find_rating(binary_matrix, column, rating) do
    frequencies = get_column_frequencies(binary_matrix, column)

    num_zeros = Map.get(frequencies, "0", 0)
    num_ones = Map.get(frequencies, "1", 0)

    bit_criteria = get_bit_criteria(num_ones, num_zeros, rating)

    binary_matrix
    |> Enum.filter(&(Enum.at(&1, column) == bit_criteria))
    |> find_rating(column + 1, rating)
  end

  defp get_bit_criteria(num_ones, num_zeros, :oxygen_generator_rating) do
    if num_ones >= num_zeros do
      "1"
    else
      "0"
    end
  end

  defp get_bit_criteria(num_ones, num_zeros, :co2_scrubber_rating) do
    if num_zeros <= num_ones do
      "0"
    else
      "1"
    end
  end
end
