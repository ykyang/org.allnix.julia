include("Classic.jl")

using Test
#using .Classic
import .Classic
#cc = Classic

function init!(g::Classic.Graph{V,E}) where {V,E<:Classic.Edge}
    cc = Classic

    cities = Vector{String}(["Seattle", "San Francisco",  
    "Los Angeles", "Riverside", "Phoenix", "Chicago", "Boston",
    "New York", "Atlanta", "Miami", "Dallas", "Houston", "Detroit",
    "Philadelphia", "Washington",
    ])
    
    append!(g,cities)

    cc.add!(g, "Seattle", "Chicago")
    cc.add!(g, "Seattle","San Francisco")
    cc.add!(g, "San Francisco", "Riverside")
    cc.add!(g, "San Francisco", "Los Angeles")
    cc.add!(g, "Los Angeles", "Riverside")
    cc.add!(g, "Los Angeles", "Phoenix")
    cc.add!(g, "Riverside", "Phoenix")
    cc.add!(g, "Riverside", "Chicago")
    cc.add!(g, "Phoenix", "Houston")
    cc.add!(g, "Dallas", "Chicago")
    cc.add!(g, "Dallas", "Atlanta")
    cc.add!(g, "Dallas", "Houston")
    cc.add!(g, "Houston", "Atlanta")
    cc.add!(g, "Houston", "Miami")
    cc.add!(g, "Atlanta", "Chicago")
    cc.add!(g, "Atlanta", "Washington")
    cc.add!(g, "Atlanta", "Miami")
    cc.add!(g, "Miami", "Washington")
    cc.add!(g, "Chicago", "Detroit")
    cc.add!(g, "Detroit", "Boston")
    cc.add!(g, "Detroit", "Washington")
    cc.add!(g, "Detroit", "Washington")
    cc.add!(g, "Detroit", "New York")
    cc.add!(g, "Boston", "New York")
    cc.add!(g, "New York", "Philadelphia")
    cc.add!(g, "Philadelphia", "Washington")

    return cities
end

function init!(g::Classic.WeightedGraph{V,E}) where {V,E<:Classic.WeightedEdge}
    cc = Classic

    cities = Vector{String}(["Seattle", "San Francisco",  
    "Los Angeles", "Riverside", "Phoenix", "Chicago", "Boston",
    "New York", "Atlanta", "Miami", "Dallas", "Houston", "Detroit",
    "Philadelphia", "Washington",
    ])
    
    append!(g,cities)

    cc.add!(g, "Seattle", "Chicago", 1737);
    cc.add!(g, "Seattle", "San Francisco", 678);
    cc.add!(g, "San Francisco", "Riverside", 386);
    cc.add!(g, "San Francisco", "Los Angeles", 348);
    cc.add!(g, "Los Angeles", "Riverside", 50);
    cc.add!(g, "Los Angeles", "Phoenix", 357);
    cc.add!(g, "Riverside", "Phoenix", 307);
    cc.add!(g, "Riverside", "Chicago", 1704);
    cc.add!(g, "Phoenix", "Dallas", 887);
    cc.add!(g, "Phoenix", "Houston", 1015);
    cc.add!(g, "Dallas", "Chicago", 805);
    cc.add!(g, "Dallas", "Atlanta", 721);
    cc.add!(g, "Dallas", "Houston", 225);
    cc.add!(g, "Houston", "Atlanta", 702);
    cc.add!(g, "Houston", "Miami", 968);
    cc.add!(g, "Atlanta", "Chicago", 588);
    cc.add!(g, "Atlanta", "Washington", 543);
    cc.add!(g, "Atlanta", "Miami", 604);
    cc.add!(g, "Miami", "Washington", 923);
    cc.add!(g, "Chicago", "Detroit", 238);
    cc.add!(g, "Detroit", "Boston", 613);
    cc.add!(g, "Detroit", "Washington", 396);
    cc.add!(g, "Detroit", "New York", 482);
    cc.add!(g, "Boston", "New York", 190);
    cc.add!(g, "New York", "Philadelphia", 81);
    cc.add!(g, "Philadelphia", "Washington", 123);

    return cities
