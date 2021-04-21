# Chapter 2
# https://livebook.manning.com/book/classic-computer-science-problems-in-java/chapter-2/


module ch2
export Maze, Node
export dfs
import DataStructures

# export Cell
# export EMPTY


@enum Cell begin
    EMPTY
    BLOCKED
    START
    GOAL
    PATH
end

mutable struct Node
    state  # MazeLocation
    parent # Node
    cost::Float64
    heuristic::Float64

    Node() = ( # incomplete initialization
        me = new();
        #me.cost = 0.0;
        #me.heuristic = 0.0;
        me
    )
    Node(state) = (
        me = new();
        me.state = state;
        me
    )
end

mutable struct Maze
    Maze() = (
        me = new();
        me
    )
    start::Vector{Int64}
    goal::Vector{Int64}
    grid::Array{Cell,2}
end

"""

...
# Arguments
- `initial`:
- `goal_test`:
- `successors`:
...
"""
function dfs(
    initial, # MazeLocation
    goal_test, # function to test if goal reached
    successors, # function that takes MazeLocation and returns a list of next MazeLocations
    )
    
    ds = DataStructures
    
    frontier = ds.Stack{Node}()
    push!(frontier, Node(initial))



    return nothing
end

function new_maze(row_count, col_count, start, goal, sparseness)
    maze = Maze()

    grid = Array{Cell,2}(undef, row_count,col_count)
    grid .= EMPTY::Cell
    
    random_fill!(grid, sparseness)

    grid[start...] = START # same as setindex!(grid, START, start...)
    setindex!(grid, GOAL, goal...)
    
    maze.grid = grid
    maze.start = start
    maze.goal = goal

    return maze
end

function new_maze()
    return new_maze(10, 10, [1,1], [10,10], 0.2)
end

function random_fill!(grid, sparseness) 
    for j in 1:size(grid)[2]
        for i in 1:size(grid)[1]
            if rand(Float64) < sparseness 
            #if rand(0:1.e-15:1) < sparseness
                grid[i,j] = BLOCKED::Cell
            end
        end
    end
end

function successors(grid, here)
    locations = Vector{Tuple{Int64,Int64}}()

    hr = here[1] # row index
    hc = here[2] # col index
    rcount = size(grid)[1]
    ccount = size(grid)[2]

    nr = hr + 1 # next row index
    nc = hc
    if (nr <= rcount) && (grid[nr,nc] != BLOCKED) # () is not necessary, but make it clear
        push!(locations, (nr,nc))
    end

    nr = hr - 1
    nc = hc
    if (1 <= nr) && (grid[nr,nc] != BLOCKED)
        push!(locations, (nr,nc))
    end

    nr = hr
    nc = hc + 1
    if (nc <= ccount) && (grid[nr,nc] != BLOCKED)
        push!(locations, (nr,nc))
    end

    nr = hr
    nc = hc - 1
    if (1 <= nc) && (grid[nr,nc] != BLOCKED)
        push!(locations, (nr,nc))
    end

    return locations
end

function is_goal(goal, here)
    return (goal[1] == here[1]) && (goal[2] == here[2])
end




function Base.show(io::IO, x::ch2.Cell)
    print(io, string(x))
end

function Base.display(x::Array{ch2.Cell})
    if ndims(x) == 2
        for i in 1:size(x)[1]
            for j in 1:size(x)[2]
                print(string(x[i,j]))
            end
            println()
        end
    end
    
end

"""
    string(x::Cell)

Convert enumeration `Cell` to an one character string.
"""
function Base.string(x::ch2.Cell)
    # TODO: use Swicth.jl
    if x == ch2.EMPTY
        return " "
    elseif x == ch2.BLOCKED
        return "X"
    elseif x == ch2.START
        return "S"
    elseif x == ch2.GOAL
        return "G"
    elseif x == ch2.PATH
        return "*"
    end

    return "?"
end


end