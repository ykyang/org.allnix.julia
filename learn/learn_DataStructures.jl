# Learn DataStructures.jl
# https://github.com/JuliaCollections/DataStructures.jl

# TODO: Combine learn_SortedDict.jl, learn_SortedSet.jl into here

using Test
import DataStructures


function learn_Stack()
    ds = DataStructures

    stack = ds.Stack{Int64}()
    push!(stack, 1)
    push!(stack, 2)

    # first in last out
    @test 2 == pop!(stack)
    @test 1 == pop!(stack)
end

learn_Stack()
