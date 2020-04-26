# Chapter 15. Structs and Objects
module AllnixThinkJulia
# export Point

# Composite Types
struct Point
    x
    y
end

# Mutable Structs
# https://benlauwens.github.io/ThinkJulia.jl/latest/book.html#_mutable_structs
mutable struct MPoint
    x
    y
end

# Rectangles
# https://benlauwens.github.io/ThinkJulia.jl/latest/book.html#_rectangles
"""
Represents a rectangle.

width: Width
height:
corner: Lower left corner
"""
struct Rectangle
    width
    height
    corner::MPoint
end

# Instances as Arguments
# https://benlauwens.github.io/ThinkJulia.jl/latest/book.html#_instances_as_arguments
function printpoint(p)
    println("($(p.x), $(p.y))")
end

# Exercise 15-1
function distancebetweenpoints(p, q)
    x2 = p.x^2 + q.x^2
    y2 = p.y^2 + q.y^2
    ret = sqrt(x2 + y2)

    return ret
end

function movepoint!(p, dx, dy)
    p.x += dx
    p.y += dy

    nothing
end

function moverectangle!(rect, dx, dy)
    movepoint!(rect.corner, dx, dy)
end

# Instances as Return Values
function findcenter(rect)
    Point(
    rect.corner.x + rect.width/2.,
    rect.corner.y + rect.height/2.)
end
end
