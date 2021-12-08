using Random
using Distributions
using Test


# https://juliastats.org/Distributions.jl/stable/starting/#Starting-With-a-Normal-Distribution
function learn_starting_with_a_normal_distribution()
    ncount = 1000000
    Random.seed!(123)

    # Random numbers with normal distribution
    d = Normal() # Normal{Float64}(μ=0.0, σ=1.0)
    x = rand(d, ncount)
    @test isapprox(0.0, mean(x), atol=2)
    @test isapprox(1.0, std(x), atol=2)

    μ=10.0
    σ=2.0
    d = Normal(μ, σ) # Normal{Float64}(μ=10.0, σ=2.0)
    @show d
    x = rand(d, ncount)
    @test isapprox(μ, mean(x), atol=2)
    @test isapprox(σ, std(x), atol=2)
end

@testset "Normal" begin
    learn_starting_with_a_normal_distribution()
end

nothing

