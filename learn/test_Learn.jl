include("Learn.jl")

module TestLearn
#using Revise

using Test
using ..Learn

function test_log()
    ## indent, tab not defined
    @test (@isdefined indent) == false
    @test (@isdefined tab)    == false
    @test (@log   "Hello World!")    == "Hello World!"
    @test (@log 3 "Hello World!")    == "Hello World!"

    ## tab not defined
    let indent = "--" # tab not defined
        @test (@isdefined tab) == false
        @test (@log   "Hello World!")    == "--Hello World!"
        @test (@log 3 "Hello World!")    == "--Hello World!"
    end
    
    ## indent, tab defined
    indent = "--"; tab = "+"
    @test (@log   "Hello World!")     == "--+Hello World!"
    @test (@log 3 "Hello World!")     == "--+++Hello World!"

    ## Ignore non-strinng tab
    indent="--"; tab = 10; 
    @test (@log   "Hello World!")     == "--Hello World!"
    @test (@log 3 "Hello World!")     == "--Hello World!"
    
    ## overwrite with inline tab
    indent="--"; tab = "-"; 
    @test (@log "+" 3 "Hello World!") == "--+++Hello World!"

    ## overwrite with inline indent, tab
    indent="--"; tab = "-"; 
    @test (@log "+++" "-" 2 "Hello World!") == "+++--Hello World!"

    nothing
end

