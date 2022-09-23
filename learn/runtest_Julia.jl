using Test

include("learn_Julia.jl")


@testset "Node" begin
    #MyJulia.learn_Node()
    LearnJulia.learn_Node()
end
@testset "Basic" begin
    LearnJulia.learn_resize!()
    LearnJulia.learn_searchsortedfirst()

    LearnJulia.learn_CartesianIndex()
    LearnJulia.learn_Serialization()

    # learn_rand(); # Moved to learn_Random.jl

    LearnJulia.learn_summarysize()

    LearnJulia.learn_Pair()
    LearnJulia.learn_Tuple()
end
@testset "For-Loop" begin
    LearnJulia.learn_for_comma()
    LearnJulia.learn_comprehension()
    LearnJulia.learn_for_zip()
end
@testset "Matrix" begin
    LearnJulia.learn_Matrix()
end
@testset "Math" begin
    LearnJulia.learn_floor_fld_ceil_cld()
    LearnJulia.learn_div_mod()
end

@testset "Reduce" begin
    LearnJulia.learn_reduce()
end