# Structs and Functions
# https://benlauwens.github.io/ThinkJulia.jl/latest/book.html#chap16
#include("ch15module.jl")


using Printf

# Time
"""
Represents the time of day.

hour:
minute:
second:
"""
mutable struct MyTime
    hour::Int64
    minute::Int64
    second::Int64
end

# Exercise 16-1
function printtime(mytime)
    @printf("%02d:%02d:%02d\n", mytime.hour, mytime.minute, mytime.second)
end

# Exercise 16-2
function isafter(t2, t1)
    tosecond(t2) < tosecond(t1)
end
function tosecond(mytime)
    mytime.hour*60*60 + mytime.minute*60 + mytime.second
end

# Pure Function
# https://benlauwens.github.io/ThinkJulia.jl/latest/book.html#_pure_functions

# A pure function does not modify its parameter
function addtimeDEAD(t1, t2)
    second = t1.second + t2.second
    minute = t1.minute + t2.minute
    hour = t1.hour + t2.hour

    if second >= 60
        second -= 60
        minute += 1
    end
    if minute >= 60
        minute -= 60
        hour += 1
    end

    MyTime(hour, minute, second)
end

# Improved version
function addtime(t1, t2)
    totalsecond = timetosecond(t1) + timetosecond(t2)
    secondtotime(totalsecond)
end

# Modifiers
# https://benlauwens.github.io/ThinkJulia.jl/latest/book.html#modifiers
# """
# Represents the time of day.
#
# hour:
# minute:
# second:
# """
# mutable struct MMyTime
#     hour::Int64
#     minute::Int64
#     second::Int64
# end

# Modifier version
function increment!DEAD(time, seconds)
    time.second += seconds

    if time.second >= 60
        time.second -= 60
        time.minute += 1
    end
    if time.minute >= 60
        time.minute -= 60
        time.hour += 1
    end
    # Exercise 16-3
    if time.second >= 60
        increment!(time, 0)
    end
end

# Exercise 16-5
function increment!(time, seconds)
    totalsecond = timetosecond(time) + seconds
    newtime = secondtotime(totalsecond)

    time.second = newtime.second
    time.minute = newtime.minute
    time.hour = newtime.hour
end


# Exercise 16-4: Pure version
function increment(time, addsecond)
    second = time.second + addsecond
    minute = time.minute
    hour = time.hour

    if second >= 60
        second -= 60
        minute += 1
    end
    if minute >= 60
        minute -= 60
        hour += 1
    end

    rettime = MyTime(hour, minute, second)

    if rettime.second >= 60
    # Recursive to move second to minute to hour
        rettime = increment(rettime, 0)
    end

    return rettime
end

# Prototyping Versus Planning
# https://benlauwens.github.io/ThinkJulia.jl/latest/book.html#prototyping_versus_planning
function timetosecond(time)
    seconds = time.hour*3600 + time.minute*60 + time.second
end


function secondtotime(totalsecond)
    (minute, second) = divrem(totalsecond, 60)
    (hour, minute) = divrem(minute, 60)
    return MyTime(hour, minute, second)
end
