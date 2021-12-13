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

  def solve(part: 2, sheet: sheet) do
    %{points: points, folds: folds} = parse_sheet(sheet)

    folds
    |> Enum.reduce(points, &apply_fold/2)
    |> tap(&plot/1)
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
    Enum.reduce(points, %{}, &fold_point(&1, fold, &2))
  end

  defp fold_point({{x, y}, true}, {"x", pivot}, new_points) when x > pivot do
    Map.put(new_points, {pivot(x, pivot), y}, true)
  end

  defp fold_point({{x, y}, true}, {"y", pivot}, new_points) when y > pivot do
    Map.put(new_points, {x, pivot(y, pivot)}, true)
  end

  defp fold_point({{x, y}, true}, _fold, new_points) do
    Map.put(new_points, {x, y}, true)
  end

  defp pivot(coordinate, pivot) do
    2 * pivot - coordinate
  end

  defp plot(points) do
    {from_x, to_x} = get_range(points, &x_mapper/1)
    {from_y, to_y} = get_range(points, &y_mapper/1)

    Enum.reduce(from_y..to_y, "", fn y, acc ->
      Enum.reduce(from_x..to_x, acc, fn x, acc ->
        if Map.has_key?(points, {x, y}) do
          "#{acc}#"
        else
          "#{acc} "
        end
      end)
      |> IO.puts()

      ""
    end)
  end

  defp x_mapper({{x, _y}, true}), do: x
  defp y_mapper({{_x, y}, true}), do: y

  defp get_range(points, mapper) when is_function(mapper, 1) do
    points
    |> Enum.map(mapper)
    |> Enum.min_max()
  end
end
