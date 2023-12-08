"""
Utility and convenience stuff
"""
module Learn

using CircularArrays

"""
    @log msg

Construct a `String` with `string(s1, s2, \$msg)`.
If variable `indent` is defined then `s1 = indent` otherwise
`s1 = ""`.  If variable `tab` is defined then `s2 = tab` otherwise
`s2 = ""`.
"""
macro log(msg)
    esc(quote
        local s1 = (@isdefined indent) && isa(indent,AbstractString) ? indent : ""
        local s2 = (@isdefined tab)    && isa(tab,AbstractString)    ? tab    : ""
        string(s1, s2, $msg)
    end)
end

"""
    @log n msg

Construct a `String` with `string(s1, s2^\$n, \$msg)`.
If variable `indent` is defined then `s1 = indent` otherwise
`s1 = ""`.  If variable `tab` is defined then `s2 = tab` otherwise
`s2 = ""`.

This is used for constructing indented log message.
"""
macro log(n, msg)
    esc(quote
        local s1 = (@isdefined indent) && isa(indent,AbstractString) ? indent : ""
        local s2 = (@isdefined tab)    && isa(tab,AbstractString)    ? tab    : ""
        string(s1, s2^$n, $msg)
    end)
end
"""
    @log tab n msg

Construct a `String` with `string(s1, \$tab^\$n, \$msg)`.
If variable `indent` is defined then `s1 = indent` otherwise
`s1 = ""`.

This is used for constructing indented log message.
"""
macro log(tab, n, msg)
    esc(quote
        local s1 = (@isdefined indent) && isa(indent,AbstractString) ? indent : ""
        string(s1, $tab^$n, $msg)
    end)
end
"""
    @log indent tab n msg

Construct a `String` with `string(\$indent, \$tab^\$n, \$msg)`.

This is used for constructing indented log message.
"""
macro log(indent, tab, n, msg)
    esc(quote
        string($indent, $tab^$n, $msg)
    end)
end

"""
    showrepl(x;io=stdout)

Print in REPL style format.
"""
function showrepl(x;io=stdout)
    # https://discourse.julialang.org/t/how-to-get-a-function-to-print-stuff-with-repl-like-formatting/45877/4
    show(io,"text/plain",x)
    println(io)
end


struct Node{T<:Real,G}
    value::T
    group::G
    ind::Int
end

function Base.:(==)(x::Node,y::Node) 
    return x.group == y.group && x.value == y.value
end
Base.isless(x::Node, y::Node) = x.value < y.value
function Base.hash(n::Node, h::UInt)
    return hash(n.value, hash(n.group,h))
end

