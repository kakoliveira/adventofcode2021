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

  defp read_commands(file_path) do
    file_path
    |> FileReader.read()
    |> FileReader.clean_content()
  end

  defp calculate_position(commands) do
    %{depth: depth, horizontal_position: horizontal_position} = parse_commands(commands)

    depth * horizontal_position
  end

  defp parse_commands(commands) do
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
end
