defmodule AoC.Day5 do

    @moduledoc """
    Jump maze!

    Part one, we get the position and increment.

    Part two added conditions around the offset, so I provided a callback
    function to determine the requirements.

    Not O(n) today, but it's random access traversal, so eh.
    """

    def create(value, state) do
        new_size = state.size + 1
        state |> Map.put(:size, new_size) |> Map.put(new_size, value)
    end

    def move(%{size: size}, position, steps, _fun) when size < position, do: steps
    def move(_state, position, steps, _fun) when position < 0, do: steps
    def move(state, position, steps, fun) do
        instruction = Map.get(state, position)
        leave_behind = fun.(instruction)
        next_position = position + instruction
        state = Map.replace(state, position, leave_behind)

        move(state, next_position, steps + 1, fun)
    end

    def input do
        AoC.stream!("day5-1")
        |> AoC.reduce_line(?\n, %{}, fn (word, _) -> String.to_integer(word) end)
        |> Enum.reduce(%{size: -1}, &create(&1, &2))
    end

    def part_1 do
        input() |> move(0, 0, fn (a) -> a + 1 end)
    end

    def part_2 do
        input() |> move(0, 0, fn (a) -> if a > 2, do: a - 1, else: a + 1 end)
    end
end
