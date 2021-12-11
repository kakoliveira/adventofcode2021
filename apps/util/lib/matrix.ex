defmodule Util.Matrix do
  @moduledoc """
  Helper functions when working with matrices
  """

  @type matrix :: list(list())

  @spec parse_matrix(list(String.t())) :: matrix()
  def parse_matrix(lines, opts \\ []) do
    Enum.map(lines, &parse_matrix_row(&1, opts))
  end

  defp parse_matrix_row(matrix_row, opts) do
    delimiter = Keyword.get(opts, :delimiter, "")
    to_integer? = Keyword.get(opts, :to_integer, false)

    matrix_row
    |> String.split(delimiter, trim: true)
    |> to_integer(to_integer?)
  end

  defp to_integer(row, false), do: row

  defp to_integer(row, true) do
    Enum.map(row, &Util.safe_to_integer/1)
  end

  @spec column_size(matrix()) :: non_neg_integer
  def column_size(matrix) do
    matrix
    |> List.first()
    |> length()
  end

  @spec fetch_column(matrix(), non_neg_integer()) :: list()
  def fetch_column(matrix, column) do
    Enum.map(matrix, &Enum.at(&1, column))
  end
end
