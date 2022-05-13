# Learn Chain.jl

using Chain
using Test

x = 2
y = @chain x begin
    *(3)
    +(4)
end 

@test y == 10

p4 = function(x) x+4 end
t3 = function(x) x*3 end

y = @chain x begin
    p4
    t3
end
@test y == 18