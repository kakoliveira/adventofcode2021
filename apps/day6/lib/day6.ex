defmodule Day6 do
  @moduledoc """
  Day 6 puzzle solutions
  """

  @spawn_rate 7

  @growth_rate 2

  @baby_to_parent_rate @growth_rate + @spawn_rate

  @doc """
      * `:part` - Possible values: `1` or `2`. Represents both parts of the puzzle.
      * `:file_path` - When defined, the lanternfishes data is read from this file instead of the next option.
      * `:lanternfishes` - Lanternfish school ages.
      * `:number_of_cycles` - How many cycles to simulate.
  """
  @spec solve(Keyword.t()) :: integer()
  def solve(part: part, file_path: file_path, number_of_cycles: number_of_cycles) do
    lanternfishes = read_lanternfishes_data(file_path)

    solve(part: part, lanternfishes: lanternfishes, number_of_cycles: number_of_cycles)
  end

  def solve(part: _part, lanternfishes: lanternfishes, number_of_cycles: number_of_cycles) do
    lanternfishes
    |> parse_lanternfishes()
    |> simulate(number_of_cycles)
  end

  defp read_lanternfishes_data(file_path) do
    file_path
    |> FileReader.read()
    |> FileReader.clean_content()
    |> List.first()
  end

  defp parse_lanternfishes(lanternfishes) do
    lanternfishes
    |> String.split(",", trim: true)
    |> Stream.map(&Util.safe_to_integer/1)
    |> Enum.to_list()
  end

  defp simulate(lanternfishes, number_of_cycles) do
    lanternfishes
    |> Enum.frequencies()
    |> then(fn lanternfishes ->
      Enum.reduce(1..number_of_cycles, lanternfishes, fn _day, lanternfishes ->
        simulate(lanternfishes)
      end)
    end)
    |> Enum.reduce(0, fn {_age, count}, acc -> acc + count end)
  end

  # Taken from https://github.com/DFilipeS/advent-of-code-2021/blob/main/day6/lib/day6.ex#L48
  # Thanks @DFilipeS
  defp simulate(fishes) do
    Enum.reduce(fishes, %{}, &simulate_day/2)
  end

  defp simulate_day({0, count}, acc) do
    acc
    |> Map.update(@spawn_rate - 1, count, &(&1 + count))
    |> Map.update(@baby_to_parent_rate - 1, count, &(&1 + count))
  end

  defp simulate_day({age, count}, acc) do
    Map.update(acc, age - 1, count, &(&1 + count))
  end
end
