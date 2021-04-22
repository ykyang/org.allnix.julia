include("ch2.jl")

import .ch2
#using .ch2

function run_bfs()
    maze = ch2.new_maze(10, 10, (1,1), (10,10), 0.2)

    # create functions for bfs()
    is_goal(pt)     = ch2.is_goal(maze.goal, pt)
    next_points(pt) = ch2.next_points(maze.grid, pt)

    node = ch2.bfs((1,1), is_goal, next_points)

    if isnothing(node)
        println("Path not found")
        display(maze.grid) # print the unsovled maze
    else
        ch2.mark_path!(maze.grid, node, start=maze.start, goal=maze.goal)
        display(maze.grid) # print the maze and the path
    end
end

function run_cell()
    x = ch2.EMPTY
    y = ch2.START

    println("x = $(string(x)), y = $(string(y))")
end

"""
    run_dfs()

Use depth-first search to solve a maze.
"""
function run_dfs()
    maze = ch2.new_maze() #new_maze(10,10, [1,1], [10,10], 0.2)
    #@show maze
    #display(maze.grid)

    #node = ch2.Node()
    #locations = ch2.successors(maze.grid, (2,2))
    #@show locations

    # pass this to dfs(..., successors)
    successors(here) = ch2.successors(maze.grid, here)
    # pass this to dfs(..., goal_test, ...)
    is_goal(here) = ch2.is_goal(maze.goal, here)

    node = ch2.dfs((1,1), is_goal, successors)
    if isnothing(node)
        println("Path not found")
        display(maze.grid)
    else
        ch2.mark_path!(maze.grid, node, start=maze.start, goal=maze.goal)
        #@show maze
        display(maze.grid)
    end
    #@show node

end



#run_cell()
#run_dfs()
run_bfs()

nothing
