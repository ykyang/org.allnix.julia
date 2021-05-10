using LinearAlgebra
using Test

function learn_dot()
    x = [1.0, 2.0, 3.0]
    y = [1.0, 2.0, 3.0]
    @test 1+4+9 == dot(x,y)
    x = [1.0, 2.0, 3.0]
    y = [4.0, 5.0, 6.0]
    @test 4+10+18 == dot(x,y)
end

@testset "Base" begin
    learn_dot()
end

nothing
