defmodule AoC.Day7 do


    @moduledoc """
    MEssing around with digraph.
    """

    @sep 32 # space charcode seperator, as our lines are space delimited.
    @tree %{node: nil, weight: nil, parents: []}


    def to_node([], state), do: state
    
    def to_node([node | tail], %{ node: nil } = state) do
        to_node(tail, %{state | node: node})
    end
    
    def to_node([ weight | tail], %{ weight: nil } = state) do
        to_node(tail, %{state | weight: String.to_integer(weight)})
    end

    def to_node([head | tail], state) do
        to_node(tail, %{state | parents: [ head | state.parents ] })
    end

    def parse_line(line) do
        pattern = :binary.compile_pattern([" ", "(", ")", "->", ",", "\n"])   
        line |> String.split(pattern, trim: true) |> to_node(@tree)
    end

    # -----------------------------------


    def create_graph(state, acc, graph) do
        :digraph.add_vertex(graph, state.node)

        Enum.each(state.parents, fn (parent) -> 
            :digraph.add_vertex(graph, parent)
            :digraph.add_edge(graph, state.node, parent)
        end)

        Map.put(acc, state.node, %{ weight: state.weight, parents: state.parents })
    end

    def form_tree() do
        graph = :digraph.new()
        
        state = 
            AoC.stream!("day7-1")
            |> Stream.map(&parse_line(&1))
            |> Enum.reduce(&create_graph(&1, &2, graph))

        {graph, state}
    end

    def part_1 do
        {graph, _} = form_tree()
        {_ , root} = :digraph_utils.arborescence_root(graph)
        root
    end

end