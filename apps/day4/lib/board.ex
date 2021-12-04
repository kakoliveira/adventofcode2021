defmodule Number do
  defstruct number: nil, marked: false
end

defmodule Board do
  defstruct board: nil, bingo: false

  def new(board_list) do
    board =
      board_list
      |> Enum.map(fn line ->
        line
        |> String.split(" ", trim: true)
        |> Enum.map(fn number ->
          %Number{number: number}
        end)
      end)

    %Board{board: board}
  end

  def apply_number(%{board: board_value} = board, number) do
    updated_board =
      board_value
      |> Enum.map(fn line ->
        Enum.map(line, fn %Number{number: board_number, marked: marked} ->
          %Number{number: board_number, marked: board_number == number || marked}
        end)
      end)

    %{board | board: updated_board}
  end

  def bingo?(%Board{bingo: true} = board), do: board

  def bingo?(%{board: board_value} = board) do
    bingo =
      if horizontal_bingo?(board_value) do
        true
      else
        vertical_bingo?(board_value)
      end

    %{board | bingo: bingo}
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
