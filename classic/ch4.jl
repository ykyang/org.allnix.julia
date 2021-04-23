# https://livebook.manning.com/book/classic-computer-science-problems-in-java/chapter-4/

struct Edge
    u::Int64
    v::Int64
end

function reverse(e::Edge)
    return Edge(e.v, e.u)
end

Base.string(e::Edge) = "$(e.u) -> $(e.v)"
Base.show(io::IO, x::Edge) = print(io, string(x))
    
abstract type Graph{V,E} end

# struct Graph{V,E}
#     vertices::Vector{V}      # list of vertices
#     # list of edges 
#     # edges[i] -> list of edges that connects to vertices[i]
#     edges::Vector{Vector{E}} 

#     function Graph{V,E}() where {V,E}
#         new{V,E}(Vector{V}(), Vector{Vector{E}}())
#     end

#     function Graph{V,E}(v::Vector{V}) where {V,E}
#         me = new{V,E}(Vector{V}(), Vector{Vector{E}}())
        
#         append!(me.vertices, v)
#         for i in 1:length(v)
#             push!(me.edges, Vector{Vector{E}}())
#         end

#         return me
#     end
# end

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

"""

This is why cities cannot have the same name.
"""
function add!(g::Graph{V,E}, u::V, v::V) where {V,E<:Edge}
    add!(g, index_of(g, u), index_of(g, v))
end

function add!(g::Graph{V,E}, u::Int64, v::Int64) where {V,E<:Edge}
    add!(g, Edge(u,v))
end

function add!(g::Graph{V,E}, edge::Edge) where {V,E<:Edge}
    edges = edges_of(g, edge.u) #g.edges_lists[edge.u]
    push!(edges, edge)

    edges = edges_of(g, edge.v) #g.edges_lists[edge.v]
    push!(edges, reverse(edge))

    nothing
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
        push!(neighbors, vertex_at(g, edge.v))
    end

    return neighbors
end

function vertex_at(g::Graph{V,E}, index::Int64) where {V,E<:Edge}
    return g.vertices[index]
end


"""

Append vertices to a graph.  Creates empty edge lists for each vertex.
"""
function Base.append!(g::Graph{V,E}, vertices) where {V,E<:Edge} # is <:Edge necessary, could be more generic later
    append!(g.vertices, vertices)

    # One list of edges for each vertex
    for i in 1:length(vertices)
        push!(g.edges_lists, Vector{Vector{E}}())
    end
end

function Base.show(io::IO, g::Graph)
    for v in g.vertices
        print(io, "$v -> $(neighbor_of(g, v))")
        
        println(io)
    end
    
end