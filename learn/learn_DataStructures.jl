# Learn DataStructures.jl
# https://github.com/JuliaCollections/DataStructures.jl

# TODO: Combine learn_SortedDict.jl, learn_SortedSet.jl into here

using Test
import DataStructures

struct Node
    id::Int64
end
# https://discourse.julialang.org/t/proper-way-to-overload-operators/19872
Base.:(<)(x::Node, y::Node) = x.id < y.id
function Base.:(==)(x::Node,y::Node) 
    return x.id == y.id
end


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

    # Node
    @test Node(1) == Node(1) # test Base.:(==) override

    set = Set{Node}()
    push!(set, Node(1))
    push!(set, Node(13))
    @test in(Node(1), set)
    @test in(Node(13), set)

    x = pop!(set, Node(13))
    @test Node(13) == x
    @test !in(Node(13), set)
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
