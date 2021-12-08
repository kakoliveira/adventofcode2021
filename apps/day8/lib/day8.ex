defmodule Day8 do
  @moduledoc """
  Day 8 puzzle solutions
  """

  @doc """
      * `:part` - Possible values: `1` or `2`. Represents both parts of the puzzle.
      * `:file_path` - When defined, signal patterns are read from this file instead of the next option.
      * `:signal_patterns` - List of signal patterns.
  """
  @spec solve(Keyword.t()) :: integer()
  def solve(part: part, file_path: file_path) do
    signal_patterns = read_signal_patterns(file_path)

    solve(part: part, signal_patterns: signal_patterns)
  end

  def solve(part: 1, signal_patterns: signal_patterns) do
    signal_patterns
    |> parse_signal_patterns()
    |> count_unique_number_of_output_segments()
  end

  defp read_signal_patterns(file_path) do
    file_path
    |> FileReader.read()
    |> FileReader.clean_content()
  end

  defp parse_signal_patterns(signal_patterns) do
    Enum.map(signal_patterns, &parse_signal_pattern/1)
  end

  defp parse_signal_pattern(signal_pattern) do
    [signal, output] =
      signal_pattern
      |> String.split(" | ", trim: true)
      |> Enum.map(&String.split(&1, " ", trim: true))

    {signal, output}
  end

  defp count_unique_number_of_output_segments(signal_patterns) do
    signal_patterns
    |> Enum.map(&elem(&1, 1))
    |> Enum.reduce(0, fn output_segment, count ->
      count + Enum.count(output_segment, &is_unique_segment?/1)
    end)
  end

  defp is_unique_segment?(segment) do
    is_digit_1?(segment) or is_digit_4?(segment) or is_digit_7?(segment) or is_digit_8?(segment)
  end

  defp is_digit_1?(segment) do
    String.length(segment) == 2
  end

  defp is_digit_4?(segment) do
    String.length(segment) == 4
  end

  defp is_digit_7?(segment) do
    String.length(segment) == 3
  end

  defp is_digit_8?(segment) do
    String.length(segment) == 7
  end
end
