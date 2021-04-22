include("Classic.jl")

using Test
import .Classic
cc = Classic

function test_Edge()
    e = cc.Edge(2, 7)
    @test 2 == e.u
    @test 7 == e.v
    @test "2 -> 7" == string(e)

    r = cc.reverse(e)
    @test e.v == r.u
    @test e.u == r.v
end

# function test_Graph()
#     g = cc.Graph{Int64,Int64}()
#     @test isempty(g.vertices)
#     @test isempty(g.edges)

#     g = cc.Graph{Int64,cc.Edge}([1,2,3])
#     @test 3 == length(g.vertices)
#     @test [1,2,3] == g.vertices
#     @test 3 == length(g.edges)
# end

function test_UnweightedGraph()
    g = cc.UnweightedGraph{Int64,cc.Edge}()
    #g = cc.UnweightedGraph{Int64,Int64}()
    @test isempty(g.vertices)
    @test isempty(g.edges)

    g = cc.UnweightedGraph{Int64,cc.Edge}([1,2,3])
    @test 3 == length(g.vertices)
    @test [1,2,3] == g.vertices
    @test 3 == length(g.edges)
    @show typeof(g)
    cc.UnweightedGraph{Int64,cc.Edge} <: cc.Graph{Int64,cc.Edge}
end

test_Edge()
# test_Graph()
test_UnweightedGraph()
