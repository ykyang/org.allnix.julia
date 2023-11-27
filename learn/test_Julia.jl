include("learn_Julia.jl")

module TestJulia
using Test
using ..LearnJulia

function test_Node()
    @test Node() == Node()
    @test Node() == Node(0)

    @test Node(7) == Node(7)
    @test Node(7) != Node(13)
    
    @test Node(7) < Node(13)
    @test Node(7) <= Node(13)
    @test Node(13) <= Node(13)

    @test Node(13) > Node(7)
    @test Node(13) >= Node(7)
    @test Node(13) >= Node(13)

    ## sort
    nodes = Node[]
    push!(nodes, Node(7))
    push!(nodes, Node(1))
    push!(nodes, Node(3))
    push!(nodes, Node(5))
    
    sort!(nodes)
    @test nodes == [Node(1), Node(3), Node(5), Node(7)]

    ## set
    nodes = Set{Node}()
    push!(nodes, Node(1))
    push!(nodes, Node(3))
    push!(nodes, Node(5))
    push!(nodes, Node(1))
    push!(nodes, Node(3))
    push!(nodes, Node(5))
    @test length(nodes) == 3

    ## map
    nodes = Dict{Node,Any}()
    nodes[Node(1)] = 1
    nodes[Node(5)] = 5
    nodes[Node(3)] = 3
    nodes[Node(1)] = 1
    nodes[Node(5)] = 5
    nodes[Node(3)] = 3
    @test length(nodes) == 3
    @test nodes[Node(1)] == 1
    @test nodes[Node(5)] == 5
    @test nodes[Node(3)] == 3

    nothing
end

function test_OrderedPair()
    @test_throws MethodError    OrderedPair()    
    @test_throws ErrorException OrderedPair(2,1)
    
    x = OrderedPair(1,2)
    @test x.x <= x.y
    x = OrderedPair(1,1)
    @test x.x <= x.y
    @test_throws ErrorException x.x = 2

    @test OrderedPair(1,2) == OrderedPair(1,2)
    @test OrderedPair(3)   == OrderedPair(3,3)


end

function testset_base()
    @testset "Base" begin
        #MyJulia.learn_Node()
        test_Node()
        test_OrderedPair()
    end

    nothing
end

function testset_all()
    testset_base()
end

# include("test_Julia.jl"); TestJulia.test_Node();
# include("test_Julia.jl"); TestJulia.testset_all()
end