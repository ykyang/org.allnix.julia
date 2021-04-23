include("Classic.jl")

using Test
import .Classic
cc = Classic

function init!(g::cc.Graph{V,E}) where {V,E<:cc.Edge}
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
    @test_throws TypeError cc.UnweightedGraph{Int64,Int64}()

    # V::Int64, E::Edge
    g = cc.UnweightedGraph{Int64,cc.Edge}()
    @test isempty(g.vertices)
    @test isempty(g.edges_lists)

    g = cc.UnweightedGraph{Int64,cc.Edge}([1,2,3])
    @test 3 == length(g.vertices)
    @test [1,2,3] == g.vertices
    @test 3 == length(g.edges_lists)

    # V::String, E::Edge
    g = cc.UnweightedGraph{String,cc.Edge}()
    @test isempty(g.vertices)
    @test isempty(g.edges_lists)

    g = cc.UnweightedGraph{String,cc.Edge}(["apple", "orange", "guava"])
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
    g = cc.UnweightedGraph{String,cc.Edge}()
    cities = init!(g)
    @test length(cities) == length(g.vertices)
    @test length(cities) == length(g.edges_lists)
   
    for edges in g.edges_lists
        @test !isempty(edges)
    end

    show(g)

    is_goal(pt) = cc.is_goal("Miami", pt)
    neighbor_of(v) = cc.neighbor_of(g, v)

    node = cc.bfs("Boston", is_goal, neighbor_of)
    @test ["Boston", "Detroit", "Washington", "Miami"] == cc.node_to_path(node)
    println("Shortest route: $(cc.node_to_path(node))")

    nothing
end

#test_Edge()
# test_Graph()
test_UnweightedGraph()
test_bfs()
