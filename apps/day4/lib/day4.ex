defmodule Day4 do
  @moduledoc """
  Day 4 puzzle solutions
  """

  @doc """
      * `:part` - Possible values: `1` or `2`. Represents both parts of the puzzle.
      * `:file_path` - When defined, the bingo data is read from this file instead of the next option.
      * `:bingo` - Bingo data.
  """
  @spec solve(Keyword.t()) :: integer()
  def solve(part: part, file_path: file_path) do
    bingo = read_bingo_data(file_path)

    solve(part: part, bingo: bingo)
  end

  def solve(part: part, bingo: [number_sequence | boards]) do
    number_sequence = parse_number_sequence(number_sequence)
    boards = parse_boards(boards)

    %{current_number: current_number, winning_board: winning_board} =
      bingo(boards, number_sequence, win_last: part == 2)

    unmarked_numbers = get_unmarked_numbers(winning_board)

    Enum.sum(unmarked_numbers) * Util.safe_to_integer(current_number)
  end

  defp read_bingo_data(file_path) do
    file_path
    |> FileReader.read()
    |> FileReader.clean_content()
  end

  defp parse_number_sequence(number_sequence) do
    String.split(number_sequence, ",", trim: true)
  end

  defp parse_boards(boards) do
    boards
    |> Stream.chunk_every(5)
    |> Stream.map(&Board.new/1)
    |> Enum.to_list()
  end

  defp bingo(boards, [number | number_sequence], opts) do
    updated_boards =
      boards
      |> Enum.map(&Board.apply_number(&1, number))
      |> Enum.map(&Board.bingo?/1)

    winning_board = find_winning_board(boards, updated_boards, opts)

    if is_nil(winning_board) do
      bingo(updated_boards, number_sequence, opts)
    else
      %{current_number: number, winning_board: winning_board}
    end
  end

  defp find_winning_board(boards, updated_boards, win_last: true) do
    num_boards = length(boards)
    num_boards_with_bingo = Enum.count(boards, & &1.bingo)

    new_num_boards_with_bingo = Enum.count(updated_boards, & &1.bingo)

    if num_boards_with_bingo + 1 == num_boards and new_num_boards_with_bingo == num_boards do
      last_winning_board_index = Enum.find_index(boards, &(&1.bingo == false))

      Enum.at(updated_boards, last_winning_board_index)
    end
  end

  defp find_winning_board(_boards, updated_boards, _opts) do
    Enum.find(updated_boards, & &1.bingo)
  end

  defp get_unmarked_numbers(%{board: board}) do
    board
    |> Enum.flat_map(fn line ->
      Enum.reject(line, fn number ->
        number.marked
      end)
    end)
    |> Enum.map(fn %{number: number} ->
      Util.safe_to_integer(number)
    end)
  end
end
