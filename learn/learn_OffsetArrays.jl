using OffsetArrays
using Test

include("Learn.jl")
using .Learn

function learn_Basic()
    A = reshape(1:6, 2, 3)
    # showrepl(A)
    # 2×3 reshape(::UnitRange{Int64}, 2, 3) with eltype Int64:
    # 1  3  5
    # 2  4  6
    @test A[1,1] == 1
    @test A[2,3] == 6
    A = Float64.(A) # Convert to Float64

    OA = OffsetArray(A)
    @test OA[1,1] == 1
    @test OA[2,3] == 6
    
    OA = OffsetArray(A, -1, -1) # OffsetArray(A, 0:1, 0:1)
    @test OA[0,0] == 1
    @test OA[1,2] == 6

    OA = OffsetArray(A, 1:2, -1:1)
    @test OA[1,-1] == 1
    @test OA[2,1] == 6    

    OA = OffsetArray(A, 0, 0)
    @test OA[1,1] == 1
    @test OA[2,3] == 6

    OA = OffsetArray(A, 1, 3) # == OffsetArray(A, 2:3, 4:6)
    @test OA[2,4] == 1


    ## Broadcast 2 OffsetArray of different offset
    OA1 = OffsetArray(A)
    OA2 = OffsetArray(A, -1, -1)
    V = OA1[:] .+ OA2[:] # Need [:] to broadcast
    @test V isa Vector{Float64}
    A4 = reshape(V,2,3)
    @test A4[1,1] == 2
    @test A4[2,3] == 12
    

    nothing
end

learn_Basic()

nothing

