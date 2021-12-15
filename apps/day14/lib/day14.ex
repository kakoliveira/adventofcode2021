defmodule Day14 do
  @moduledoc """
  Day 14 puzzle solutions
  """

  @doc """
      * `:part` - Possible values: `1` or `2`. Represents both parts of the puzzle.
      * `:file_path` - When defined, the polymerization data is read from this file instead of the next option.
      * `:polymerization` - Polymerization data.
  """
  @spec solve(Keyword.t()) :: integer()
  def solve(part: part, file_path: file_path) do
    polymerization = read_polymerization_data(file_path)

    solve(part: part, polymerization: polymerization)
  end

  def solve(part: 1, polymerization: polymerization) do
    calculate_polymer_metric(polymerization, 10)
  end

  def solve(part: 2, polymerization: polymerization) do
    calculate_polymer_metric(polymerization, 40)
  end

  defp calculate_polymer_metric(polymerization, steps) do
    %{template: template, pair_insertion_rules: rules} = parse_polymerization(polymerization)

    template
    |> compute_polymer(rules, steps)
    |> Enum.min_max_by(&elem(&1, 1))
    |> subtract_element_quantities()
  end

  defp read_polymerization_data(file_path) do
    file_path
    |> FileReader.read()
    |> FileReader.clean_content()
  end

  defp parse_polymerization([template | rules]) do
    %{
      template: String.split(template, "", trim: true),
      pair_insertion_rules: Enum.reduce(rules, %{}, &parse_rule/2)
    }
  end

  defp parse_rule(rule, rules) do
    [pair, insertion] = String.split(rule, " -> ", trim: true)

    Map.put(rules, pair, insertion)
  end

  defp compute_polymer(template, rules, steps) do
    last_element = List.last(template)

    template
    |> Enum.chunk_every(2, 1, :discard)
    |> Enum.map(&run_for_chunk(&1, steps, rules))
    |> Enum.reduce(%{}, &merge_frequencies(&1, &2))
    |> Map.update!(last_element, &(&1 + 1))
  end

  defp run_for_chunk(chunk, steps, rules) do
    chunk
    |> List.first()
    |> List.wrap()
    |> Enum.frequencies()
    |> merge_frequencies(recursive(chunk, rules, 0, steps))
  end

  defp recursive(_chunk, _rules, steps, steps), do: %{}

  defp recursive(chunk, rules, current_step, steps) do
    {inserted_element, new_pairs} = apply_rules_to_pair(chunk, rules)

    [pair1, pair2] = Enum.reverse(new_pairs)

    [{inserted_element, 1}]
    |> Map.new()
    |> merge_frequencies(recursive(pair1, rules, current_step + 1, steps))
    |> merge_frequencies(recursive(pair2, rules, current_step + 1, steps))
  end

  defp merge_frequencies(partial_frequency1, partial_frequency2) do
    Map.merge(partial_frequency1, partial_frequency2, fn _key, count1, count2 ->
      count1 + count2
    end)
  end

  defp apply_rules_to_pair([element1, element2] = pair, rules) do
    element_to_insert = Map.get(rules, Enum.join(pair))

    if is_nil(element_to_insert) do
      {element_to_insert, [pair]}
    else
      {element_to_insert, [[element_to_insert, element2], [element1, element_to_insert]]}
    end
  end

  defp subtract_element_quantities({
         {_least_common_element, least_common_quantity},
         {_most_common_element, most_common_quantity}
       }) do
    most_common_quantity - least_common_quantity
  end
end

# https://www.reddit.com/r/adventofcode/comments/rfzq6f/2021_day_14_solutions/holo464/?utm_source=reddit&utm_medium=web2x&context=3
# @x3nophus

# defmodule Aoc2021.Day14 do
#   @input_file Path.dirname(__ENV__.file) <> "/input.txt"

#   def part1, do: part1(@input_file)

#   def part1(path) do
#     path
#     |> parse_input()
#     |> generate_initial_counts()
#     |> grow(10)
#     |> calc_poly_counts()
#     |> element_difference()
#   end

#   def part2, do: part2(@input_file)

#   def part2(path) do
#     path
#     |> parse_input()
#     |> generate_initial_counts()
#     |> grow(40)
#     |> calc_poly_counts()
#     |> element_difference()
#   end

#   defp calc_poly_counts(polymer_counts) do
#     polymer_counts
#     |> Map.keys()
#     |> Enum.reduce(%{}, fn pair, single_counts ->
#       count = polymer_counts[pair] / 4

#       pair
#       |> String.split("", trim: true)
#       |> Enum.reduce(single_counts, fn poly, next_counts ->
#         first_addition = Map.put(next_counts, poly, Map.get(next_counts, poly, 0) + count)
#         Map.put(first_addition, poly, Map.get(first_addition, poly, 0) + count)
#       end)
#     end)
#   end

#   defp element_difference(poly_counts) do
#     vals = Map.values(poly_counts)

#     round(Enum.max(vals)) - round(Enum.min(vals))
#   end

#   defp generate_initial_counts({start_poly, insert_commands}) do
#     blank_counts =
#       insert_commands
#       |> Map.keys()
#       |> Enum.reduce(%{}, fn pair, blank_counts ->
#         Map.put(blank_counts, pair, 0)
#       end)

#     {
#       start_poly
#       |> Enum.chunk_every(2, 1, :discard)
#       |> Enum.reduce(blank_counts, fn [first, second], initial_counts ->
#         last_pair_val = Map.get(initial_counts, first <> second, 0)
#         Map.put(initial_counts, first <> second, last_pair_val + 1)
#       end),
#       insert_commands
#     }
#   end

#   defp grow({polymer_counts, _insert_commands}, 0), do: polymer_counts

#   defp grow({current_frequencies, insert_commands}, steps) do
#     next_counts =
#       current_frequencies
#       |> Map.keys()
#       |> Enum.reduce(%{}, fn key, next_poly_counts ->
#         middle = insert_commands[key]
#         [first, second] = String.split(key, "", trim: true)
#         {first_key, second_key} = {first <> middle, middle <> second}
#         additions = current_frequencies[key]
#         last_val1 = Map.get(next_poly_counts, first_key, 0)
#         last_val2 = Map.get(next_poly_counts, second_key, 0)

#         next_poly_counts
#         |> Map.put(first_key, last_val1 + additions)
#         |> Map.put(second_key, last_val2 + additions)
#       end)

#     grow({next_counts, insert_commands}, steps - 1)
#   end

#   defp parse_input(path) do
#     [start | insert_commands] =
#       path
#       |> FileReader.read()
#       |> FileReader.clean_content()

#     {
#       String.split(start, "", trim: true),
#       insert_commands
#       |> Enum.reduce(%{}, fn command, acc ->
#         [pair, insert] = String.split(command, " -> ", trim: true)
#         Map.put(acc, pair, insert)
#       end)
#     }
#   end
# end
