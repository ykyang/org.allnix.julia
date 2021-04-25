module Classic

using DataStructures

include("ch2.jl")

include("ch4.jl")
export UnweightedGraph, SimpleEdge, WeightedGraph, WeightedEdge
export DijkstraNode

end