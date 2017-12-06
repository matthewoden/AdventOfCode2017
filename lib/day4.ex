defmodule AoC.Day4 do
    
    @moduledoc """
    Note: line_reducer is a cleaned up version of my file reader from day two. See
    `AoC` at the root, (aka `advent_of_code.ex`) It takes a seperator, and a reduce callback (with initial state)

    For part one, we just need to check if a word exists on the line. 
    unique map solves this, adding a new key or quitting.

    For part two, needed to compare anagrams or words. I wrote a recursive quicksort, 
    and compared the sorted values of keys, following the solution of part one.
    """

    #binary quicksort! All this binary typing can make this hard to read.
    def sort(""), do: ""
    def sort(<< head :: utf8, tail :: binary >>) do
        {lesser, greater} = partition(tail, head, { "", "" })
        << sort(lesser) :: binary, head :: utf8, sort(greater) :: binary >>
    end

    def partition("", _value, result), do: result
    def partition(<< head :: utf8, tail :: binary >>, value, {greater, lesser}) do
        cond do
            value > head -> 
                partition(tail, value, {<< head :: utf8, greater :: binary, >>, lesser})
            true -> 
                partition(tail, value, {greater, << lesser :: binary, head :: utf8 >>})
        end
    end

    # make a unique map, or return a call to exit the line (see AoC.reduce_line).
    def unique_map(value, map) do
        case Map.has_key?(map, value) do
            true -> {:exit, false}
            _ ->    Map.put(map, value, true)
        end
    end

    #-------------------------------------

    @sep 32 # space charcode seperator, as our lines are space delimited.
    def part_1 do
        AoC.stream!("day4-1")
        |> AoC.reduce_line(@sep, %{}, fn (word, map) -> unique_map(word, map) end)
        |> Enum.count(fn x -> x end)
    end

    def part_2 do
        AoC.stream!("day4-1")
        |> AoC.reduce_line(@sep, %{}, fn (word, map) -> unique_map(sort(word), map) end)
        |> Enum.count(fn x -> x end)
    end

end