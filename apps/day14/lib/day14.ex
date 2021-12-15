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
