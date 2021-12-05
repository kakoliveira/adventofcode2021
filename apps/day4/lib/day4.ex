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
    updated_boards = run_number_on_boards(boards, number)

    winning_board = find_winning_board(boards, updated_boards, opts)

    if is_nil(winning_board) do
      bingo(updated_boards, number_sequence, opts)
    else
      %{current_number: number, winning_board: winning_board}
    end
  end

  defp run_number_on_boards(boards, number) do
    boards
    |> Enum.map(&Board.mark(&1, number))
    |> Enum.map(&Board.bingo/1)
  end

  defp find_winning_board(boards, updated_boards, win_last: true) do
    num_boards = length(boards)
    num_boards_with_bingo = count_boards_with_bingo(boards)

    new_num_boards_with_bingo = count_boards_with_bingo(updated_boards)

    if num_boards_with_bingo + 1 == num_boards and new_num_boards_with_bingo == num_boards do
      boards
      |> Enum.find_index(&(not has_bingo?(&1)))
      |> then(&Enum.at(updated_boards, &1))
    end
  end

  defp find_winning_board(_boards, updated_boards, _opts) do
    Enum.find(updated_boards, &has_bingo?/1)
  end

  defp count_boards_with_bingo(boards) do
    Enum.count(boards, &has_bingo?/1)
  end

  defp has_bingo?(%Board{bingo: bingo}), do: bingo

  defp get_unmarked_numbers(%Board{board: board}) do
    board
    |> Enum.flat_map(&get_unmarked_numbers_on_line/1)
    |> Enum.map(&Util.safe_to_integer(&1.number))
  end

  defp get_unmarked_numbers_on_line(board_line) do
    Enum.reject(board_line, & &1.marked)
  end
end
