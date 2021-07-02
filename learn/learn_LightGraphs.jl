# https://github.com/JuliaGraphs/JuliaGraphsTutorials
using Test
using LightGraphs
using GraphPlot
using Compose


## Getting Started

# https://juliagraphs.org/LightGraphs.jl/latest/#Basic-library-examples
function learn_basic_library_examples(io::IO)
    # A path that connect 1 vertex to the next
    g = path_graph(6)
    @test 6 == nv(g)
    @test 5 == ne(g)
    
    add_edge!(g, 1, 6) # connect first and last
    @test 6 == nv(g)
    @test 6 == ne(g)
end


## Making and Modifying Graphs

# https://juliagraphs.org/LightGraphs.jl/latest/generators/#Graph-Generators
function learn_graph_generators(io::IO)
    # 1 - 3 - 5
    # |   |   |
    # 2 - 4 - 6
    g = grid([2,3], periodic=false)
    @test 6 == nv(g)
    @test 7 == ne(g)

    plt = gplot(g, nodelabel=1:nv(g), edgelabel=1:ne(g))
    display(plt)    

    # Numbering follow the 1st dimension first then 2nd dimension
    g = grid([10,5], periodic=false)
    plt = gplot(g, nodelabel=1:nv(g))
    display(plt)    
end
function learn_modifying_graphs()
    # 1 - 3 - 5
    # |   |   |
    # 2 - 4 - 6
   
    # Remove an edge
    g = grid([2,3], periodic=false)
    @test 7 == ne(g)
    @test has_edge(g, 5,6)
   
    @test rem_edge!(g, 5,6)
    @test 6 == ne(g)
    @test !has_edge(g, 5,6)

    # Add existing edge does not change the graph
    g = grid([2,3], periodic=false)
    @test 7 == ne(g)
    @test !add_edge!(g, 5,6)
    @test 7 == ne(g)
end

## Reading/Writing Graphs

## Operators

## Plotting Graphs

## Path and Traversal
function learn_bfs_tree()
    # 1 - 3 - 5
    # |   |   |
    # 2 - 4 - 6
    g = grid([2,3], periodic=false) 
    #display(gplot(g, nodelabel=1:nv(g), edgelabel=1:ne(g)))

    bfs = bfs_tree(g, 1)
    # 6 <- 4 <- 2 <- 1 -> 3 -> 5
    #display(gplot(bfs, nodelabel=1:nv(bfs), edgelabel=1:ne(bfs)))
    draw(SVG("bfs_tree.svg", 16cm, 16cm), gplot(bfs, nodelabel=1:nv(bfs), edgelabel=1:ne(bfs)))

    @test 6 == nv(bfs)
    @test 5 == ne(bfs)

    edge = first(edges(bfs)) 
    @test edge isa LightGraphs.SimpleGraphs.SimpleEdge
    @test 1 == src(edge)
    @test 2 == dst(edge)    
end

function learn_dijkstra_shortest_paths(dp)
    g = grid([2,2], periodic=false)

    # weight matrix
    w = [
        0 2 2 0;    # distance of v1 to v1-v4
        2 0 0 100;  # distance of v2 to v1-v4
        2 0 0 50;
        0 100 50 0;
    ] 

    edgelabel = Vector{String}(undef, ne(g))
    for (i,e) in enumerate(edges(g))
        #@show i, e
        edgelabel[i] = string(w[e.src, e.dst])
    end
    ds = dijkstra_shortest_paths(g, 1, w)
    #@show ds
    #@show ds.dists

    plt = gplot(g, nodelabel=1:nv(g), edgelabel=edgelabel)
    display(plt)

    return ds
end

function learn_dijkstra_shortest_paths_2(dp)
    g = grid([2,2], periodic=false)
    
    # Assign permeability to each grid block (vertex)
    k = Float64.([100 100 50 1]) .* 0.01

    # Calculate transmissibility
    R = Matrix{Float64}(undef, nv(g), nv(g)) # resistance
    for edge in edges(g)
        src = edge.src
        dst = edge.dst
        r = 0.5*(1/k[src] + 1/k[dst])
        R[src,dst] = r
        R[dst,src] = r # symmetric
    end

    edgelabel = Vector{String}(undef, ne(g))
    for (i,e) in enumerate(edges(g))
        edgelabel[i] = string(R[e.src, e.dst])
    end

    ds = dijkstra_shortest_paths(g, 1, R)
    @info "Distance from Vertex 1 to: $(ds.dists)"

    if dp
        plt = gplot(g, nodelabel=1:nv(g), edgelabel=edgelabel)
        display(plt)
    end
