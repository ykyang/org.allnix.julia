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
