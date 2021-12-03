using JLD2
using Test

function learn_jld2_simple()
    save("example.jld2", Dict(
        "hello" => "world",
        "foo"   => "bar",
    ))

    db = load("example.jld2")

    @test db["hello"] == "world"
    @test db["foo"] == "bar"

    rm("example.jld2")
end

function learn_jldsave()
    x = 1
    y = 2
    z = 42

    # The simplest case:
    jldsave("example.jld2"; x, y, z)

    jldopen("example.jld2", "r") do db
        @test db["x"] == 1
        @test db["y"] == 2
        @test db["z"] == 42
    end

    rm("example.jld2")

    # extension is not "jld2"
    filename = "example.jls"
    jldsave(filename; x, y, z)

    jldopen(filename, "r") do db
        @test db["x"] == 1
        @test db["y"] == 2
        @test db["z"] == 42
    end

    rm(filename)
end

@testset "JLD2" begin
    learn_jld2_simple()
    learn_jldsave()
end

nothing
