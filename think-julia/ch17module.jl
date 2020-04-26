# Chapter 17. Multiple Dispatch
# https://benlauwens.github.io/ThinkJulia.jl/latest/book.html#chap17


using Printf

# Methods
# https://benlauwens.github.io/ThinkJulia.jl/latest/book.html#_methods
function printtime(mytime::AllnixThinkJulia.MyTime)
    @printf("%02d:%02d:%02d\n", mytime.hour, mytime.minute, mytime.second)
end

# Exercise 17-1

function timetosecond(time::MyTime)
    seconds = time.hour*3600 + time.minute*60 + time.second
end

function secondtotime(totalsecond::Int64)
    (minute, second) = divrem(totalsecond, 60)
    (hour, minute) = divrem(minute, 60)
    return MyTime(hour, minute, second)
end

# Constructors
# https://benlauwens.github.io/ThinkJulia.jl/latest/book.html#constructor
function MyTime(mytime::MyTime)
    MyTime(mytime.hour, mytime.minute, mytime.second)
end
