defmodule Day12 do
  @moduledoc """
  Day 12 puzzle solutions
  """

  @start_node "start"
  @end_node "end"

  @doc """
      * `:part` - Possible values: `1` or `2`. Represents both parts of the puzzle.
      * `:file_path` - When defined, the graph edges are read from this file instead of the next option.
      * `:edges` - Graph edges.
  """
  @spec solve(Keyword.t()) :: integer()
  def solve(part: part, file_path: file_path) do
    edges = read_edges(file_path)

    solve(part: part, edges: edges)
  end

  def solve(part: 1, edges: edges) do
    edges
    |> build_graph()
    |> find_all_paths()
    |> Enum.count()
  end

  defp read_edges(file_path) do
    file_path
    |> FileReader.read()
    |> FileReader.clean_content()
  end

  defp build_graph(edges) do
    edges
    |> Enum.map(fn edge ->
      [from, to] = String.split(edge, "-", trim: true)

      [{from, to}, {to, from}]
    end)
    |> List.flatten()
  end

  defp find_all_paths(edges) do
    traverse(@start_node, [], edges)
  end

  defp traverse(@end_node, visited_nodes, _edges), do: [[@end_node] ++ visited_nodes]

  defp traverse(current_node, visited_nodes, edges) do
    current_node
    |> find_all_next_nodes(visited_nodes, edges)
    |> Enum.reduce([], fn next_node, paths ->
      traverse(next_node, [current_node] ++ visited_nodes, edges) ++ paths
    end)
  end

  defp find_all_next_nodes(node, visited_nodes, edges) do
    edges
    |> Enum.filter(&(elem(&1, 0) == node))
    |> Enum.map(&elem(&1, 1))
    |> Enum.filter(&can_move_into?(&1, visited_nodes))
  end

  defp can_move_into?(next_node, visited_nodes) do
    next_node not in visited_nodes or not is_small_cave?(next_node)
  end

  defp is_small_cave?(next_node) do
    next_node == String.downcase(next_node)
  end
end
