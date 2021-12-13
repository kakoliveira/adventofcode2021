defmodule Day13 do
  @moduledoc """
  Day 13 puzzle solutions
  """

  @doc """
      * `:part` - Possible values: `1` or `2`. Represents both parts of the puzzle.
      * `:file_path` - When defined, sheet is read from this file instead of the next option.
      * `:sheet` - Transparent sheet.
  """
  @spec solve(Keyword.t()) :: integer()
  def solve(part: part, file_path: file_path) do
    sheet = read_sheet(file_path)

    solve(part: part, sheet: sheet)
  end

  def solve(part: 1, sheet: sheet) do
    %{points: points, folds: folds} = parse_sheet(sheet)

    folds
    |> List.first()
    |> apply_fold(points)
    |> Enum.count()
  end

  defp read_sheet(file_path) do
    file_path
    |> FileReader.read()
    |> FileReader.clean_content()
  end

  defp parse_sheet(sheet) do
    state = %{points: %{}, folds: []}

    sheet
    |> Enum.reduce(state, &parse_line/2)
    |> Map.update!(:folds, &Enum.reverse/1)
  end

  defp parse_line("fold along " <> fold, state) do
    Map.update!(state, :folds, fn folds ->
      [parse_fold(fold)] ++ folds
    end)
  end

  defp parse_line(point, state) do
    Map.update!(state, :points, fn points ->
      Map.put(points, parse_point(point), true)
    end)
  end

  defp parse_fold(fold) do
    [axis, pivot] = String.split(fold, "=", trim: true)

    {axis, Util.safe_to_integer(pivot)}
  end

  defp parse_point(point) do
    [x, y] = String.split(point, ",", trim: true)

    {Util.safe_to_integer(x), Util.safe_to_integer(y)}
  end

  defp apply_fold(fold, points) do
    {points_to_fold, fixed_points} = Enum.split_with(points, &point_to_fold?(&1, fold))

    points_to_fold
    |> Enum.reduce(%{}, &fold_point(&1, fold, &2))
    |> Map.merge(Map.new(fixed_points))
  end

  defp point_to_fold?({{x, _y}, true}, {"x", pivot}) do
    x > pivot
  end

  defp point_to_fold?({{_x, y}, true}, {"y", pivot}) do
    y > pivot
  end

  defp fold_point({{x, y}, true}, {"x", pivot}, new_points) do
    Map.put(new_points, {pivot(x, pivot), y}, true)
  end

  defp fold_point({{x, y}, true}, {"y", pivot}, new_points) do
    Map.put(new_points, {x, pivot(y, pivot)}, true)
  end

  defp pivot(coordinate, pivot) do
    2 * pivot - coordinate
  end
end
