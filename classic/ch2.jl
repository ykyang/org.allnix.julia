# Chapter 2
# https://livebook.manning.com/book/classic-computer-science-problems-in-java/chapter-2/


module ch2
export Node
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
    Node() = ( # incomplete initialization
        me = new();
        #me.cost = 0.0;
        #me.heuristic = 0.0;
        me
    )    
    state  # MazeLocation
    parent # Node
    cost::Float64
    heuristic::Float64
end


function new_maze(row_count, col_count, start, goal, sparseness)
    grid = Array{Cell,2}(undef, row_count,col_count)
    grid .= EMPTY::Cell
    
    random_fill!(grid, sparseness)

    grid[start...] = START # same as setindex!(grid, START, start...)
    setindex!(grid, GOAL, goal...)

    return grid
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