using StatsBase
using Statistics
using Test

function learn_MeanFunctions()
    data = [1:5...]

    @test 3.0 == mean(data)
end

function learn_ScalarStatistics()
    data = [1:5...]
    count = length(data)

    # var
    @test 2.0 == var(data, corrected=false)        # population: /n from Statistics
    @test 2.0 == var(data, uweights(count)) # population: /n from StatsBase

    @test 2.5 == var(data)                                         # sample: /(n-1) from Statistics
    @test 2.5 == var(data, uweights(count), corrected=true) # sample: /(n-1) from StatsBase

    # std
    @test sqrt(2.0) == std(data, corrected=false)
    @test sqrt(2.0) == std(data, uweights(count))

    @test sqrt(2.5) == std(data)
    @test sqrt(2.5) == std(data, uweights(count), corrected=true)
end

@testset "StatsBase" begin
    learn_MeanFunctions()
    learn_ScalarStatistics()
end

nothing
