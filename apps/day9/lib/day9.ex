defmodule Day9 do
  @moduledoc """
  Day 9 puzzle solutions
  """

  # Guards
  defguard first_column?(column_index) when column_index == 0
  defguard last_column?(column_index, num_columns) when column_index == num_columns - 1
  defguard first_row?(row_index) when row_index == 0
  defguard last_row?(row_index, num_rows) when row_index == num_rows - 1

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

  def solve(part: 2, heightmap: heightmap) do
    heightmap_matrix = parse_matrix(heightmap)

    heightmap_matrix
    |> find_low_points()
    |> get_basins(heightmap_matrix)
    |> Enum.map(fn basin ->
      basin
      |> Map.keys()
      |> length()
    end)
    |> Enum.sort(:desc)
    |> Enum.take(3)
    |> Enum.product()
  end

  defp read_heightmap(file_path) do
    file_path
    |> FileReader.read()
    |> FileReader.clean_content()
  end

  defp parse_matrix(heightmap) do
    Util.Matrix.parse_matrix(heightmap, to_integer: true)
  end

  defp find_low_points(heightmap_matrix) do
    heightmap_matrix_struct = describe_heightmap_matrix(heightmap_matrix)

    heightmap_matrix
    |> Enum.with_index()
    |> Enum.reduce([], fn row, low_points ->
      find_low_points(row, heightmap_matrix_struct) ++ low_points
    end)
  end

  defp find_low_points({row, row_index}, heightmap_matrix_struct) do
    row
    |> Enum.with_index()
    |> Enum.reduce([], fn {height, column_index}, low_points ->
      point = {height, row_index, column_index}

      if is_low_point?(
           point,
           row,
           heightmap_matrix_struct
         ) do
        [point] ++ low_points
      else
        low_points
      end
    end)
  end

  defp is_low_point?(
         point,
         row,
         {heightmap_matrix, num_rows, num_columns}
       ) do
    less_then_left?(point, row) and
      less_than_right?(point, row, num_columns) and
      less_than_down?(point, heightmap_matrix, num_rows) and
      less_than_up?(point, heightmap_matrix, num_rows)
  end

  defp less_then_left?({_height, _row_index, column_index}, _row)
       when first_column?(column_index),
       do: true

  defp less_then_left?({height, _row_index, column_index}, row) do
    height < Enum.at(row, column_index - 1)
  end

  defp less_than_right?({_height, _row_index, column_index}, _row, num_columns)
       when last_column?(column_index, num_columns),
       do: true

  defp less_than_right?({height, _row_index, column_index}, row, _num_columns) do
    height < Enum.at(row, column_index + 1)
  end

  defp less_than_down?({_height, row_index, _column_index}, _heightmap_matrix, num_rows)
       when last_row?(row_index, num_rows),
       do: true

  defp less_than_down?({height, row_index, column_index}, heightmap_matrix, _num_rows) do
    {value_bellow, _row_index, _column_index} =
      get_point(heightmap_matrix, row_index + 1, column_index)

    height < value_bellow
  end

  defp less_than_up?({_height, row_index, _column_index}, _heightmap_matrix, _num_rows)
       when first_row?(row_index),
       do: true

  defp less_than_up?({height, row_index, column_index}, heightmap_matrix, _num_rows) do
    {value_above, _row_index, _column_index} =
      get_point(heightmap_matrix, row_index - 1, column_index)

    height < value_above
  end

  defp calculate_risk_level(low_points) do
    low_points
    |> Enum.map(&elem(&1, 0))
    |> Enum.sum()
    |> Kernel.+(length(low_points))
  end

  defp get_basins(low_points, heightmap_matrix) do
    heightmap_matrix_struct = describe_heightmap_matrix(heightmap_matrix)

    Enum.map(low_points, &find_basin(&1, %{}, heightmap_matrix_struct))
  end

  defp find_basin({height, row_index, column_index} = point, basin, heightmap_matrix_struct) do
    updated_basin = Map.put_new(basin, {row_index, column_index}, height)

    updated_basin
    |> append_flow(left_downward_flow(point, updated_basin, heightmap_matrix_struct))
    |> append_flow(right_downward_flow(point, updated_basin, heightmap_matrix_struct))
    |> append_flow(up_downward_flow(point, updated_basin, heightmap_matrix_struct))
    |> append_flow(down_downward_flow(point, updated_basin, heightmap_matrix_struct))
  end

  defp append_flow(basin, new_points) do
    Map.merge(new_points, basin)
  end

  defp left_downward_flow({_height, _row_index, column_index}, basin, _heightmap_matrix_struct)
       when first_column?(column_index),
       do: basin

  defp left_downward_flow(
         {height, row_index, column_index},
         basin,
         {heightmap_matrix, _num_rows, _num_columns} = heightmap_matrix_struct
       ) do
    heightmap_matrix
    |> get_point(row_index, column_index - 1)
    |> downward_flow(
      height,
      basin,
      heightmap_matrix_struct
    )
  end

  defp right_downward_flow(
         {_height, _row_index, column_index},
         basin,
         {_heightmap_matrix, _num_rows, num_columns}
       )
       when last_column?(column_index, num_columns),
       do: basin

  defp right_downward_flow(
         {height, row_index, column_index},
         basin,
         {heightmap_matrix, _num_rows, _num_columns} = heightmap_matrix_struct
       ) do
    heightmap_matrix
    |> get_point(row_index, column_index + 1)
    |> downward_flow(
      height,
      basin,
      heightmap_matrix_struct
    )
  end

  defp down_downward_flow(
         {_height, row_index, _column_index},
         basin,
         {_heightmap_matrix, num_rows, _num_columns}
       )
       when last_row?(row_index, num_rows),
       do: basin

  defp down_downward_flow(
         {height, row_index, column_index},
         basin,
         {heightmap_matrix, _num_rows, _num_columns} = heightmap_matrix_struct
       ) do
    heightmap_matrix
    |> get_point(row_index + 1, column_index)
    |> downward_flow(
      height,
      basin,
      heightmap_matrix_struct
    )
  end

  defp up_downward_flow({_height, row_index, _column_index}, basin, _heightmap_matrix_struct)
       when first_row?(row_index),
       do: basin

  defp up_downward_flow(
         {height, row_index, column_index},
         basin,
         {heightmap_matrix, _num_rows, _num_columns} = heightmap_matrix_struct
       ) do
    heightmap_matrix
    |> get_point(row_index - 1, column_index)
    |> downward_flow(
      height,
      basin,
      heightmap_matrix_struct
    )
  end

  defp downward_flow(
         {height, _row_index, _column_index} = point,
         adjancent_height,
         basin,
         heightmap_matrix_struct
       )
       when height != 9 and height > adjancent_height do
    find_basin(point, basin, heightmap_matrix_struct)
  end

  defp downward_flow(_point, _adjancent_height, basin, _heightmap_matrix_struct),
    do: basin

  defp describe_heightmap_matrix(heightmap_matrix) do
    num_columns = Util.Matrix.column_size(heightmap_matrix)
    num_rows = length(heightmap_matrix)

    {heightmap_matrix, num_rows, num_columns}
  end

  defp get_point(heightmap_matrix, row_index, column_index) do
    height =
      heightmap_matrix
      |> Enum.at(row_index)
      |> Enum.at(column_index)

    {height, row_index, column_index}
  end
end
