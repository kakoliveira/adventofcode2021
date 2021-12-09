defmodule Day9 do
  @moduledoc """
  Day 9 puzzle solutions
  """

  @doc """
      * `:part` - Possible values: `1` or `2`. Represents both parts of the puzzle.
      * `:file_path` - When defined, the heightmap are read from this file instead of the next option.
      * `:heightmap` - Heightmap matrix.
  """
  @spec solve(Keyword.t()) :: integer()
  def solve(part: part, file_path: file_path) do
    heightmap = read_heightmap(file_path)

    solve(part: part, heightmap: heightmap)
  end

  def solve(part: 1, heightmap: heightmap) do
    heightmap
    |> parse_matrix()
    |> find_low_points()
    |> calculate_risk_level()
  end

  defp read_heightmap(file_path) do
    file_path
    |> FileReader.read()
    |> FileReader.clean_content()
  end

  defp parse_matrix(heightmap) do
    Enum.map(heightmap, &parse_matrix_row/1)
  end

  defp parse_matrix_row(matrix_row) do
    matrix_row
    |> String.split("", trim: true)
    |> Enum.map(&Util.safe_to_integer/1)
  end

  defp find_low_points(heightmap_matrix) do
    num_columns = Util.matrix_column_size(heightmap_matrix)

    num_rows = length(heightmap_matrix)

    heightmap_matrix
    |> Enum.with_index()
    |> Enum.reduce([], fn row, low_points ->
      find_low_points(row, {heightmap_matrix, num_rows, num_columns}) ++ low_points
    end)
  end

  defp find_low_points({row, row_index}, heightmap_matrix_struct) do
    row
    |> Enum.with_index()
    |> Enum.reduce([], fn {height, column_index}, low_points ->
      if is_low_point?(
           height,
           row,
           {row_index, column_index},
           heightmap_matrix_struct
         ) do
        [height] ++ low_points
      else
        low_points
      end
    end)
  end

  defp is_low_point?(
         height,
         row,
         {row_index, column_index},
         {heightmap_matrix, num_rows, num_columns}
       ) do
    less_then_left?(height, column_index, row) and
      less_than_right?(height, column_index, row, num_columns) and
      less_than_bottom?(height, column_index, row_index, heightmap_matrix, num_rows) and
      less_than_top?(height, column_index, row_index, heightmap_matrix, num_rows)
  end

  defp less_then_left?(_height, 0, _row), do: true

  defp less_then_left?(height, column_index, row) do
    height < Enum.at(row, column_index - 1)
  end

  defp less_than_right?(_height, column_index, _row, num_columns)
       when column_index == num_columns - 1,
       do: true

  defp less_than_right?(height, column_index, row, _num_columns) do
    height < Enum.at(row, column_index + 1)
  end

  defp less_than_bottom?(_height, _column_index, row_index, _heightmap_matrix, num_rows)
       when row_index == num_rows - 1,
       do: true

  defp less_than_bottom?(height, column_index, row_index, heightmap_matrix, _num_rows) do
    value_bellow =
      heightmap_matrix
      |> Enum.at(row_index + 1)
      |> Enum.at(column_index)

    height < value_bellow
  end

  defp less_than_top?(_height, _column_index, 0, _heightmap_matrix, _num_rows), do: true

  defp less_than_top?(height, column_index, row_index, heightmap_matrix, _num_rows) do
    value_above =
      heightmap_matrix
      |> Enum.at(row_index - 1)
      |> Enum.at(column_index)

    height < value_above
  end

  defp calculate_risk_level(low_points) do
    low_points
    |> Enum.sum()
    |> Kernel.+(length(low_points))
  end
end
