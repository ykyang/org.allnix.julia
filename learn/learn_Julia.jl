# Learn basic Julia stuff
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

mj.learn_Node()