# https://github.com/JuliaGraphs/JuliaGraphsTutorials
using Test
using LightGraphs
using GraphPlot

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

    A = [
        0 1 1
        1 0 1
        1 1 0
    ]

    G2 = Graph(A)

    @test G == G2
end
#learn()
pl = learn_Basics()

nothing
