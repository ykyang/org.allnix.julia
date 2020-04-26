# Structs and Functions
# https://benlauwens.github.io/ThinkJulia.jl/latest/book.html#chap16
#include("ch15module.jl")
include("AllnixThinkJulia.jl")
import .AllnixThinkJulia
ns = AllnixThinkJulia

# functional programming style

# Time
time = ns.MyTime(11, 59, 30)
# Exercise 16-1
ns.printtime(time)
# Exercise 16-2
t1 = ns.MyTime(9, 30, 15)
t2 = ns.MyTime(8, 45, 30)
ns.isafter(t2, t1)

# Pure Functions
# https://benlauwens.github.io/ThinkJulia.jl/latest/book.html#_pure_functions

# prototype and patch

# A pure function
start = ns.MyTime(9, 45, 0)
duration = ns.MyTime(1, 35, 0)
done = ns.addtime(start, duration)

ns.printtime(done)

# Modifiers
# https://benlauwens.github.io/ThinkJulia.jl/latest/book.html#modifiers

# Function that modifies its parameter

# Exercise 16-3: See ch16module.jl
time = ns.MyTime(9, 45, 0)
ns.increment!(time, 130)
ns.printtime(time)

# Exercise 16-4: See ch16module.jl
time = ns.MyTime(9, 45, 0)
time = ns.increment(time, 130)
ns.printtime(time)

# Prototyping Versus Planning
# https://benlauwens.github.io/ThinkJulia.jl/latest/book.html#prototyping_versus_planning

# prototype and patch: could be messy
# designed development: more insight into the problem then do it
time = ns.MyTime(9, 45, 0)
totalsecond = ns.timetosecond(time)
time = ns.secondtotime(totalsecond)

# Exercise 16-5: See ch16module.jl
