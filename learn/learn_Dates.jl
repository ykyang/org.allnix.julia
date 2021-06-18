# See Julia Dates
# https://docs.julialang.org/en/v1/stdlib/Dates/#stdlib-dates-api-1

# TODO: remove logging using test instead
using Test
using Logging
logger = ConsoleLogger(stdout, Logging.Info)
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

delta_day = Date(2020,10,31) - Date(2020, 10,20) 
@info "Delta days = $delta_day"
@info @show typeof(delta_day)
@info @show typeof(delta_day.value)

delta_day = DateTime(2020,10,31) - DateTime(2020, 10,20) # milliseconds
delta_day = convert(Day, DateTime(2020,10,31) - DateTime(2020, 10,20)) # milliseconds


d = DateTime(2020, 12, 25)
d = d + Dates.Millisecond(86400*1000)
@info d

# Output
d = Date(2020, 12, 29)
@info typeof(d)
# 21-Feb-2019
str = Dates.format(d, "d-u-Y") # Why format(d, ...) does not work?

# generate a list of date
d = Date(2019, 03, 20)
for ind in 1:730
    global d
    str = Dates.format(d, "d-u-Y")
    #println("DATE \"$str\"")
    d += Day(1)
end

@test DateTime("2019-2-1T00:00:00") == DateTime(2019, 2, 1)

@test DateTime(2020, 12, 29) > DateTime(2020, 12, 25)

nothing # suppress last line printout