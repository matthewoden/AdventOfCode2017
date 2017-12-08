defmodule AoC.Day6 do
    
    @moduledoc """
    Reallocation of memory banks.

    This probably could have been a recusive problem with a list, but my brain
    was in "random access = maps!" mode.

    Formatting the file was about as large as the whole damn solution,
    ...so, I'm not loving it.
    """    
    @state %{banks: %{} , size: 0, largest: -1 }
    @seen MapSet.new
   
    def find_loop(state, seen \\ @seen) do
        banks = Map.values(state.banks)
        if MapSet.member?(seen, banks) do
            {banks, MapSet.size(seen) }
        else
            find_loop(distribute(state), MapSet.put(seen, banks))
        end
    end

    def ranges(%{size: size, largest: largest}) when (largest + 1) > size, do: [0..size]
    def ranges(%{size: size, largest: largest}), do: [(largest + 1)..size, 0..largest]

    def distribute(state) do
        value = Map.get(state.banks, state.largest)
        state = put_in(state, [:banks, state.largest], 0)
        
        Stream.concat(ranges(state))
        |> Stream.cycle()
        |> Stream.take(value)
        |> Enum.reduce(state, &increment_bank/2)
    end

    def increment_bank(key, state) do
        state
        |> put_in([:banks, key], state[:banks][key] + 1)
        |> update_largest()
    end

    def update_largest(state) do
        {index,_} = Enum.to_list(state.banks) |> Enum.max_by(fn {_, val}-> val end)
        Map.put(state, :largest, index)
    end

    
    def input(file) do
        AoC.stream!(file)
        |> AoC.reduce_line(?\t, [], fn (val, acc) -> [String.to_integer(val) | acc] end)
        |> Stream.concat()
        |> Enum.reverse()
        |> Enum.with_index()
        |> Enum.reduce(@state, fn
            ({val, i}, state) ->
                state
                |> put_in([:banks, i], val)
                |> Map.put(:size, i)
            end)
        |> update_largest()
    end

    def part_1 do
        input("day6-1") |> find_loop()
    end

    def part_2 do
        input("day6-2") |> find_loop()
    end
end