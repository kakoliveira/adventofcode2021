defmodule Util.Matrix do
  @moduledoc """
  Helper functions when working with matrices
  """

  @type matrix :: list(list())

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
