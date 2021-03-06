defmodule Day2 do
  @moduledoc """
  Day 2 puzzle solutions
  """

  @doc """
      * `:part` - Possible values: `1` or `2`. Represents both parts of the puzzle.
      * `:file_path` - When defined, commands are read from this file instead of the next option.
      * `:commands` - List of commands.
  """
  @spec solve(Keyword.t()) :: integer()
  def solve(part: part, file_path: file_path) do
    commands = read_commands(file_path)

    solve(part: part, commands: commands)
  end

  def solve(part: 1, commands: commands) do
    calculate_position(commands)
  end

  def solve(part: 2, commands: commands) do
    calculate_position(commands, with_aim: true)
  end

  defp read_commands(file_path) do
    file_path
    |> FileReader.read()
    |> FileReader.clean_content()
  end

  defp calculate_position(commands, opts \\ []) do
    %{depth: depth, horizontal_position: horizontal_position} = parse_commands(commands, opts)

    depth * horizontal_position
  end

  defp parse_commands(commands, with_aim: true) do
    state = %{depth: 0, horizontal_position: 0, aim: 0}

    Enum.reduce(commands, state, &compute_command_with_aim/2)
  end

  defp parse_commands(commands, _opts) do
    state = %{depth: 0, horizontal_position: 0}

    Enum.reduce(commands, state, &compute_command/2)
  end

  defp compute_command("forward " <> amount, state) do
    amount = Util.safe_to_integer(amount, 0)
    %{state | horizontal_position: state.horizontal_position + amount}
  end

  defp compute_command("down " <> amount, state) do
    amount = Util.safe_to_integer(amount, 0)
    %{state | depth: state.depth + amount}
  end

  defp compute_command("up " <> amount, state) do
    amount = Util.safe_to_integer(amount, 0)
    %{state | depth: state.depth - amount}
  end

  defp compute_command_with_aim("forward " <> amount, state) do
    amount = Util.safe_to_integer(amount, 0)

    new_depth = calculate_depth(amount, state)

    %{state | horizontal_position: state.horizontal_position + amount, depth: new_depth}
  end

  defp compute_command_with_aim("down " <> amount, state) do
    amount = Util.safe_to_integer(amount, 0)

    %{state | aim: state.aim + amount}
  end

  defp compute_command_with_aim("up " <> amount, state) do
    amount = Util.safe_to_integer(amount, 0)

    %{state | aim: state.aim - amount}
  end

  defp calculate_depth(forward_amount, %{
         depth: current_depth,
         aim: current_aim
       }) do
    current_depth + forward_amount * current_aim
  end
end
