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
    
end

function testset_base()
    @testset "Base" begin
        #MyJulia.learn_Node()
        test_Node()
    end

    nothing
end

function testset_all()
    testset_base()
end

# include("test_Julia.jl"); TestJulia.test_Node();
# include("test_Julia.jl"); TestJulia.testset_all()
end