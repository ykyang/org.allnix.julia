# Chapter 17. Multiple Dispatch
# https://benlauwens.github.io/ThinkJulia.jl/latest/book.html#chap17

include("AllnixThinkJulia.jl")
import .AllnixThinkJulia
ns = AllnixThinkJulia

start = ns.MyTime(9, 45, 1)
ns.printtime(start)

# Constructor
# https://benlauwens.github.io/ThinkJulia.jl/latest/book.html#constructor
newtime = ns.MyTime(start)

# Exercise 17-2
# see ch15module.jl

duration = ns.MyTime(1, 35, 0)
finaltime = start + duration

# methods(ns.increment)
# functionloc(ns.increment)

# Multiple Dispatch

# Exercise 17-3 TODO

# Generic Programming
# https://benlauwens.github.io/ThinkJulia.jl/latest/book.html#_generic_programming
