# https://github.com/JuliaGraphs/JuliaGraphsTutorials
using Test
using LightGraphs
using GraphPlot

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
    # 1 - 2 # first dimension
    # |   |
    # 3 - 4
    # |   |
    # 5 - 6
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

## Reading/Writing Graphs

## Operators

## Plotting Graphs

## Path and Traversal

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

io = stdout
#io = devnull

#learn_basic_library_examples(io)
learn_graph_generators(io)
#learn()
#pl = learn_Basics()
#learn_graph_properties(io)
#learn_basic_operations(io)
#learn_set_interface(io)
#learn_dag(io)

nothing
