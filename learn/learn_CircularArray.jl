using CircularArrays
using Test

function learn_basic()
    as = CircularArray([1,2]) # shorter
    bs = [1,2,3]
    @test length(as) == 2
    abs = [[1,1], [2,2]]

    ind = 1
    for (a,b) in zip(as,bs)
        @test [a,b] == abs[ind]
        ind += 1
    end


    as = CircularArray([1,2,3,4]) # longer
    bs = [1,2,3]
    @test length(as) == 4
    abs = [[1,1], [2,2], [3,3]]

    ind = 1
    for (a,b) in zip(as,bs)
        @test [a,b] == abs[ind]
        ind += 1
    end
end


@testset "Base" begin
    learn_basic()
end