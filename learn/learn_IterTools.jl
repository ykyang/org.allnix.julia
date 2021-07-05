# https://juliacollections.github.io/IterTools.jl/stable/

using IterTools
using Test

function learn_distinct()
    data = [13, 5, 17, 3, 2, 2, 7, 5, 11, 13, 23]
    @test [13, 5, 17, 3, 2, 7, 11, 23] == collect(distinct(data))
end

@testset "Base" begin
    learn_distinct()
end;

