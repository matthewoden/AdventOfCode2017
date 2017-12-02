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

  def pmap (enum) do
    
  end
end
