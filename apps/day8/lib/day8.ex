defmodule Day8 do
  @moduledoc """
  Day 8 puzzle solutions
  """

  @top_display_segment :top
  @top_left_display_segment :top_left
  @top_right_display_segment :top_right
  @middle_display_segment :middle
  @bottom_left_display_segment :bottom_left
  @bottom_right_display_segment :bottom_right
  @bottom_display_segment :bottom

  @initial_configuration [
    {[], @top_display_segment},
    {[], @top_left_display_segment},
    {[], @top_right_display_segment},
    {[], @middle_display_segment},
    {[], @bottom_left_display_segment},
    {[], @bottom_right_display_segment},
    {[], @bottom_display_segment}
  ]

  @num_configurations length(@initial_configuration)

  @length_5_criteria :length5
  @length_6_criteria :length6
  @all_criterias [@length_5_criteria, @length_6_criteria]

  # Guards
  defguard is_digit_1?(segment) when byte_size(segment) == 2
  defguard is_digit_4?(segment) when byte_size(segment) == 4
  defguard is_digit_7?(segment) when byte_size(segment) == 3
  defguard is_digit_8?(segment) when byte_size(segment) == 7

  defguard is_unique_segment?(segment)
           when is_digit_1?(segment) or is_digit_4?(segment) or is_digit_7?(segment) or
                  is_digit_8?(segment)

  @doc """
      * `:part` - Possible values: `1` or `2`. Represents both parts of the puzzle.
      * `:file_path` - When defined, signal patterns are read from this file instead of the next option.
      * `:signal_patterns` - List of signal patterns.
  """
  @spec solve(Keyword.t()) :: integer()
  def solve(part: part, file_path: file_path) do
    signal_patterns = read_signal_patterns(file_path)

    solve(part: part, signal_patterns: signal_patterns)
  end

  def solve(part: 1, signal_patterns: signal_patterns) do
    signal_patterns
    |> parse_signal_patterns()
    |> count_unique_number_of_output_segments()
  end

  def solve(part: 2, signal_patterns: signal_patterns) do
    signal_patterns
    |> parse_signal_patterns()
    |> Enum.map(&decode_signal/1)
    |> Enum.sum()
  end

  defp read_signal_patterns(file_path) do
    file_path
    |> FileReader.read()
    |> FileReader.clean_content()
  end

  defp parse_signal_patterns(signal_patterns) do
    Enum.map(signal_patterns, &parse_signal_pattern/1)
  end

  defp parse_signal_pattern(signal_pattern) do
    [signal, output] =
      signal_pattern
      |> String.split(" | ", trim: true)
      |> Enum.map(&String.split(&1, " ", trim: true))

    {signal, output}
  end

  defp count_unique_number_of_output_segments(signal_patterns) do
    signal_patterns
    |> Enum.map(&elem(&1, 1))
    |> Enum.reduce(0, fn output_segment, count ->
      count + Enum.count(output_segment, &is_unique_segment?/1)
    end)
  end

  defp decode_signal({_pattern, output} = signal_pattern) do
    signal_pattern
    |> deduce_configuration()
    |> then(&decode_output(output, &1))
  end

  defp deduce_configuration({pattern, output}) do
    {unique_segments, remaining_segments} =
      Enum.split_with(pattern ++ output, &is_unique_segment?/1)

    @initial_configuration
    |> apply_unique_segments(unique_segments)
    |> deduce_configuration(remaining_segments)
  end

  defp deduce_configuration(configuration, remaining_segments) do
    if all_configs_are_set?(configuration) do
      configuration
    else
      recursive_configuration_deduction(configuration, remaining_segments)
    end
  end

  defp apply_unique_segments(configuration, unique_segments) do
    Enum.reduce(unique_segments, configuration, fn unique_segment, config ->
      unique_segment
      |> String.split("", trim: true)
      |> then(&add_config_possibilities(config, &1, unique_segment))
    end)
  end

  defp add_config_possibilities(configuration, possibilities, unique_segment)
       when is_digit_1?(unique_segment) do
    configuration
    |> set_possibilities_for_display_segment(@top_right_display_segment, possibilities)
    |> set_possibilities_for_display_segment(@bottom_right_display_segment, possibilities)
  end

  defp add_config_possibilities(configuration, possibilities, unique_segment)
       when is_digit_4?(unique_segment) do
    configuration
    |> set_possibilities_for_display_segment(@top_right_display_segment, possibilities)
    |> set_possibilities_for_display_segment(@top_left_display_segment, possibilities)
    |> set_possibilities_for_display_segment(@middle_display_segment, possibilities)
    |> set_possibilities_for_display_segment(@bottom_right_display_segment, possibilities)
  end

  defp add_config_possibilities(configuration, possibilities, unique_segment)
       when is_digit_7?(unique_segment) do
    configuration
    |> set_possibilities_for_display_segment(@top_display_segment, possibilities)
    |> set_possibilities_for_display_segment(@top_right_display_segment, possibilities)
    |> set_possibilities_for_display_segment(@bottom_right_display_segment, possibilities)
  end

  defp add_config_possibilities(configuration, possibilities, unique_segment)
       when is_digit_8?(unique_segment) do
    configuration
    |> set_possibilities_for_display_segment(@middle_display_segment, possibilities)
    |> set_possibilities_for_display_segment(@top_display_segment, possibilities)
    |> set_possibilities_for_display_segment(@top_right_display_segment, possibilities)
    |> set_possibilities_for_display_segment(@top_left_display_segment, possibilities)
    |> set_possibilities_for_display_segment(@bottom_right_display_segment, possibilities)
    |> set_possibilities_for_display_segment(@bottom_left_display_segment, possibilities)
    |> set_possibilities_for_display_segment(@bottom_display_segment, possibilities)
  end

  defp add_config_possibilities(configuration, _possibilities, _unique_segment), do: configuration

  defp set_possibilities_for_display_segment(configuration, key, possibilities) do
    {current_possibilities, ^key} = List.keyfind(configuration, key, 1)

    set_possibilities_for_display_segment(
      configuration,
      key,
      current_possibilities,
      possibilities
    )
  end

  defp set_possibilities_for_display_segment(configuration, key, [], possibilities) do
    List.keyreplace(configuration, key, 1, {possibilities, key})
  end

  defp set_possibilities_for_display_segment(
         configuration,
         _key,
         [current_possibility],
         possibilities
       ) do
    if current_possibility in possibilities do
      configuration
    else
      raise ArgumentError
    end
  end

  defp set_possibilities_for_display_segment(
         configuration,
         key,
         current_possibilities,
         possibilities
       ) do
    remaining_possibilities = Enum.reject(current_possibilities, &(&1 not in possibilities))

    List.keyreplace(configuration, key, 1, {remaining_possibilities, key})
  end

  defp all_configs_are_set?(configuration) do
    Enum.all?(configuration, fn {option, _key} ->
      is_binary(option)
    end)
  end

  defp recursive_configuration_deduction(configuration, remaining_segments) do
    configuration
    |> sort_configuration()
    |> fix_possibility(remaining_segments)
    |> deduce_configuration(remaining_segments)
  end

  defp sort_configuration(configuration) do
    Enum.sort_by(
      configuration,
      &sort_configuration_mapper/1,
      &sort_configuration_sorter/2
    )
  end

  defp sort_configuration_mapper({possibilities, key}) when is_list(possibilities) do
    {length(possibilities), key}
  end

  defp sort_configuration_mapper({_possibilities, key}) do
    # this one is picked, move it to the end
    {@num_configurations + 1, key}
  end

  defp sort_configuration_sorter({length, key1}, {length, key2}) do
    sort_config_keys(key1, key2)
  end

  defp sort_configuration_sorter({length1, _key1}, {length2, _key2}) do
    length1 <= length2
  end

  defp fix_possibility([{possibilities, key} | _rest] = configuration, remaining_segments) do
    fixed_possibility = pick_possibility(possibilities, key, remaining_segments)

    configuration
    |> List.keyreplace(key, 1, {fixed_possibility, key})
    |> Enum.map(&reject_chosen_possibility(&1, fixed_possibility))
  end

  # top -> all others must have the possibility || first
  # top_right -> first
  # top_left -> all 6 length must have it || first
  # middle -> all 5 length must have it || first
  # bottom_left -> first
  # bottom_right -> all 6 length must have it || first
  # bottom -> all others must have it || first
  # this implies an order -> middle -> top_left, bottom_right -> top, bottom -> top_right, bottom
  defp sort_config_keys(key1, key2) do
    key1 <= key2
  end

  defp pick_possibility(possibilities, key, remaining_segments)
       when key in [@top_display_segment, @bottom_display_segment] do
    filter_possibilities(possibilities, @all_criterias, remaining_segments)
  end

  defp pick_possibility(possibilities, @middle_display_segment, remaining_segments) do
    filter_possibilities(possibilities, [@length_5_criteria], remaining_segments)
  end

  defp pick_possibility(possibilities, key, remaining_segments)
       when key in [@top_left_display_segment, @bottom_right_display_segment] do
    filter_possibilities(possibilities, [@length_6_criteria], remaining_segments)
  end

  defp pick_possibility(possibilities, _key, _remaining_segments) do
    List.first(possibilities)
  end

  defp filter_possibilities([possibility], _criteria_list, _remaining_segments),
    do: possibility

  defp filter_possibilities(possibilities, criteria_list, remaining_segments) do
    criteria_list
    |> Enum.reduce(possibilities, &apply_criteria(&2, &1, remaining_segments))
    |> List.first()
  end

  defp apply_criteria(possibilities, @length_5_criteria, remaining_segments) do
    Enum.filter(possibilities, &all_remaining_segments?(remaining_segments, 5, &1))
  end

  defp apply_criteria(possibilities, @length_6_criteria, remaining_segments) do
    Enum.filter(possibilities, &all_remaining_segments?(remaining_segments, 6, &1))
  end

  defp apply_criteria(possibilities, _criteria, _remaining_segments), do: possibilities

  defp all_remaining_segments?(remaining_segments, target_length, possibility) do
    remaining_segments
    |> Enum.filter(&(String.length(&1) == target_length))
    |> Enum.all?(&String.contains?(&1, possibility))
  end

  defp reject_chosen_possibility({possibilities, key}, fixed_possibility)
       when is_list(possibilities) do
    {Enum.reject(possibilities, &(&1 == fixed_possibility)), key}
  end

  defp reject_chosen_possibility(config_item, _fixed_possibility), do: config_item

  @spec decode_output(list(String.t()), list(tuple())) :: integer()
  def decode_output(output, configuration) when length(configuration) == @num_configurations do
    output
    |> Enum.map_join(&decode_digit(&1, configuration))
    |> String.to_integer()
  end

  defp decode_digit(digit_segment, configuration) when is_binary(digit_segment) do
    if is_unique_segment?(digit_segment) do
      decode_unique_digit(digit_segment)
    else
      digit_segment
      |> String.split("", trim: true)
      |> decode_digit(configuration)
    end
  end

  defp decode_digit(digit_signals, configuration) do
    digit_signals
    |> Enum.reduce([], fn signal, acc ->
      configuration
      |> List.keyfind(signal, 0)
      |> elem(1)
      |> List.wrap()
      |> Kernel.++(acc)
    end)
    |> interpret_display()
  end

  defp decode_unique_digit(unique_digit_segment) when is_digit_1?(unique_digit_segment), do: 1
  defp decode_unique_digit(unique_digit_segment) when is_digit_4?(unique_digit_segment), do: 4
  defp decode_unique_digit(unique_digit_segment) when is_digit_7?(unique_digit_segment), do: 7
  defp decode_unique_digit(unique_digit_segment) when is_digit_8?(unique_digit_segment), do: 8
  defp decode_unique_digit(_unique_digit_segment), do: raise(ArgumentError)

  defp interpret_display(active_display_segments) do
    cond do
      is_digit_0?(active_display_segments) ->
        0

      is_digit_2?(active_display_segments) ->
        2

      is_digit_3?(active_display_segments) ->
        3

      is_digit_5?(active_display_segments) ->
        5

      is_digit_6?(active_display_segments) ->
        6

      is_digit_9?(active_display_segments) ->
        9

      true ->
        raise ArgumentError
    end
  end

  defp is_digit_0?(active_display_segments) do
    length(active_display_segments) == 6 and
      @middle_display_segment not in active_display_segments
  end

  defp is_digit_2?(active_display_segments) do
    length(active_display_segments) == 5 and
      @top_left_display_segment not in active_display_segments and
      @bottom_right_display_segment not in active_display_segments
  end

  defp is_digit_3?(active_display_segments) do
    length(active_display_segments) == 5 and
      @top_left_display_segment not in active_display_segments and
      @bottom_left_display_segment not in active_display_segments
  end

  defp is_digit_5?(active_display_segments) do
    length(active_display_segments) == 5 and
      @top_right_display_segment not in active_display_segments and
      @bottom_left_display_segment not in active_display_segments
  end

  defp is_digit_6?(active_display_segments) do
    length(active_display_segments) == 6 and
      @top_right_display_segment not in active_display_segments
  end

  defp is_digit_9?(active_display_segments) do
    length(active_display_segments) == 6 and
      @bottom_left_display_segment not in active_display_segments
  end
end
