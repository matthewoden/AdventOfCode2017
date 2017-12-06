defmodule AoC do
  @moduledoc """
  Documentation for AdventOfCode2017.
  """

  def stream!(file) do
      File.stream!("./resources/#{file}")
  end

  def read!(file) do
    File.read!("./resources/#{file}")
  end

  def pmap(collection, func) do
    collection
    |> Enum.map(&Task.async(fn -> func.(&1) end))
    |> Enum.map(&Task.await/1)
  end


  def read_line(line, seperator, state \\ "", func \\ fn (f) -> f end) do
    Stream.map(line, &line_reader(&1, "", seperator, state, func))
  end

  def line_reader(_, _, _, {:exit, state}, _), do: state
  def line_reader(input, word, seperator, state, func) do
      case input do
          "" ->
              state

        <<value, tail :: binary >>  when value in [seperator, ?\n] ->
              state = func.(word, state)

            line_reader(tail, "", seperator, state, func)

        <<head ::size(8), tail :: binary >> ->
              word = << word :: binary, head :: size(8) >>

            line_reader(tail, word, seperator, state, func)
      end
  end
end