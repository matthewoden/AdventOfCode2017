defmodule AoC.Day4 do
    
    @moduledoc """
    Moved The linereader from day 2 into it's own module. Now we have a word
    reducer!

    For part one, checked if the key existed.
    For part two, abstracted the key check to a composable call, and wrote a
    recursive quicksort.

    """

    #binary quicksort!
    def sort(""), do: ""
    def sort(<< head :: utf8, tail :: binary >>) do
        {lesser, greater} = partition(tail, head, { "", "" })
        << sort(lesser) :: binary, head :: utf8, sort(greater) :: binary >>
    end

    def partition("", _value, result), do: result
    def partition(<< head :: utf8, tail :: binary >>, value, {greater, lesser}) do
        cond do
            value > head -> partition(tail, value, {<< head :: utf8, greater :: binary, >>, lesser})
            true -> partition(tail, value, {greater, << lesser :: binary, head :: utf8 >>})
        end
    end

    # make a unique map, or exit.
    def unique_map(value, map) do
        if Map.has_key?(map, value) do
            true -> {:exit, false}
            _ ->    Map.put(map, value, true)
        end
    end

    #-------------------------------------

    @sep 32 # space charcode
    def part_1 do
        AoC.stream!("day4-1")
        |> AoC.read_line(@sep, %{}, fn (curr, map) -> unique_map(curr, map) end)
        |> Stream.filter(fn x -> x end)
        |> Enum.count()
    end

    def part_2 do
        AoC.stream!("day4-1")
        |> AoC.read_line(@sep, %{}, fn (curr, map) -> unique_map(sort(curr), map) end)
        |> Stream.filter(fn x -> x end)
        |> Enum.count()
    end

end