end

## Distance

function learn()
    g = path_graph(0)

    @show g
    @show nv(g)
    @show ne(g)

    add_vertex!(g)
    add_vertex!(g)

    for v in vertices(g)
        @show v, typeof(v)
    end
end

# https://nbviewer.jupyter.org/github/JuliaGraphs/JuliaGraphsTutorials/blob/master/Basics.ipynb
function learn_Basics()
    # Graph -> SimpleGraph
    G = Graph(3) # graph with 3 vertices

    # make a triangle
    add_edge!(G, 1, 2)
    add_edge!(G, 1, 3)
    add_edge!(G, 2, 3)

    plt = gplot(G, nodelabel=1:3)
    display(plt)

    # Adjacency matrix
    A = [
        0 1 1 # node 1 connects to 2, 3
        1 0 1
        1 1 0
    ]

    G2 = Graph(A)

    @test G == G2
end

# https://nbviewer.jupyter.org/github/JuliaGraphs/JuliaGraphsTutorials/blob/master/Basics.ipynb#Graph-properties
function learn_graph_properties(io::IO)
    G = smallgraph("house")
    nvertices = nv(G)
    nedges = ne(G)

    # Get vertices
    for v in vertices(G)
        println(io, "vertex $v")
    end

    # Get edges
    for e in edges(G)
        u = src(e)
        v = dst(e)
        println(io, "edge $u - $v")
    end

    plt = gplot(G, nodelabel=1:nvertices, edgelabel=1:nedges)
    display(plt)
end

# https://nbviewer.jupyter.org/github/JuliaGraphs/JuliaGraphsTutorials/blob/master/Basics.ipynb#Basic-operations
function learn_basic_operations(io::IO)
    G = Graph()
    add_vertices!(G, 3)
    add_vertices!(G, 2)

    add_edge!(G, 1, 2)
    add_edge!(G, 1, 3)
    add_edge!(G, 2, 4)
    add_edge!(G, 3, 4)
    add_edge!(G, 3, 5)
    add_edge!(G, 4, 5)

    plt = gplot(G, nodelabel=1:nv(G), edgelabel=1:ne(G))
    display(plt)

    # add vertex
    add_vertex!(G)
    add_edge!(G, 5, 6)

    plt = gplot(G, nodelabel=1:nv(G), edgelabel=1:ne(G))
    display(plt)

    # remove vertex
    rem_vertex!(G, 1)
    plt = gplot(G, nodelabel=1:nv(G), edgelabel=1:ne(G))
    display(plt)
end

function learn_set_interface(io::IO)
    skeleton = Graph(11)
    add_edge!(skeleton, 1, 2)
    add_edge!(skeleton, 2, 3)
    add_edge!(skeleton, 3, 4)
    add_edge!(skeleton, 4, 5)
    add_edge!(skeleton, 3, 6)
    add_edge!(skeleton, 3, 7)
    add_edge!(skeleton, 3, 8)
    add_edge!(skeleton, 3, 9)
    add_edge!(skeleton, 9, 10)
    add_edge!(skeleton, 9, 11)

    plt = gplot(skeleton)
    display(plt)

    □ = Graph(4)
    add_edge!(□, 1, 2)
    add_edge!(□, 1, 3)
    add_edge!(□, 2, 4)
    add_edge!(□, 3, 4)

    plt = gplot(cartesian_product(□, skeleton))
    display(plt)
end

# https://nbviewer.jupyter.org/github/JuliaGraphs/JuliaGraphsTutorials/blob/master/DAG-Julia-Pkgs.ipynb
function learn_dag(io)
    G = smallgraph("house")
    
    plt = gplot(G, nodelabel=1:nv(G), edgelabel=1:ne(G))
    display(plt)

    @show gdistances(G, 5)
end

function learn_MetaGraphs(io)
end

#default_logger = global_logger()
#global_logger(ConsoleLogger(stdout, Logging.Info))

io = stdout
#io = devnull

# Display Plot
dp = true
dp = false 

@testset "Base" begin
    #learn_basic_library_examples(io)
    #learn_graph_generators(io)
    learn_modifying_graphs()
    #ds = learn_dijkstra_shortest_paths(dp)
    learn_bfs_tree()

    #learn_dijkstra_shortest_paths_2(dp)
    #learn()
    #pl = learn_Basics()
    #learn_graph_properties(io)
    #learn_basic_operations(io)
    #learn_set_interface(io)
    #learn_dag(io)
end
#global_logger(default_logger) # Restore global logger
nothing
