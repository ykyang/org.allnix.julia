module LearnRandom
using Test
using Random

"""

See ``learn_Distributions.jl`` for more examples and
more advanced usage.
"""
function learn_rand()
    # 1 random number bewteen 1:50
    @test 1<= rand(1:50) <= 50
    
    # 1000 random numbers between 1:10
    r = rand(1:10, 1000)
    @test all(1 .<= r .<= 10)

    # 10x10 random numbers
    Ans = rand(10,10)
    @test size(Ans) == (10,10)
    
    # Random numbers in normal distribution
    Ans = randn(50)
    @test size(Ans) == (50,)
end
"""
    learn_randstring()

Random string
"""
function learn_randstring()
    @test length(randstring(3)) == 3
end

"""
    learn_seed()

Same seed generate the same random number
"""
function learn_seed()
    Random.seed!(1234)
    x = rand()
    # reset
    Random.seed!(1234)
    @test x == rand()
end

@testset "Random Basic" begin
    learn_rand()
    learn_randstring()
    learn_seed()
end

nothing
end