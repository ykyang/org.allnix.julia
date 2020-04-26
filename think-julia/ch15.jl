# Chapter 15. Structs and Objects

include("ch15module.jl")

# Does not work?
# using .ch15
# p = Point(3.0, 4.0)


import .AllnixThinkJulia
ns = AllnixThinkJulia # alias


# Composite Types
p = ns.Point(3.0, 4.0)
q = ns.Point(12, 13)


# Mutable Structs
# https://benlauwens.github.io/ThinkJulia.jl/latest/book.html#_mutable_structs
blank = ns.MPoint(0.0, 0.0)
origin = ns.MPoint(0.0, 0.0)

# Rectangles
# https://benlauwens.github.io/ThinkJulia.jl/latest/book.html#_rectangles
box = ns.Rectangle(100., 200., origin)


# Instances as Arguments
ns.printpoint(p)
distance = ns.distancebetweenpoints(p, q)
ns.movepoint!(origin, 3, 4)
# ns.movepoint!(p, 4, 5) # setfield! immutable struct of type Point cannot be changed
ns.moverectangle!(box, 1, 2)

# Instances as Return Values
center = ns.findcenter(box)

# Copying
# https://benlauwens.github.io/ThinkJulia.jl/latest/book.html#_copying
p1 = ns.MPoint(3.0, 4.0)
p2 = deepcopy(p1)
p1 ≡ p2   # false
p1 === p2 # false
p1 == p2  # false

# Exercise 15-2
p1 = ns.Point(3.0, 4.0)
p2 = deepcopy(p1)
p1 ≡ p2   # true
p1 === p2 # true
p1 == p2  # true

# Debugging
fieldnames(ns.Point)
isdefined(p, :x)
