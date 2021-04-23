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
    vertices::Vector{V}      # list of vertices
    # list of edges 
    # edges[i] -> list of edges that connects to vertices[i]
    edges::Vector{Vector{E}} 

    #function UnweightedGraph{V,E}() where {V,E<:Edge}
    function UnweightedGraph{V,E}() where {V,E<:Edge} # is E<:Edge necessary
        #new{V,E}(Vector{V}(), Vector{Vector{E}}())
        new(Vector{V}(), Vector{Vector{E}}())        
    end
end

function UnweightedGraph{V,E}(v::Vector{V}) where {V,E<:Edge}
    me = UnweightedGraph{V,E}() #new{V,E}(Vector{V}(), Vector{Vector{E}}())
    append!(me, v)
    
    return me
end

"""

Append vertices to a graph.
"""
function Base.append!(g::Graph{V,E}, vertices) where {V,E<:Edge}
    append!(g.vertices, vertices)

    # One list of edges for each vertex
    for i in 1:length(vertices)
        push!(g.edges, Vector{Vector{E}}())
    end
end
