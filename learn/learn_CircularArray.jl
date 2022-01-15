using CircularArrays
using Test

function learn_basic()
    # The length is determined by the CircularArray
    # so CircularArray should not be part of zip()
    as = CircularArray([1,2]) # shorter
    bs = [1,2,3]
    @test length(as) == 2
    abs = [
        [1,1], 
        [2,2]
    ]

    for (ind, (a,b)) in enumerate(zip(as,bs))
        @test [a,b] == abs[ind]
    end

    # This is the right way to use CircularArray
    abs = [
        [1,1], 
        [2,2],
        [1,3],
    ]
    for (ind, b) in enumerate(bs)
        @test [as[ind],b] == abs[ind]
    end

    # This is ok but still not the right way to use CircularArray
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

nothing
