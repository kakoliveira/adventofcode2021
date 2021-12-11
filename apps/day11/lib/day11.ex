defmodule Day11 do
  @moduledoc """
  Day 11 puzzle solutions
  """

  alias Util.Matrix

  @doc """
      * `:part` - Possible values: `1` or `2`. Represents both parts of the puzzle.
      * `:file_path` - When defined, the octopus energy levels are read from this file instead of the next option.
      * `:octopus_energy_levels` - Octopus energy levels.
  """

  @spec solve(Keyword.t()) :: integer()
  def solve(part: part, file_path: file_path) do
    octopus_energy_levels = read_octopus_energy_levels(file_path)

    solve(part: part, octopus_energy_levels: octopus_energy_levels)
  end

  def solve(part: 1, octopus_energy_levels: octopus_energy_levels) do
    octopus_energy_levels
    |> parse_energy_matrix()
    |> simulate(100)
    |> Map.get(:number_of_flashes)
  end

  def solve(part: 2, octopus_energy_levels: octopus_energy_levels) do
    octopus_energy_levels
    |> parse_energy_matrix()
    |> find_sync_step()
  end

  defp read_octopus_energy_levels(file_path) do
    file_path
    |> FileReader.read()
    |> FileReader.clean_content()
  end

  defp parse_energy_matrix(octopus_energy_levels) do
    Matrix.parse_matrix(octopus_energy_levels, to_integer: true)
  end

  defp simulate(energy_matrix, steps) do
    state = %{
      energy_matrix: energy_matrix,
      number_of_flashes: 0
    }

    Enum.reduce(1..steps, state, fn _step, state ->
      simulate_step(state)
    end)
  end

  defp find_sync_step(energy_matrix) do
    state = %{
      energy_matrix: energy_matrix,
      number_of_flashes: 0
    }

    {_energy_matrix, num_rows, num_columns} = Matrix.describe(energy_matrix)

    find_sync_step(state, 1, num_rows * num_columns)
  end

  defp find_sync_step(state, step, target_number_of_flashes) do
    updated_state = simulate_step(state)

    number_of_flashes_on_step = updated_state.number_of_flashes - state.number_of_flashes

    if number_of_flashes_on_step == target_number_of_flashes do
      step
    else
      find_sync_step(updated_state, step + 1, target_number_of_flashes)
    end
  end

  defp simulate_step(state) do
    state
    |> increase_all(1)
    |> flashes()
  end

  defp increase_all(state, amount) do
    Map.update!(state, :energy_matrix, fn energy_matrix ->
      Enum.map(energy_matrix, fn row ->
        Enum.map(row, &(&1 + amount))
      end)
    end)
  end

  defp flashes(state) do
    {_energy_matrix, num_rows, num_columns} = Matrix.describe(state.energy_matrix)

    updated_state =
      Enum.reduce(0..(num_rows - 1), state, fn row_index, state ->
        Enum.reduce(0..(num_columns - 1), state, fn column_index, state ->
          state.energy_matrix
          |> Matrix.get_point(row_index, column_index)
          |> handle_flash(state, num_rows, num_columns)
        end)
      end)

    if updated_state.number_of_flashes == state.number_of_flashes do
      updated_state
    else
      flashes(updated_state)
    end
  end

  defp handle_flash({current_energy, row_index, column_index}, state, num_rows, num_columns)
       when current_energy >= 10 do
    state
    |> Map.update!(:number_of_flashes, &(&1 + 1))
    |> Map.update!(:energy_matrix, fn energy_matrix ->
      energy_matrix
      |> Matrix.set(row_index, column_index, 0)
      |> increment_neighbours(row_index, column_index, num_rows, num_columns)
    end)
  end

  defp handle_flash(_point, state, _num_rows, _num_columns), do: state

  defp increment_neighbours(
         energy_matrix,
         pivot_row_index,
         pivot_column_index,
         num_rows,
         num_columns
       ) do
    from_row = max(pivot_row_index - 1, 0)
    to_row = min(pivot_row_index + 1, num_rows - 1)

    from_column = max(pivot_column_index - 1, 0)
    to_column = min(pivot_column_index + 1, num_columns - 1)

    Enum.reduce(from_row..to_row, energy_matrix, fn row_index, energy_matrix ->
      Enum.reduce(from_column..to_column, energy_matrix, fn column_index, energy_matrix ->
        energy_matrix
        |> Matrix.get_point(row_index, column_index)
        |> increment_neighbour(energy_matrix)
      end)
    end)
  end

  defp increment_neighbour({0, _row_index, _column_index}, energy_matrix), do: energy_matrix

  defp increment_neighbour({energy, row_index, column_index}, energy_matrix) do
    Matrix.set(energy_matrix, row_index, column_index, energy + 1)
  end
end
