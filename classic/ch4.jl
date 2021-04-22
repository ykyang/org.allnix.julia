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
    
struct Graph{V,E}
    vertices::Vector{V}      # list of vertices
    # list of edges 
    # edges[i] -> list of edges that connects to vertices[i]
    edges::Vector{Vector{E}} 

    function Graph{V,E}() where {V,E}
        new{V,E}(Vector{V}(), Vector{Vector{E}}())
    end

    function Graph{V,E}(v::Vector{V}) where {V,E}
        me = new{V,E}(Vector{V}(), Vector{Vector{E}}())
        
        append!(me.vertices, v)
        for i in 1:length(v)
            push!(me.edges, Vector{Vector{E}}())
        end

        return me
    end
end

struct UnweightedGraph{V} <: Graph{V,Edge}
end