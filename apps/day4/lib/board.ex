defmodule Number do
  defstruct number: nil, marked: false
end

defmodule Board do
  def new(board_list) do
    board_list
    |> Enum.map(fn line ->
      line
      |> String.split(" ", trim: true)
      |> Enum.map(fn number ->
        %Number{number: number}
      end)
    end)
  end

  def apply_number(board, number) do
    board
    |> Enum.map(fn line ->
      Enum.map(line, fn %Number{number: board_number, marked: marked} ->
        %Number{number: board_number, marked: board_number == number || marked}
      end)
    end)
  end

  def bingo?(board) do
    if horizontal_bingo?(board) do
      true
    else
      vertical_bingo?(board)
    end
  end

  defp horizontal_bingo?(board) do
    Enum.map(
      board,
      &Enum.all?(&1, fn number ->
        number.marked
      end)
    )
    |> Enum.any?()
  end

  defp vertical_bingo?(board) do
    Enum.map(0..4, fn column ->
      Enum.map(board, &Enum.at(&1, column))
    end)
    |> horizontal_bingo?()
  end
end
