# https://livebook.manning.com/book/classic-computer-science-problems-in-java/chapter-4/

abstract type Edge end

function Base.getindex(edge::Edge, i::Int64) #where {E<:Edge}
    return edge.vertices[i]
end

function reverse(e::E) where {E<:Edge}
    return E(Base.reverse(e.vertices))
end

Base.string(e::Edge) = "$(e[1]) -> $(e[2])"
Base.show(io::IO, x::Edge) = print(io, string(x))

struct SimpleEdge <: Edge
    # u::Int64
    # v::Int64
    vertices::Tuple{Int64,Int64}
    function SimpleEdge(vertices)
        new(vertices)
    end
    function SimpleEdge(u,v)
        new((u,v))
    end
end

struct WeightedEdge <: Edge
    vertices::Tuple{Int64,Int64}
    weight::Float64
    function WeightedEdge(vertices::Tuple{Int64,Int64}, weight)
        new(vertices, weight)
    end
    function WeightedEdge(u::Int64, v::Int64, weight)
        new((u,v), weight)
    end
end

Base.:(<)(x::WeightedEdge, y::WeightedEdge) = error("Unsupported operation")
function weight(e::WeightedEdge)
    e.weight
end
function reverse(e::WeightedEdge)
    WeightedEdge(e[2], e[1], weight(e))
end


    
abstract type Graph{V,E} end


function add!(g::Graph{V,E}, u::Int64, v::Int64) where {V,E<:Edge}
    add!(g, E(u,v))
end

"""

This is why cities cannot have the same name.
"""
function add!(g::Graph{V,E}, u::V, v::V) where {V,E<:Edge}
    add!(g, index_of(g, u), index_of(g, v))
end

function add!(g::Graph{V,E}, edge::Edge) where {V,E<:Edge}
    edges = edges_of(g, edge[1]) #g.edges_lists[edge.u]
    push!(edges, edge)

    edges = edges_of(g, edge[2]) #g.edges_lists[edge.v]
    push!(edges, reverse(edge))

    nothing
end


"""
    Base.append!(g::Graph{V,E}, vertices) where {V,E<:Edge}

Append vertices to a graph.  Creates empty edge lists for each vertex.
"""
function Base.append!(g::Graph{V,E}, vertices) where {V,E<:Edge} # is <:Edge necessary, could be more generic later
    append!(g.vertices, vertices)

    # One list of edges for each vertex
    for i in 1:length(vertices)
        push!(g.edges_lists, Vector{Vector{E}}())
    end
end

function edges_of(g::Graph{V,E}, v::V) where {V,E<:Edge}
    index = index_of(g, v)
    return edges_of(g, index)
end

function edges_of(g::Graph{V,E}, index::Int64)  where {V,E<:Edge}
    return g.edges_lists[index]
end

"""

This is why cities cannot have the same name.
"""
function index_of(g::Graph{V,E}, v::V) where {V,E<:Edge}
    findfirst(x->x==v, g.vertices)
end

function neighbor_of(g::Graph{V,E}, v::V) where {V,E<:Edge}
    index = index_of(g, v)
    return neighbor_of(g, index)
end

function neighbor_of(g::Graph{V,E}, index::Int64) where {V,E<:Edge}
    edges = g.edges_lists[index]
    
    neighbors = Vector{V}()
    for edge in edges
        push!(neighbors, vertex_at(g, edge[2]))
    end

    return neighbors
end

function vertex_at(g::Graph{V,E}, index::Int64) where {V,E<:Edge}
    return g.vertices[index]
end

function Base.show(io::IO, g::Graph)
    for v in g.vertices
        print(io, "$v -> $(neighbor_of(g, v))")
        
        println(io)
    end 
end

struct UnweightedGraph{V,E<:Edge} <: Graph{V,E}
    vertices::Vector{V}            # list of vertices
    edges_lists::Vector{Vector{E}} # edges_lists[i] -> list of edges that connects to vertices[i]

    function UnweightedGraph{V,E}() where {V,E<:Edge} # is E<:Edge necessary
        new(Vector{V}(), Vector{Vector{E}}())        
    end
end

function UnweightedGraph{V,E}(v::Vector{V}) where {V,E<:Edge}
    me = UnweightedGraph{V,E}()
    append!(me, v)
    
    return me
end

struct WeightedGraph{V,E<:WeightedEdge} <: Graph{V,E}
    vertices::Vector{V}            # list of vertices
    edges_lists::Vector{Vector{E}} # edges_lists[i] -> list of edges that connects to vertices[i]

    function WeightedGraph{V,E}() where {V,E<:WeightedEdge} # is E<:Edge necessary
        new(Vector{V}(), Vector{Vector{E}}())        
    end
end

function WeightedGraph{V,E}(v::Vector{V}) where {V,E<:WeightedEdge}
    me = WeightedGraph{V,E}()
    append!(me, v)
    
    return me
end

function add!(g::WeightedGraph{V,E}, u::Int64, v::Int64, w) where {V,E<:WeightedEdge}
    add!(g, E(u,v,w))
end

function add!(g::WeightedGraph{V,E}, u::V, v::V, w) where {V,E<:WeightedEdge}
    add!(g, index_of(g, u), index_of(g, v), w)
end