# 532f962f-75e5-4feb-8551-4a847415fd27
using Test

function simple_read()
    open("learn_IO.jl", "r") do io
        firstline = readline(io)
        @test firstline == "# 532f962f-75e5-4feb-8551-4a847415fd27"

        lastline = nothing
        for line in eachline(io)
            lastline = line
        end

        @test lastline == "# 5a025ec5-acba-4e5a-a5cd-2a7c07cca457"

        # See what happens to readline at eof
        line = readline(io)
        @test "" == line
    end
end

function simple_write()
    filename = "learn_simple_write.txt"
    open(filename, "w") do io
        println(io, "8eef43b1-8475-491d-a8db-16b733edc15c")
    end

    line = nothing
    open(filename, "r") do io
        line = readline(io)
    end

    @test line == "8eef43b1-8475-491d-a8db-16b733edc15c"
    
    rm(filename)

    @test isfile(filename) == false
end


@testset "IO" begin
    simple_read()
    simple_write()
end

nothing

# 5a025ec5-acba-4e5a-a5cd-2a7c07cca457