defmodule AoC.Day2 do

    # nested reduce: builds an integer, then then runs a reducer on an integers 
    # as it's created. Also allows for early exit from recursion.

    def read_line(_, _, {:exit, state}, _), do: state
    def read_line(input, acc, state, parser) do
        case input do
            "" ->
                state

            <<value, tail :: binary >>  when value in [?\t, ?\n] ->
                num = String.to_integer(acc)               
                state = parser.(num, state)

                read_line(tail, "", state, parser)
                
            <<head ::size(8), tail :: binary >> ->
                acc = << acc :: binary, head :: size(8) >>

                read_line(tail, acc, state, parser)
        end 
    end
    
    # ------------------------------------------------------------

    def part_1 do
        AoC.stream!("day2-1") 
        |> Stream.map(&get_range/1)
        |> Stream.map(fn {max, min} -> max - min end)
        |> Enum.sum()
    end

    def part_2 do
        AoC.stream!("day2-1") 
        |> Stream.map(&get_clean_divisors/1) 
        |> Enum.sum()
    end


    #part1
    def get_range(row) do
        read_line(row, "", {0, :infinity}, fn 
            val, {large, small} -> { max(large, val), min(small, val) }
        end)
    end 

    # part2
    def get_clean_divisors(row) do
        read_line(row, "", [], fn 
            num, list ->
                case clean_quotient?(num, list) do
                    nil ->  [ num | list ] 
                    value -> {:exit, value}
                end
        end)
    end
   
    def clean_quotient?(_num, []), do: nil
    def clean_quotient?(num, [head | _tail]) when rem(head, num) == 0, do: div(head, num)
    def clean_quotient?(num, [head | _tail]) when rem(num, head) == 0, do: div(num, head)
    def clean_quotient?(num, [_head | tail]), do: clean_quotient?(num, tail)

end