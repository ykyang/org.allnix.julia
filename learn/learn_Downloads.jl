import Downloads
using CSV, DataFrames
using Test

function learn_basic()
    url = "https://raw.githubusercontent.com/Arkoniak/UrlDownload.jl/master/data/ext.csv"

    # Download to a file
    tmp = Downloads.download(url)
    csv = CSV.File(tmp)
    rm(tmp)
    df = DataFrame(csv)

    @test [1,3] == df[!,:x]
    @test [2,4] == df[!,:y]

    # Download to memory
    io = IOBuffer()
    Downloads.download(url, io)
    csv = CSV.File(take!(io))
    df = DataFrame(csv)

    @test [1,3] == df[!,:x]
    @test [2,4] == df[!,:y]
end

@testset "Base" begin
    learn_basic()
end

nothing
