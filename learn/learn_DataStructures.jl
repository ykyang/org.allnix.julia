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

function learn_PriorityQueue()
    # Low -> high priority
    que = PriorityQueue{Int64,Int64}() # key, value, low -> high priority
    @test isempty(que)

    enqueue!(que, 1, 100)
    @test !isempty(que)
    @test 1 == length(que)

    enqueue!(que, 3, 300)
    @test 2 == length(que)

    # Get key only
    x = dequeue!(que)
    @test 1 == length(que)
    @test 1 == x

    # Get (key,value)
    x = dequeue_pair!(que)
    @test isempty(que)
    @test 3 == x[1]
    @test 300 == x[2]

    # -------------------- #
    # High -> low priority #
    # -------------------- #
    que = PriorityQueue{Int64,Int64}(Base.Order.Reverse)
    @test isempty(que)
    enqueue!(que, 1, 100)
    @test !isempty(que)
    @test 1 == length(que)

    enqueue!(que, 3, 300)
    @test 2 == length(que)

    enqueue!(que, 7, 700)
    @test 3 == length(que)

    # Get key only
    x = dequeue!(que)
    @test 2 == length(que)
    @test 7 == x

    # Get (key,value)
    x = dequeue_pair!(que)
    @test 1 == length(que)
    @test 3 == x[1]
    @test 300 == x[2]
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



A = learn_PriorityQueue()
#A = learn_Queue()
#A = learn_Set()
#A = learn_Stack()

A
