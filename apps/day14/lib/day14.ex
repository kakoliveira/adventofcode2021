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
      pair_insertion_rules: Enum.map(rules, &parse_rule/1)
    }
  end

  defp parse_rule(rule) do
    [pair, insertion] = String.split(rule, " -> ", trim: true)

    {pair, insertion}
  end

  defp compute_polymer(template, rules, steps) do
    last_element = List.last(template)

    template
    |> Enum.chunk_every(2, 1, :discard)
    |> Enum.map(&run_for_chunk(&1, steps, rules))
    |> Enum.reduce(%{}, &Map.merge(&1, &2, fn _key, count1, count2 -> count1 + count2 end))
    |> Map.update!(last_element, &(&1 + 1))
  end

  defp run_for_chunk(chunk, steps, rules) do
    Enum.reduce(1..steps, [chunk], fn _step, template ->
      pair_insertion_process(template, rules)
    end)
    |> unchunk()
    |> Enum.frequencies()
  end

  defp pair_insertion_process(template, rules) do
    template
    |> Enum.reduce([], fn pair, acc ->
      apply_rules_to_pair(pair, rules) ++ acc
    end)
    |> Enum.reverse()
  end

  defp apply_rules_to_pair([element1, element2] = pair, rules) do
    element_to_insert = get_element_to_insert(pair, rules)

    if is_nil(element_to_insert) do
      [pair]
    else
      [[element_to_insert, element2], [element1, element_to_insert]]
    end
  end

  defp get_element_to_insert(pair, rules) do
    pair = Enum.join(pair)

    rules
    |> Enum.find(&rule_applies?(&1, pair))
    |> get_element_to_insert()
  end

  defp get_element_to_insert({_rule_pair, element_to_insert}), do: element_to_insert
  defp get_element_to_insert(_rule), do: nil

  defp rule_applies?({target_pair, _element_to_insert}, pair) do
    target_pair == pair
  end

  defp unchunk(chunked_template) do
    Enum.map(chunked_template, &List.first/1)
  end

  defp subtract_element_quantities({
         {_least_common_element, least_common_quantity},
         {_most_common_element, most_common_quantity}
       }) do
    most_common_quantity - least_common_quantity
  end
end
