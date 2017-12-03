defmodule AoC.Day3.Worker do
    use GenServer

    @moduledoc """
    Building off yesterday's nested recursion, a move to something more 
    Elixir-ish. We've got processes and message passing, so let's use 'em!

    We have two workers - one is a walker, the other handles computation of 
    state.
    
    The walker only moves in a spiral, and the worker (a genserver) handles its 
    own logic based on the walker's current position. When the worker is 
    finished, it sends a message back to the spiral-walker to stop.
    """

    @count 368_078
    
    def start_link(state) do
        GenServer.start_link(__MODULE__, state)
    end

    def init(state), do: {:ok, state}

    # step 1
    def handle_call(walker, _, %{part: 1, count: 1}) do
        state = Map.put(walker, :exit, abs(walker.x) + abs(walker.y))
        {:reply, state, state}
    end

    def handle_call(walker, _, %{part: 1, count: count} = state) do
        {:reply, walker, Map.put(state, :count, count - 1)}
    end

    #  step 2
    def handle_call(walker, _, %{part: 2, current: current}) when current > @count do
        {:reply, Map.put(walker, :exit, current), nil}
    end

    def handle_call(walker, _, state) do
        state = 
            state
            |> get_adjacent(walker)
            |> add_to_grid(walker)
            |> Map.put(:count, state.count - 1)

        {:reply, walker, state}
    end

    def add_to_grid(state, walker) do
        grid = Map.put(state.grid, {walker.x, walker.y}, state.current)
        %{ state | grid: grid }
    end

    #brute force
    def get_adjacent(state, walker) do
        current = 
            [{walker.x - 1, walker.y},     {walker.x - 1, walker.y - 1},
             {walker.x - 1, walker.y + 1}, {walker.x,     walker.y - 1},
             {walker.x,     walker.y + 1}, {walker.x + 1, walker.y},               
             {walker.x + 1, walker.y + 1}, {walker.x + 1, walker.y - 1}] 
            |> Enum.map(fn key ->  Map.get(state.grid, key, 0) end)
            |> Enum.sum()

        %{ state | current: current }
    end

end

defmodule AoC.Day3.Walker do
 
    @walker_state %{facing: :e, w: 1, h: 1, x: 0, y: 0, delta: 0}

    def start_walk({:ok, pid}), do: walk(@walker_state, pid)

    def walk(state, pid) do
        case state do
            %{exit: state} -> state
            
            # turn
            %{h: h, delta: d} when d == h -> 
                state |> reset(:delta) |> turn |> walk(pid)

            state ->
                state |> increment(:delta) |> move() |> call(pid) |> walk(pid)
        end
    end

    def turn(%{facing: :e} = state), do: %{ state | facing: :n } |> increment(:w)
    def turn(%{facing: :w} = state), do: %{ state | facing: :s } |> increment(:w)
    def turn(%{facing: :s} = state), do: %{ state | facing: :e } |> increment(:h)
    def turn(%{facing: :n} = state), do: %{ state | facing: :w } |> increment(:h)

    def move(%{facing: :e} = state), do: increment(state, :x) 
    def move(%{facing: :w} = state), do: decrement(state, :x) 
    def move(%{facing: :n} = state), do: increment(state, :y) 
    def move(%{facing: :s} = state), do: decrement(state, :y) 
    
    #inversion for pipelines
    def call(state, pid), do: GenServer.call(pid, state)   

    def decrement(state, key), do: Map.put(state, key, state[key] - 1)   
    def increment(state, key), do: Map.put(state, key, state[key] + 1)
    def reset(state, key), do: Map.put(state, key, 0)       
end

defmodule AoC.Day3 do
    @count 368_078
    @state %{ grid: %{ {0,0} => 1}, current: 1, count: @count}

    def part_1 do
        @state
        |> Map.put(:part, 1)
        |> AoC.Day3.Worker.start_link()
        |> AoC.Day3.Walker.start_walk()
    end

    def part_2 do
       @state
       |> Map.put(:part, 2)
       |> AoC.Day3.Worker.start_link()
       |> AoC.Day3.Walker.start_walk()      
    end
end

[:part_1, :part_2] 
|> Enum.map(&Task.async(fn -> apply(AoC.Day3, &1, []) end))
|> Enum.map(&Task.await/1)
|> IO.inspect
