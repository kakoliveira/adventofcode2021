defmodule Day10 do
  @moduledoc """
  Day 10 puzzle solutions
  """

  @open_brackets "("
  @close_brackets ")"

  @open_square_brackets "["
  @close_square_brackets "]"

  @open_curly_brackets "{"
  @close_curly_brackets "}"

  @open_arrow "<"
  @close_arrow ">"

  # Guards
  defguard is_opening_char?(char)
           when char in [@open_brackets, @open_square_brackets, @open_curly_brackets, @open_arrow]

  defguard is_closing_char?(char)
           when char in [
                  @close_brackets,
                  @close_square_brackets,
                  @close_curly_brackets,
                  @close_arrow
                ]

  defguard arrow_pair_match?(open_char, close_char)
           when open_char == @open_arrow and close_char == @close_arrow

  defguard brackets_pair_match?(open_char, close_char)
           when open_char == @open_brackets and close_char == @close_brackets

  defguard curly_brackets_pair_match?(open_char, close_char)
           when open_char == @open_curly_brackets and close_char == @close_curly_brackets

  defguard square_brackets_pair_match?(open_char, close_char)
           when open_char == @open_square_brackets and close_char == @close_square_brackets

  defguard pair_match?(open_char, close_char)
           when arrow_pair_match?(open_char, close_char) or
                  brackets_pair_match?(open_char, close_char) or
                  curly_brackets_pair_match?(open_char, close_char) or
                  square_brackets_pair_match?(open_char, close_char)

  @doc """
      * `:part` - Possible values: `1` or `2`. Represents both parts of the puzzle.
      * `:file_path` - When defined, the navigation subsystem data is read from this file instead of the next option.
      * `:navigation_subsystem` - Navigation subsystem data.
  """

  @spec solve(Keyword.t()) :: integer()
  def solve(part: part, file_path: file_path) do
    navigation_subsystem = read_navigation_subsystem(file_path)

    solve(part: part, navigation_subsystem: navigation_subsystem)
  end

  def solve(part: 1, navigation_subsystem: navigation_subsystem) do
    navigation_subsystem
    |> run_syntax_validator()
    |> Enum.filter(&is_corrupted?/1)
    |> Enum.map(fn {_status, illegal_char} ->
      score_illegal_character(illegal_char)
    end)
    |> Enum.sum()
  end

  defp read_navigation_subsystem(file_path) do
    file_path
    |> FileReader.read()
    |> FileReader.clean_content()
  end

  defp run_syntax_validator(navigation_subsystem) do
    Enum.map(navigation_subsystem, &validate_line/1)
  end

  defp validate_line(line) do
    line
    |> String.split("", trim: true)
    |> Enum.reduce_while([], fn char, stack ->
      cond do
        is_closing_char?(char) ->
          pop_stack(char, stack)

        is_opening_char?(char) ->
          {:cont, [char] ++ stack}
      end
    end)
    |> set_status()
  end

  defp pop_stack(close_char, [top_of_stack | stack]) do
    if pair_match?(top_of_stack, close_char) do
      {:cont, stack}
    else
      {:halt, {:corrupted, close_char}}
    end
  end

  defp set_status([]), do: {:complete, []}

  defp set_status(stack) when is_list(stack) do
    {:incomplete, stack}
  end

  defp set_status(result), do: result

  defp is_corrupted?({:corrupted, _close_char}), do: true
  defp is_corrupted?(_line), do: false

  defp score_illegal_character(@close_brackets), do: 3
  defp score_illegal_character(@close_square_brackets), do: 57
  defp score_illegal_character(@close_curly_brackets), do: 1197
  defp score_illegal_character(@close_arrow), do: 25_137
end