function test_intersect()
    T = Float64
    epsilon = 0.5

    as = T[1, 2, 3, 4, 5]
    bs = T[1, 2, 3, 4, 5]
    (a_inds,b_inds) = Learn.intersect(as, bs; epsilon=epsilon)
    @test a_inds == [1,2,3,4,5]
    @test b_inds == [1,2,3,4,5]

    ## forward
    as = T[   2, 3, 4, 5]
    bs = T[1, 2, 3, 4,]
    (a_inds,b_inds) = Learn.intersect(as, bs; epsilon=epsilon)
    @test a_inds == [1,2,3]
    @test b_inds == [2,3,4]
    ## reverse
    (b_inds,a_inds) = Learn.intersect(bs, as; epsilon=epsilon)
    @test a_inds == [1,2,3]
    @test b_inds == [2,3,4]

    ## forward
    as = T[   1.6, 2.2,    2.9,    4,  5]
    bs = T[1,        2,      3,    4,   ]
    (a_inds,b_inds) = Learn.intersect(as, bs; epsilon=epsilon)
    @test a_inds == [2,3,4]
    @test b_inds == [2,3,4]
    ## reverse
    (b_inds,a_inds) = Learn.intersect(bs, as; epsilon=epsilon)
    @test a_inds == [2,3,4]
    @test b_inds == [2,3,4]

    ## forward
    as = T[    1.9, 2.2,   3, 3.1,  3.8, 4.1,  5.01]
    bs = T[1,    2,        3,            4,    5.1]
    (a_inds,b_inds) = Learn.intersect(as, bs; epsilon=epsilon)
    @test a_inds == [1, 3, 6, 7]
    @test b_inds == [2, 3, 4, 5]
    ## reverse
    (b_inds,a_inds) = Learn.intersect(bs, as; epsilon=epsilon)
    @test a_inds == [1, 3, 6, 7]
    @test b_inds == [2, 3, 4, 5]

    ## forward
    as = T[1,  1.9, 2.2,   3, 3.1,  3.8, 4.1,  5.01]
    bs = T[      2,        3,            4,    5.1]
    (a_inds,b_inds) = Learn.intersect(as, bs; epsilon=epsilon)
    @test a_inds == [2, 4, 7, 8]
    @test b_inds == [1, 2, 3, 4]
    ## reverse
    (b_inds,a_inds) = Learn.intersect(bs, as; epsilon=epsilon)
    @test a_inds == [2, 4, 7, 8]
    @test b_inds == [1, 2, 3, 4]
    
    ## forward
    as = T[1,    2.0,  2.1,  2.2    ]
    bs = T[1,          2.1,        3]
    (a_inds,b_inds) = Learn.intersect(as, bs; epsilon=epsilon)
    @test a_inds == [1,3]
    @test b_inds == [1,2]
    ## backward
    (b_inds,a_inds) = Learn.intersect(bs, as; epsilon=epsilon)
    @test a_inds == [1,3]
    @test b_inds == [1,2]


    epsilon = 0.5
    us = T[1,    2,     3,    4     ]
    vs = T[  1.5,   2.5,  3.5,      ]
    u_inds,v_inds = Learn.intersect(us,vs; epsilon=epsilon)
    @test u_inds == [1,2,3]
    @test v_inds == [1,2,3]
    ## non-symmetric
    v_inds,u_inds = Learn.intersect(vs,us; epsilon=epsilon)
    @test u_inds == [2,3,4]
    @test v_inds == [1,2,3]

    epsilon = 0.5
    us = T[1,    2,     3,    4       ]
    vs = T[  1.5,   2.5,  3.5,    4.5 ]
    u_inds,v_inds = Learn.intersect(us,vs; epsilon=epsilon)
    @test u_inds == [1,2,3,4]
    @test v_inds == [1,2,3,4]
    ## non-symmetric
    v_inds,u_inds = Learn.intersect(vs,us; epsilon=epsilon)
    @test u_inds == [2,3,4]
    @test v_inds == [1,2,3]

    #N = 167686
    N = 1_000_000
    #N = 10
    T = Float64
    epsilon = 0.5

    us = Vector{T}(1:N)
    vs = Vector{T}(1:N)
    @time "   us == vs" u_inds,v_inds = Learn.intersect(us,vs; epsilon=0)
    @test u_inds == 1:N
    @test v_inds == 1:N

    us = Vector{T}(1:N)
    vs = Vector{T}(2:N+1)
    @time "      ε = 0" u_inds,v_inds = Learn.intersect(us,vs; epsilon=0)
    @test u_inds == 2:N
    @test v_inds == 1:N-1

    us = Vector{T}(1:N)
    vs = Vector{T}(1:N); vs .= vs .+ 0.1
    @time "ε=0, 0 pair" u_inds,v_inds = Learn.intersect(us,vs; epsilon=0)
    @test isempty(u_inds)
    @test isempty(v_inds)

    us = Vector{T}(1:N)
    vs = Vector{T}(1:N); vs .= vs .+ 0.1
    @time "     comp Δ" u_inds,v_inds = Learn.intersect(us,vs; epsilon=epsilon)
    @test u_inds == 1:N
    @test v_inds == 1:N

    us = Vector{T}(1:N)
    vs = Vector{T}(1:N); vs .= vs .+ 0.5
    @time "     comp Δ" u_inds,v_inds = Learn.intersect(us,vs; epsilon=0.5)
    @test u_inds == 1:N
    @test v_inds == 1:N
    ## non-symmetric
    @time "     comp Δ" v_inds,u_inds = Learn.intersect(vs,us; epsilon=0.5)
    @test u_inds == 2:N
    @test v_inds == 1:N-1

    us = Vector{T}(1:N)
    vs = Vector{T}(1:N); vs .= vs .+ 0.5
    vs = vcat(vs[1:1000], vs[2000:N])
    @time "     comp Δ" u_inds,v_inds = Learn.intersect(us,vs; epsilon=0.5)
    @test u_inds == vcat(1:1000,2000:N)
    @test v_inds == 1:length(vs)
    ## non-symmetric
    @time "     comp Δ" v_inds,u_inds = Learn.intersect(vs,us; epsilon=0.5)
    @test u_inds == vcat(2:1001,2001:N)
    @test v_inds == 1:length(vs)-1


    us = Vector{T}(1:N)
    vs = Vector{T}(1:N); vs .= vs .+ 0.6
    vs = vcat(vs[1:1000], vs[2000:N])
    @time "     comp Δ" u_inds,v_inds = Learn.intersect(us,vs; epsilon=0.5)
    @test u_inds == vcat(2:1001,2001:N)
    @test v_inds == 1:length(vs)-1

    us = Vector{T}(1:N)
    vs = Vector{T}(1:N); vs .= vs .+ 0.6
    vs = vcat(vs[1:1000], vs[2000:N])
    @time "     comp Δ" u_inds,v_inds = Learn.intersect(us,vs; epsilon=0.6)
    @test u_inds == vcat(2:1001,2001:N)
    @test v_inds == 1:length(vs)-1

    nothing
end
end