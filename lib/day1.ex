defmodule AoC.Day1 do

    @moduledoc """
    Is it efficient? Kind of! But it's an excuse to play with binary strings.
    """


    def part_1 do
        AoC.read!("day1-1") |> match(nil, 0, nil)
    end



    defp match("", prior, sum, first) when prior == first do
        sum + char_to_int(prior)
    end
    
    defp match(<<head ::size(8), tail :: binary >>, _, sum, nil) do
        match(tail, head, sum, head)  
    end

    defp match(<<head ::size(8), tail :: binary >>, prior, sum, first) when head == prior do
        match(tail, head, char_to_int(head) + sum, first)
    end
    
    defp match(<<head ::size(8), tail :: binary >>, _, sum, first) do
        match(tail, head, sum, first)                
    end
        


    def part_2 do
        data = AoC.read!("day1-1") 
        steps = div(String.length(data), 2)
        group(data, "", steps)
    end

    defp group(string, acc, 0), do: compare(string, acc, 0)

    defp group(<<head :: size(8), tail :: binary >>, acc, steps) do
        group(tail, << acc ::binary, head :: size(8) >>, steps - 1)
    end

    def compare("", "", sum), do: sum

    def compare(<<alpha :: size(8), alpha_tail :: binary >>, <<beta ::size(8), beta_tail :: binary >>, sum)
        when alpha == beta do
            sum = sum + char_to_int(beta) + char_to_int(alpha)
            compare(alpha_tail, beta_tail, sum)
    end
    
    def compare(<<_ :: size(8), alpha_tail :: binary >>, <<_ ::size(8), beta_tail :: binary >>, sum) do
        compare(alpha_tail, beta_tail, sum)
    end
    
    #util
    defp char_to_int(char), do: List.to_integer([char])
    
end