end

function test_SimpleEdge()
    cc = Classic

    e = cc.SimpleEdge(2, 7)
    @test 2 == e[1]
    @test 7 == e[2]
    @test "2 -> 7" == string(e)
    @test 2 == e[1]
    @test 7 == e[2]

    r = cc.reverse(e)
    @test e[1] == r[2]
    @test e[2] == r[1]
end

function test_WeightedEdge()
    cc = Classic

    e = cc.WeightedEdge((3,7),13.0)
    @test 3 == e[1]
    @test 7 == e[2]
    @test 13 == cc.weight(e)

    e = cc.WeightedEdge(3,7,13.0)
    @test 3 == e[1]
    @test 7 == e[2]
    @test 13 == cc.weight(e)

    e = cc.reverse(e)
    @test 3 == e[2]
    @test 7 == e[1]
    @test 13 == cc.weight(e)
end

function test_UnweightedGraph()
    cc = Classic

    @test_throws TypeError cc.UnweightedGraph{Int64,Int64}()
    @test cc.UnweightedGraph{Int64,cc.SimpleEdge}() isa Any

    # V::Int64, E::Edge
    g = cc.UnweightedGraph{Int64,cc.SimpleEdge}()
    @test isempty(g.vertices)
    @test isempty(g.edges_lists)

    g = cc.UnweightedGraph{Int64,cc.SimpleEdge}([1,2,3])
    @test 3 == length(g.vertices)
    @test [1,2,3] == g.vertices
    @test 3 == length(g.edges_lists)

    # V::String, E::Edge
    g = cc.UnweightedGraph{String,cc.SimpleEdge}()
    @test isempty(g.vertices)
    @test isempty(g.edges_lists)

    g = cc.UnweightedGraph{String,cc.SimpleEdge}(["apple", "orange", "guava"])
    @test 3 == length(g.vertices)
    @test ["apple", "orange", "guava"] == g.vertices
    @test 3 == length(g.edges_lists)

    # Learn types
    @test cc.UnweightedGraph{Int64,cc.Edge} <: cc.Graph{Int64,cc.Edge}
    @test isa(cc.UnweightedGraph{Int64,cc.Edge}(), cc.Graph{Int64,cc.Edge})
end

"""

Sovle shortest route of `UnweightedGraph`
"""
function test_bfs()
    cc = Classic

    g = cc.UnweightedGraph{String,cc.SimpleEdge}()
    cities = init!(g)
    @test length(cities) == length(g.vertices)
    @test length(cities) == length(g.edges_lists)
   
    for edges in g.edges_lists
        @test !isempty(edges)
    end

    #show(g)

    is_goal(pt) = cc.is_goal("Miami", pt)
    neighbor_of(v) = cc.neighbor_of(g, v)

    node = cc.bfs("Boston", is_goal, neighbor_of)
    @test ["Boston", "Detroit", "Washington", "Miami"] == cc.node_to_path(node)
    #println("Shortest route: $(cc.node_to_path(node))")

    nothing
end

function test_WeightedGraph()
    cc = Classic

    @test_throws TypeError Classic.WeightedGraph{Int64,Int64}()
    @test cc.WeightedGraph{Int64,cc.WeightedEdge}() isa Any # @test_nothrows

    g = cc.WeightedGraph{Int64,cc.WeightedEdge}([1,2,3])
    @test 3 == length(g.vertices)
    @test [1,2,3] == g.vertices
    @test 3 == length(g.edges_lists)

    g = cc.WeightedGraph{String,cc.WeightedEdge}(["apple", "orange", "guava"])
    @test 3 == length(g.vertices)
    @test ["apple", "orange", "guava"] == g.vertices
    @test 3 == length(g.edges_lists)

    cc.add!(g, "apple", "orange", 13)
    @test 1 == length(g.edges_lists[1])
    @test 1 == length(g.edges_lists[2])
    @test 0 == length(g.edges_lists[3])
end


test_SimpleEdge()
test_WeightedEdge()
# test_Graph()
test_UnweightedGraph()
test_WeightedGraph()
test_bfs()

println("Test completed!")
