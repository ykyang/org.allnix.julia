using Logging
logger = SimpleLogger(stdout, Logging.Info)
global_logger(logger)

using DataStructures

#>> Sort by char <<#

d = SortedDict{Char,Int}(Base.Order.Forward) # Base.Order.Reverse

d['c'] = 3
d['d'] = 4
d['a'] = 1

col = collect(d)
@info typeof(col)
@info col

for p in col
    println("$(p[1]) $(p[2])")
end

#>> Sort by DateTime <<#

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

#>> Sort by Date <<#

# SortedDict of Dict 
d3 = SortedDict{Date, Dict}(Base.Order.Forward)

d3[Date(2020, 12, 24)] = Dict("A"=>1)
d3[Date(2020, 12, 23)] = Dict("B"=>1)
d3[Date(2020, 12, 22)] = Dict("C"=>3)
@info d3

# Add item existing Dict
# Indeed we are modifying a ref not a copy
d3[Date(2020, 12, 23)]["D"] = 4
@info d3

@info "Values are in order: $(values(d3))"

@info in(Date(2020, 12, 23), keys(d3))
@info in(Date(2019, 1, 1), keys(d3))
@info haskey(d3, Date(2020, 12, 23))
@info haskey(d3, Date(2019, 1, 1))


nothing # suppress printing the last line
