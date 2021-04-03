using LightGraphs

g = path_graph(0)

@show g
@show nv(g)
@show ne(g)

add_vertex!(g)
add_vertex!(g)

for v in vertices(g)
    @show v, typeof(v)
end


nothing
