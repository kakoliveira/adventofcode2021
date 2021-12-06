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
    starting_config = Enum.frequencies(lanternfishes)

    ending_config =
      lanternfishes
      |> Enum.uniq()
      |> Enum.map(&compute_fish(&1, number_of_cycles))

    starting_config
    |> Enum.map(fn {original_fish, multiplier} ->
      List.keyfind(ending_config, original_fish, 0)
      |> elem(1)
      |> Kernel.*(multiplier)
    end)
    |> Enum.sum()
  end

  defp compute_fish(original_fish, number_of_cycles) do
    babies = get_babies_birthdays(original_fish + 1, number_of_cycles)

    {original_fish,
     1 +
       length(babies) +
       recursive_new_baby(babies, number_of_cycles)}
  end

  defp recursive_new_baby(parents, number_of_cycles) do
    babies =
      parents
      |> Enum.map(&get_babies_birthdays(&1 + @baby_to_parent_rate, number_of_cycles))
      |> List.flatten()

    num_babies = length(babies)

    if num_babies > 0 do
      num_babies +
        recursive_new_baby(babies, number_of_cycles)
    else
      num_babies
    end
  end

  defp get_babies_birthdays(current_cycle, number_of_cycles)
       when current_cycle > number_of_cycles do
    []
  end

  defp get_babies_birthdays(current_cycle, number_of_cycles) do
    [current_cycle] ++ get_babies_birthdays(current_cycle + @spawn_rate, number_of_cycles)
  end
end