"""
    intersect(us,vs; epsilon)

Find `(u,v)` pairs from `us` and `vs` that are closest to each other.  Two points
are not "close" if the distance is greater then `epsilon`.

The basic idea is
* Combine `u` and `v` into one array, `a_nodes`
* Sort `a_nodes`
* Calculate the distance between `u` and `v`, `a_deltas`
    * Distance is set to `Inf` between `u` and `u` or between `v` and `v`
* For each `u`, find the shorter distance between left and right neighbors, `a_u_deltas`
* For each `v`, find the shorter distance between left and right neighbors, `a_v_deltas`
* Find the deltas that both `u` and `v` found to be the shortest, `a_uv_deltas`
* Pair up the `u` and `v` that enclose the shortest deltas

# Examples

* `u3 == v3`
* `a_deltas[0] == a_deltas[end]` because `CircularArray`

```
a_nodes
   1       2     3       4       5 6            7     8           9     10
   u1      u2    v1      v2      u3v3           u4    u5          v4    u6  
---+-------+-----+-------+-------+-+------------+-----+-----------+-----+---
 ∞     ∞      Δ      ∞       Δ    Δ      Δ         ∞     Δ>ε → ∞     Δ     ∞
 0     1      2      3       4    5      6         7        8        9     10
a_deltas


a_u_deltas
 x u1  x   u2 o              x   u3      o      u4 x  u5     x       o  u6 x
---+-------+-----+-------+-------+o+------------+-----+-----------+-----+---
              o  v1  x   v2  o     v3    x                   x    v4 o
a_v_deltas


If delta == `o` on both sides then form a pair of (u,v),
a_uv_deltas
           u2 o                  u3                                  o  u6
---+-------+-----+-------+-------+o+------------+-----+-----------+-----+---
              o  v1                v3                             v4 o

so (u2,v1), (u3,v3), (u6,v4)
```
"""
function intersect(us,vs; epsilon)
    if us == vs
        return 1:length(us), 1:length(vs)
    end
    if epsilon == 0
        common = Set(Base.intersect(us, vs))
        u_inds = findall(in(common), us)
        v_inds = findall(in(common), vs)
        return u_inds,v_inds
    end
    ## a_nodes combines values from us, vs
    ## a_nodes is sorted
    ## a stands for all
    a_nodes = let
        ## Convert values into Node
        u_nodes = [Node(u, 'u', i) for (i,u) in enumerate(us)]
        v_nodes = [Node(v, 'v', i) for (i,v) in enumerate(vs)]
        ## All nodes
        a_nodes = vcat(u_nodes,v_nodes)
        a_nodes = sort(a_nodes)

        a_nodes
    end
    ## Delta between adjacent nodes
    ## Delta between nodes of the same group is Inf
    ## Last one is Inf
    ## Delta is stored in a CircularArray so no need to worry about boundary condition
    a_deltas = CircularArray(fill(typemax(Float64), size(a_nodes))) #Vector{Float64}(-9999.0, length(a_nodes)-1)
    for i in 1:length(a_nodes)-1
        if a_nodes[i].group != a_nodes[i+1].group
            delta = a_nodes[i+1].value - a_nodes[i].value
            a_deltas[i] = delta > epsilon ? Inf : delta
        end
    end
    ## Slower
    # for (i,(n1,n2)) in enumerate(zip(a_nodes[1:end-1],a_nodes[2:end]))
    #     if n1.group != n2.group
    #         delta = n2.value - n1.value
    #         a_deltas[i] = delta > epsilon ? Inf : delta
    #     end
    # end

    ## Do u and v separately
    ## instead of detecting it is u or v in a loop
    ## hopefuly this is faster
    ## Foreach u, find the v on the left or right that is closer
    ## true is closer, Inf is false
    a_u_deltas = CircularArray(fill(false, size(a_deltas)))
    a_u_inds = findall(x -> x.group == 'u', a_nodes) # inds of u in a_nodes
    for i in a_u_inds
        if a_deltas[i-1] < a_deltas[i]  # IMPORTANT: <
            #a_u_deltas[i-1] = true # left is closer
            a_u_deltas[i-1] = !isinf(a_deltas[i-1]) #true # left is closer
        else 
            a_u_deltas[i]   = !isinf(a_deltas[i]) #true   # right is closer
            #a_u_deltas[i]   = true   # right is closer
        end
    end
    ## slower
    # Us = a_u_inds
    # Ts = a_deltas[Us .- 1] .< a_deltas[Us] # size(Us)
    # a_u_deltas[Us[Ts] .- 1]        .= true
    # a_u_deltas[Us[map(!,Ts)]] .= map(!,isinf.(a_deltas[Us[map(!,Ts)]]))
    
    ## Foreach v, find the u on the left or right that is closer
    ## true is closer, Inf is false
    a_v_deltas = CircularArray(fill(false, size(a_deltas)))
    a_v_inds = findall(x -> x.group == 'v', a_nodes) # inds of v in a_nodes
    for i in a_v_inds
        if a_deltas[i-1] <= a_deltas[i] # IMPORTANT: <=
            a_v_deltas[i-1] = !isinf(a_deltas[i-1]) #true # left is closer
            #a_v_deltas[i-1] = true # left is closer
        else
            #a_v_deltas[i]   = true   # right is closer 
            a_v_deltas[i]   = !isinf(a_deltas[i]) #true   # right is closer
        end
    end
    
    a_u_delta_inds = findall(a_u_deltas) # a_delta ind where u is closest to v
    a_v_delta_inds = findall(a_v_deltas) # a_delta ind where v is closest to u
    ## u and v agree they are closest then they are coupled
    a_uv_delta_inds = Base.intersect(a_u_delta_inds, a_v_delta_inds)

    u_inds = Int[]
    v_inds = Int[]
    for ind in a_uv_delta_inds
        for I in [ind,ind+1] # left, right of delta
            if a_nodes[I].group == 'u'
                push!(u_inds, a_nodes[I].ind)
             else
                push!(v_inds, a_nodes[I].ind)
             end
        end
    end
    return u_inds, v_inds
    
    ## Not faster
    # u_inds = fill(false, size(us))
    # v_inds = fill(false, size(vs))
    # for ind in a_uv_delta_inds
    #     for I in [ind,ind+1] # left, right of delta
    #         if a_nodes[I].group == 'u'
    #             u_inds[a_nodes[I].ind] = true
    #          else
    #             v_inds[a_nodes[I].ind] = true
    #          end
    #     end
    # end
    # u_inds = findall(u_inds)
    # v_inds = findall(v_inds)
    # return u_inds, v_inds

    ## Not faster
    # u_inds = Vector{Int}(undef,size(us))
    # v_inds = Vector{Int}(undef,size(vs))
    # u_ind = 0; v_ind=0;
    # for ind in a_uv_delta_inds
    #     for I in [ind,ind+1] # left, right of delta
    #         if a_nodes[I].group == 'u'
    #             u_ind += 1; u_inds[u_ind] = a_nodes[I].ind; 
    #          else
    #             v_ind += 1; v_inds[v_ind] = a_nodes[I].ind;
    #          end
    #     end
    # end
    # return u_inds[1:u_ind], v_inds[1:v_ind]
end



# macro replshow(x)
#     return :( 
#         show(stdout, "text/plain", repr(begin local value = $(esc(x)) end));
#         println(stdout);
#     )
# end

export intersect, @log, showrepl
end