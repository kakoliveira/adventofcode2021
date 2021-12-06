defmodule Day6 do
  @moduledoc """
  Day 6 puzzle solutions
  """

  @spawn_rate 7

  @growth_rate 2

  @baby_to_parent_rate @growth_rate + @spawn_rate - 1

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

  def solve(part: 1, lanternfishes: lanternfishes, number_of_cycles: number_of_cycles) do
    lanternfishes
    |> parse_lanternfishes()
    |> simulate(number_of_cycles)
    |> Enum.count()
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

  defp simulate(lanternfishes, 0), do: lanternfishes

  defp simulate(lanternfishes, number_of_cycles) do
    lanternfishes
    |> elapse_cycle()
    |> spawn_new_lanternfishes()
    |> simulate(number_of_cycles - 1)
  end

  defp elapse_cycle(lanternfishes) do
    Enum.map(lanternfishes, &(&1 - 1))
  end

  defp spawn_new_lanternfishes(lanternfishes) do
    {lanternfishes, number_of_babies} = check_parents(lanternfishes)

    add_babies_to_school(lanternfishes, number_of_babies)
  end

  defp check_parents(lanternfishes) do
    Enum.map_reduce(lanternfishes, 0, fn fish, num_of_babies ->
      if fish == -1 do
        {fish + @spawn_rate, num_of_babies + 1}
      else
        {fish, num_of_babies}
      end
    end)
  end

  defp add_babies_to_school(lanternfishes, 0), do: lanternfishes

  defp add_babies_to_school(lanternfishes, number_of_babies) do
    new_babies =
      for _ <- 1..number_of_babies do
        @baby_to_parent_rate
      end

    lanternfishes ++ new_babies
  end
end
