defmodule Number do
  @moduledoc """
    Simple struct to keep state of a number in a bingo Board
  """

  defstruct number: nil, marked: false
end

defmodule Board do
  @moduledoc """
    Simple struct to keep state of a bingo Board
  """

  defstruct board: nil, bingo: false

  @type t :: %Board{}

  @doc """
    Builds a new Board struct from a list of strings
  """
  @spec new(list(String.t())) :: t()
  def new(board_list) do
    %Board{board: Enum.map(board_list, &build_line/1)}
  end

  defp build_line(line) do
    line
    |> String.split(" ", trim: true)
    |> Enum.map(&%Number{number: &1})
  end

  @doc """
    Sets the given number as marked if present on the Board
  """
  @spec mark(t(), String.t()) :: t()
  def mark(%{board: board} = struct, number) do
    %{struct | board: Enum.map(board, &mark_line(&1, number))}
  end

  defp mark_line(board_line, number) do
    Enum.map(board_line, &mark_number(&1, number))
  end

  defp mark_number(%Number{number: board_number, marked: marked}, number) do
    %Number{number: board_number, marked: board_number == number || marked}
  end

  @doc """
    Checks if the Board has made Bingo, and sets the bingo flag if it has
  """
  @spec bingo(t()) :: t()
  def bingo(%Board{bingo: true} = board), do: board

  def bingo(%Board{board: board} = struct) do
    bingo =
      if horizontal_bingo?(board) do
        true
      else
        vertical_bingo?(board)
      end

    %{struct | bingo: bingo}
  end

  defp horizontal_bingo?(board) do
    board
    |> Enum.map(&line_is_all_marked?/1)
    |> Enum.any?()
  end

  defp line_is_all_marked?(board_line) do
    Enum.all?(board_line, & &1.marked)
  end

  defp vertical_bingo?(board) do
    last_column_index = Util.matrix_column_size(board) - 1

    0..last_column_index
    |> Enum.map(&Util.fetch_matrix_column(board, &1))
    |> horizontal_bingo?()
  end
end
