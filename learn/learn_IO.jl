using Test

open("learn_IO.jl", "r") do io
    line = readline(io)
    @show line

    for line in eachline(io)
        
    end

    # See what happens to readline at eof
    line = readline(io)
    @test "" == line
end