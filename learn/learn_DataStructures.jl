# Learn DataStructures.jl
# https://github.com/JuliaCollections/DataStructures.jl

# TODO: Combine learn_SortedDict.jl, learn_SortedSet.jl into here

using Test
#import DataStructures
using DataStructures

"""
Example custom struct for testing with containers.

"""
struct Node
    id::Int64
end
# https://discourse.julialang.org/t/proper-way-to-overload-operators/19872
Base.:(<)(x::Node, y::Node) = x.id < y.id
Base.:(==)(x::Node,y::Node) = x.id == y.id

"""
Demonstrate `id` alone identify the uniqueness of a node and `value` is used
to compare magnitude.
"""
struct Node2
    id::Int64
    value::Float64
end
Base.:(<)(x::Node2, y::Node2) = x.value < y.value
Base.:(==)(x::Node2,y::Node2) = x.value == y.value
# isequal is used for ID
Base.isequal(x::Node2,y::Node2) = isequal(x.id, y.id) #error("Unsupported operation") #x.id == y.id
Base.hash(x::Node2, h::UInt64=UInt64(13)) = hash(x.id,h)


function learn_Node2()
    # N{id,value}
    N = Node2 # save some typing
    

    # (<)
    @test N(3, 3.3) < N(2, 4.4)
    @test N(3, 3.3) <= N(2, 3.3)
    @test N(2, 4.4) > N(3, 3.3)
    @test N(2, 4.4) >= N(3, 4.4)

    # (==)
    @test N(3, 3.3) != N(4, 4.4) # value !=
    @test N(3, 3.3) == N(4, 3.3) # value ==

    # hash(), isequal uses ID for uniqueness
    db = Dict{N,Int64}()
    @test isempty(db)
    db[N(3, 3.3)] = 3
    @test 1 == length(db)
    db[N(3, 4.4)] = 4     # same key as above
    @test 1 == length(db) # so still 1 element
    @test 4 == db[N(3, 5.5)]
    db[N(4, 6.6)] = 6     # add one element
    @test 2 == length(db)

    # (===)
    @test N(3, 3.3) === N(3, 3.3) # immutables are compared at bit level
    

    nothing
end

function learn_Dict()
    db = Dict{Node2,Int64}()
    # @show db

    db[Node2(1,2)] = 13
    db[Node2(1,3)] = 14
    @test 14 == db[Node2(1,2)]
    #@show getindex(db, Node2(1,2))

    @show db
end

function learn_PriorityQueue()
    # ------------------ #
    # Value: Low -> High #
    # ------------------ #
    que = PriorityQueue{String,Int64}() # (key,value), value: low -> high
    @test isempty(que)

    enqueue!(que, "z", 100) # z,100
    @test !isempty(que)
    @test 1 == length(que)

    enqueue!(que, "w", 300) # w,300
    @test 2 == length(que)

    # Get key only
    x = dequeue!(que)
    @test 1 == length(que)
    @test "z" == x

    # Get (key,value)
    x = dequeue_pair!(que)
    @test isempty(que)
    @test "w" == x[1]
    @test 300 == x[2]

    # ------------------ #
    # Value: High -> Low #
    # ------------------ #
    que = PriorityQueue{String,Int64}(Base.Order.Reverse) # (key,value), value: high -> low
    @test isempty(que)
    enqueue!(que, "z", 100) # z,100
    @test !isempty(que)
    @test 1 == length(que)

    enqueue!(que, "p", 300) # p,300
    @test 2 == length(que)

    enqueue!(que, "w", 700) # w,700
    @test 3 == length(que)

    # Get key only
    x = dequeue!(que) # w,700
    @test 2 == length(que)
    @test "w" == x

    # Get (key,value)
    x = dequeue_pair!(que) # p,300
    @test 1 == length(que)
    @test "p" == x[1]
    @test 300 == x[2]

    # TODO
    # ---------
    # Use custom type as key::Node #
    # ---------------------------- #
    que = PriorityQueue{Node2,Float64}()
    enqueue!(que, Node2(1,2), 3.0)
    enqueue!(que, Node2(1,3), 4.0)
end

"""
    learn_Queue()

Use `methodswith(Queue)` to see methods for `Queue`.
"""
function learn_Queue()
    #ds = DataStructures

    que = Queue{Int64}()
    @test isempty(que)

    enqueue!(que, 7)
    @test !isempty(que)
    @test 1 == length(que)
    @test 7 == first(que)
    @test 7 == last(que)

    enqueue!(que, 13)
    @test 2 == length(que)
    @test 7 == first(que)
    @test 13 == last(que)

    x = dequeue!(que)
    @test 7 == x
    @test 1 == length(que)
    @test 13 == first(que)
    @test 13 == last(que)
end


"""
    learn_Set()

Learn how to use `Set`.  Common Set functions

```julia
julia> methodswith(Set)
[1] length(s::Set) in Base at set.jl:55
[2] sizehint!(s::Set, newsz) in Base at set.jl:74
[3] copy(s::Set) in Base at set.jl:68
[4] delete!(s::Set, x) in Base at set.jl:66
[5] empty!(s::Set) in Base at set.jl:75
[6] filter!(f, s::Set) in Base at set.jl:390
[7] in(x, s::Set) in Base at set.jl:56
[8] isempty(s::Set) in Base at set.jl:54
[9] iterate(s::Set, i...) in Base at set.jl:78
[10] pop!(s::Set) in Base at set.jl:61
[11] pop!(s::Set, x) in Base at set.jl:58
[12] pop!(s::Set, x, default) in Base at set.jl:59
[13] push!(s::Set, x) in Base at set.jl:57
[14] setdiff!(s::Set, t::Set) in Base at set.jl:87
[15] show(io::IO, s::Set) in Base at set.jl:39
```
"""
function learn_Set()
    # push!, pop!
    set = Set{Int64}()
    
    push!(set, 1)
    push!(set, 13)

    @test in(1, set)
    @test in(13, set)
    @test !in(2, set)

    x = pop!(set, 1)
    @test 1 == x
    @test !in(1, set)

    # empty!
    set = Set{Int64}()
    @test isempty(set)
    push!(set, 7)
    @test !isempty(set)
    x = empty!(set)
    @test x === set
    @test isempty(set)

    # Node
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

@testset "Node2" begin
    learn_Node2()
end

#learn_Dict()
#A = learn_PriorityQueue()
#A = learn_Queue()
#A = learn_Set()
#A = learn_Stack()

#A
nothing