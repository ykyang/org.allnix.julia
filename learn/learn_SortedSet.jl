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

# Convert date to string
ds = Dates.format.(d, "dd-u-Y") # Why format(d, ...) does not work?
@info typeof(ds)
@info ds

# Check for key
@info in(Date(2020, 12, 24), d)
@info in(Date(2019, 1, 1), d)
nothing # suppress printing the last line