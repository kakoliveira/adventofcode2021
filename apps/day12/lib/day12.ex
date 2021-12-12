defmodule Day12 do
  @moduledoc """
  Day 12 puzzle solutions
  """

  @start_node "start"
  @end_node "end"

  defguard is_terminal_node?(node) when node in [@start_node, @end_node]

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

  def solve(part: 2, edges: edges) do
    edges
    |> build_graph()
    |> find_all_paths(can_visit_one_small_cave_twice: true)
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

  defp find_all_paths(edges, opts \\ []) do
    traverse(@start_node, [@start_node], edges, opts)
  end

  defp traverse(@end_node, visited_nodes, _edges, _opts), do: [visited_nodes]

  defp traverse(current_node, visited_nodes, edges, opts) do
    current_node
    |> find_all_next_nodes(visited_nodes, edges, opts)
    |> Enum.reduce([], fn next_node, paths ->
      traverse(next_node, [next_node] ++ visited_nodes, edges, opts) ++ paths
    end)
  end

  defp find_all_next_nodes(node, visited_nodes, edges, opts) do
    edges
    |> Enum.filter(&(elem(&1, 0) == node))
    |> Enum.map(&elem(&1, 1))
    |> Enum.filter(&can_move_into?(&1, visited_nodes, opts))
  end

  defp can_move_into?(@start_node, _visited_nodes, _opts), do: false

  defp can_move_into?(next_node, visited_nodes, opts) do
    can_visit_one_small_cave_twice? = Keyword.get(opts, :can_visit_one_small_cave_twice, false)

    not already_visited?(next_node, visited_nodes) or
      not is_small_cave?(next_node) or
      (can_visit_one_small_cave_twice? and
         not has_moved_into_small_cave_twice?(visited_nodes))
  end

  defp already_visited?(next_node, visited_nodes), do: next_node in visited_nodes

  defp is_small_cave?(node), do: node == String.downcase(node)

  defp has_moved_into_small_cave_twice?(visited_nodes) do
    visited_nodes
    |> Enum.filter(fn visited_node ->
      not is_terminal_node?(visited_node) and is_small_cave?(visited_node)
    end)
    |> Enum.frequencies()
    |> Enum.any?(fn {_node, count} ->
      count > 1
    end)
  end
end
