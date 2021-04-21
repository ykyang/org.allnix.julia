# Learn DataStructures.jl
# https://github.com/JuliaCollections/DataStructures.jl

# TODO: Combine learn_SortedDict.jl, learn_SortedSet.jl into here

using Test
import DataStructures


function learn_Set()
    set = Set{Int64}()

    # isempty(s::Set) = isempty(s.dict)
    # length(s::Set)  = length(s.dict)
    # in(x, s::Set) = haskey(s.dict, x)
    # push!(s::Set, x) = (s.dict[x] = nothing; s)
    # pop!(s::Set, x) = (pop!(s.dict, x); x)
    # pop!(s::Set, x, default) = (x in s ? pop!(s, x) : default)

    push!(set, 1)
    push!(set, 13)

    @test in(1, set)
    @test in(13, set)
    @test !in(2, set)

    x = pop!(set, 1)
    @test 1 == x

    @test !in(1, set)
end

function learn_Stack()
    ds = DataStructures

    stack = ds.Stack{Int64}()
    push!(stack, 1)
    push!(stack, 2)

    # first in last out
    @test 2 == pop!(stack)
    @test 1 == pop!(stack)
end



#learn_Stack()
learn_Set()
