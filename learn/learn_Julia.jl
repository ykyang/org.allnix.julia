# Learn basic Julia stuff
module MyJulia
using Test

# Learn operator overloading
struct Node
    id::Int64
end
# https://discourse.julialang.org/t/proper-way-to-overload-operators/19872
Base.:(<)(x::Node, y::Node) = x.id < y.id
function Base.:(==)(x::Node,y::Node) 
    return x.id == y.id
end

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