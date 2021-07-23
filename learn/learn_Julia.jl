# Learn basic Julia stuff
using Test

module MyJulia
using Test
# Learn operator overloading
mutable struct Node
    id::Int64

    Node() = ( # incomplete initialization
        me = new();
        me
    )
    Node(id) = (
        me = new();
        me.id = id;
        me
    )
end
# https://discourse.julialang.org/t/proper-way-to-overload-operators/19872

# One can use function name or symbol to implement operator overloading

Base.:(<)(x::Node, y::Node) = x.id < y.id # Base.isless(x::Node, y::Node) = x.id < y.id
function Base.:(==)(x::Node,y::Node) 
    return x.id == y.id
end
# used by sort()
Base.isless(x::Node, y::Node) = error("Unsupported operation")

# isequal => ===
#Base.isequal(x::Node, y::Node) = x.id == y.id


function learn_Node()
    @test Node(7) == Node(7)
    @test Node(7) != Node(13)
    
    @test Node(7) < Node(13)
    @test Node(7) <= Node(13)
    @test Node(13) <= Node(13)

    @test Node(13) > Node(7)
    @test Node(13) >= Node(7)
    @test Node(13) >= Node(13)
end

end # module MyJulia

mj = MyJulia

#mj.learn_Node()

function learn_resize!()
    x = [1,2,3]
    y = x
    @test y === x
    @test 3 == length(y)

    resize!(x, 1)
    @test y === x
    @test 1 == length(y)
    @test 1 == y[1]

    resize!(x, 0)
    @test y === x
    @test isempty(y)
    
end

function learn_searchsortedfirst()
    v = Float64[1, 2, 3, 4, 5]
    
    i = searchsortedfirst(v, 1)
    @test 1 == i

    i = searchsortedfirst(v, 1.5)
    @test 2 == i

    i = searchsortedfirst(v, 2)
    @test 2 == i
end

@testset "Basic" begin
    learn_resize!()
    learn_searchsortedfirst()
end

nothing