# See Julia Dates
# https://docs.julialang.org/en/v1/stdlib/Dates/#stdlib-dates-api-1

using Logging
logger = SimpleLogger(stdout, Logging.Info)
global_logger(logger)

using Dates

# Input
d = now()
@info typeof(d)
d = Date(now())
d = Date(2020, 12, 23)
d = Date("12/22/2020", dateformat"mm/dd/yyyy")

df = dateformat"mm/dd/yyyy"

# Arithmetic
d = Date(2020, 12, 29)
d = d + Dates.Day(3)

# Output
d = Date(2020, 12, 29)
@info typeof(d)
# 21-Feb-2019
str = Dates.format(d, "d-u-Y") # Why format(d, ...) does not work?

nothing # suppress last line printout