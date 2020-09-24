using Logging
logger = SimpleLogger(stdout, Logging.Info)
global_logger(logger)

using DataStructures
using Dates

#>> Sort by Date <<#
d = SortedSet{Date}(Base.Order.Forward)
push!(d, Date(2020, 12, 24))
push!(d, Date(2020, 12, 22))
push!(d, Date(2020, 12, 23))

@info d

nothing # suppress printing the last line