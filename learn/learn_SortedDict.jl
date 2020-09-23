using Logging
logger = SimpleLogger(stdout, Logging.Info)
global_logger(logger)

using DataStructures
#using Base.Order

#>> Sort by char <<#

# Base.Order.Reverse
d = SortedDict{Char,Int}(Base.Order.Forward)

d['c'] = 3
d['d'] = 4
d['a'] = 1

col = collect(d)
@info typeof(col)
@info col

for p in col
    println("$(p[1]) $(p[2])")
end

#>> Sort by Date <<#
using Dates
d2 = SortedDict{DateTime, Int}(Base.Order.Forward)
d2[now()] = 13
sleep(0.1)
d2[now()] = 17
sleep(0.2)
d2[now()] = 19

col2 = collect(d2)
@info typeof(col2)
@info col2

#>> Dict of Dict and sort by Date <<#
d3 = SortedDict{Date, Dict}(Base.Order.Forward)

d3[Date(2020, 12, 24)] = Dict("A"=>1)
d3[Date(2020, 12, 23)] = Dict("B"=>1)
d3[Date(2020, 12, 22)] = Dict("C"=>3)
@info d3

# Add item existing Dict
d3[Date(2020, 12, 23)]["D"] = 4
@info d3

nothing