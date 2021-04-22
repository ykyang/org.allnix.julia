# Chapter 2
# https://livebook.manning.com/book/classic-computer-science-problems-in-java/chapter-2/


module ch2
export Maze, Node
export dfs
import DataStructures
using DataStructures

# export Cell
# export EMPTY

"""
    Cell

Cell type of a maze
"""
@enum Cell begin
    EMPTY
    BLOCKED
    START
    GOAL
    PATH
end

"""
    Node

Record path in a maze
"""
mutable struct Node
    point::Tuple{Int64,Int64}  # MazeLocation
    parent::Union{Node,Nothing}
    cost::Float64
    heuristic::Float64

    Node() = ( # incomplete initialization
        me = new();
        #me.cost = 0.0;
        #me.heuristic = 0.0;
        me
    )
    Node(point) = (
        me = new();
        me.point = point;
        me.parent = nothing;
        me
    )
    Node(point,parent) = (
        me = new();
        me.point = point;
        me.parent = parent;
        me
    )
end
#Base.:(<)(x::Node, y::Node) = x.id < y.id
Base.:(==)(x::Node,y::Node) = x.point == y.point

mutable struct Maze
    Maze() = (
        me = new();
        me
    )
    start::Tuple{Int64,Int64}
    goal::Tuple{Int64,Int64}
    grid::Array{Cell,2}
end

"""
    bfs(initial::Tuple{Int64,Int64}, goal_test, next_ponts)

Solve a maze using breadth-first search algorithm.  Returns the `Node` at the 
goal or nothing is no solution found.  Use the parent of `Node` to trace back 
to the start.

...
# Arguments
- `initial`: Starting point in the maze
- `goal_test`: Function`(Tuple{Int64,Int64})` to test if the goal has reached
- `next_points`: Function`(Tuple{Int64,Int64}) -> Vector{Tuple{Int64,Int64}}` to get next points to move to
...
"""
function bfs(initial::Tuple{Int64,Int64}, goal_test, next_points)
    frontier = Queue{Node}()
    enqueue!(frontier, Node(initial)) # starts with initial guess

    # Positions where we have been to
    explored = Set{Tuple{Int64,Int64}}()
    push!(explored, initial)

    while !isempty(frontier)
        current_node = dequeue!(frontier)
        current_pt = current_node.point

        if goal_test(current_pt)
            return current_node
        end

        for next_pt in next_points(current_pt)
            if in(next_pt, explored)
                continue
            end

            push!(explored, next_pt)
            enqueue!(frontier, Node(next_pt, current_node))
        end

        #empty!(frontier)
    end
    
    # no solution
    return nothing
end

"""
    dfs(initial, goal_test, successors)

Depth-first search

...
# Arguments
- `initial`: Starting point in the maze
- `goal_test`: Function to test if goal has reached
- `successors`: Function to get a list of next locations to try
...
"""
function dfs(
    initial::Tuple{Int64,Int64}, # MazeLocation, 
    goal_test, # function to test if goal reached
    successors, # function that takes MazeLocation and returns a list of next MazeLocations
    )
    
    ds = DataStructures
    
    frontier = ds.Stack{Node}()
    push!(frontier, Node(initial))

    explored = Set{Tuple{Int64,Int64}}()
    push!(explored, initial)

    while !isempty(frontier)
        current_node = pop!(frontier) # Node
        current_pt = current_node.point
        if goal_test(current_pt)
            return current_node # break
        end
        
        for nextPoint in successors(current_pt)
            if in(nextPoint, explored)
                continue
            end
            push!(explored, nextPoint)
            push!(frontier, Node(nextPoint, current_node))
        end

        # @show explored
        # empty!(explored)
    end

    # no solution
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
    return new_maze(10, 10, (1,1), (10,10), 0.2)
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

next_points(grid, pt) = successors(grid, pt)

function is_goal(goal, here)
    return (goal[1] == here[1]) && (goal[2] == here[2])
end

"""
    mark_path!(grid, node::Node; start=nothing, goal=nothing)

Mark PATH to `grid` starting from `node` and go back up to its `parent`
until the parent is `nothing`.  The `node` is usually pointed to `goal` of
the `grid`.
"""
function mark_path!(grid, node::Node; start=nothing, goal=nothing)
    if isnothing(goal)
        grid[node.point...] = PATH
    end

    while !isnothing(node.parent)
        node = node.parent
        if node.point != start        
            grid[node.point...] = PATH
        end
    end
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
        return  "□" #"◻" #"▢" #"□"
    elseif x == ch2.BLOCKED
        return "■" #"■" #"▮" #"■" #"◾" #"■" # "X" #"■" #"▮"
    elseif x == ch2.START
        return "►" #"S"
    elseif x == ch2.GOAL
        return "◎" #"G"
    elseif x == ch2.PATH
        return "●" #"*" #"◘" #"*"
    end

    return "?"
end


end