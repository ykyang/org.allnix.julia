include("ch2.jl")

#import .ch2
using .ch2

x = ch2.EMPTY
y = ch2.START

println("x = $(string(x)), y = $(string(y))")

grid = ch2.new_maze() #new_maze(10,10, [1,1], [10,10], 0.2)
display(grid)

node = Node()

nothing
