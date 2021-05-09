using DataFrames
#using UrlDownload
using CSV, HTTP
using Test

function learn_download()
    url = "https://raw.githubusercontent.com/Arkoniak/UrlDownload.jl/master/data/ext.csv"
    #csv = urldownload(url) # does not work, complain DataFrame(CSV.File{false}) not exist.
    body = HTTP.get(url).body
    csv = CSV.File(body)
    df = DataFrame(csv)

    @test [1,3] == df[!,:x]
    @test [2,4] == df[!,:y]

    return df
end

"""
This is not supported in 1.0

see `learn_VectorVector()` for work around
"""
function unsupported_DataFrame()
    @test_throws ArgumentError DataFrame(
            [String, Float64, String],
            ["name", "score", "note"]
    )

    # push!(df, ["Liam", 8.0, "4.17 below the mean"])
    # push!(df, ["Sophie", 8.0, "4.17 below the mean"])
    # push!(df, ["Jacob", 12.0, "0.17 below the mean"])

    #return df
end

function learn_DataFrame()
        
    df = DataFrame((a=[1, 2], b=[3, 4])) # Tables.jl table constructor
    # 2×2 DataFrame
    #  Row │ a      b
    #      │ Int64  Int64
    # ─────┼──────────────
    #    1 │     1      3
    #    2 │     2      4
    @test [1,2] == df[!,:a]
    @test [3,4] == df[!,:b]


  
    df = DataFrame([(a=1, b=0), (a=2, b=0)]) # Tables.jl table constructor
    # 2×2 DataFrame
    #  Row │ a      b
    #      │ Int64  Int64
    # ─────┼──────────────
    #    1 │     1      0
    #    2 │     2      0
    @test [1,2] == df[!,:a]
    @test [0,0] == df[!,:b]
  
    df = DataFrame("a" => 1:2, "b" => 0) # Pair constructor
    # 2×2 DataFrame
    #  Row │ a      b
    #      │ Int64  Int64
    # ─────┼──────────────
    #    1 │     1      0
    #    2 │     2      0
    # DataFrame([:a => 1:2, :b => 13]) # vector of Pairs constructor
    @test [1,2] == df[!,:a]
    @test [0,0] == df[!,:b]

    df = DataFrame([:a => 1:2, :b => 0]) # vector of Pairs constructor
    # 2×2 DataFrame
    #  Row │ a      b
    #      │ Int64  Int64
    # ─────┼──────────────
    #    1 │     1      0
    #    2 │     2      0
    @test [1,2] == df[!,:a]
    @test [0,0] == df[!,:b]
     
    df = DataFrame(Dict(:a => 1:2, :b => 0)) # dictionary constructor
    #  2×2 DataFrame
    #   Row │ a      b
    #       │ Int64  Int64
    #  ─────┼──────────────
    #     1 │     1      0
    #     2 │     2      0
    @test [1,2] == df[!,:a]
    @test [0,0] == df[!,:b]
     
    df = DataFrame(a=1:2, b=0) # keyword argument constructor
    #  2×2 DataFrame
    #   Row │ a      b
    #       │ Int64  Int64
    #  ─────┼──────────────
    #     1 │     1      0
    #     2 │     2      0
    @test [1,2] == df[!,:a]
    @test [0,0] == df[!,:b]
     
    df = DataFrame([[1, 2], [0, 0]], [:a, :b]) # vector of vectors constructor
    #  2×2 DataFrame
    #   Row │ a      b
    #       │ Int64  Int64
    #  ─────┼──────────────
    #     1 │     1      0
    #     2 │     2      0
    @test [1,2] == df[!,:a]
    @test [0,0] == df[!,:b]

    df = DataFrame([[1, 2], [0, 0]], ["a", "b"]) # vector of vectors constructor
    #  2×2 DataFrame
    #   Row │ a      b
    #       │ Int64  Int64
    #  ─────┼──────────────
    #     1 │     1      0
    #     2 │     2      0
    @test [1,2] == df[!,:a]
    @test [0,0] == df[!,:b]
    @test [1,2] == df[!,"a"]
    @test [0,0] == df[!,"b"]

     
    df = DataFrame([1 0; 2 0], :auto) # matrix constructor
    #  2×2 DataFrame
    #   Row │ x1     x2
    #       │ Int64  Int64
    #  ─────┼──────────────
    #     1 │     1      0
    #     2 │     2      0
    @test [1,2] == df[!,:x1]
    @test [0,0] == df[!,:x2]
end

"""
Replace the constructor that takes types
"""
function learn_VectorVector()
    col_type = [Vector{Float64}(), Vector{String}(), Vector{Int64}()]
    col_name = ["cond", "name", "count"]
    df = DataFrame(col_type, col_name)
    
    row = [13.0, "H-1", 5]
    push!(df, row)
    row = [17.0, "H-2", 7]
    push!(df, row)

    @test [13.0, 17.0] == df[!, "cond"]
    @test ["H-1", "H-2"] == df[!, "name"]
    @test [5,7] == df[!, :count]
end




function construct_by_constructor()
    df = DataFrame([
        "name"  => ["Liam", "Sophie", "Jacob"],
        "score" => [8.0, 8.0, 12.0],
        "note"  => ["4.17 below the mean", "4.17 below the mean", "0.17 below the mean"]
    ])

    return df
end
"""

https://stackoverflow.com/questions/51240161/how-to-insert-a-column-in-a-julia-dataframe-at-specific-position-without-referr
"""
function add_a_column()
    df = DataFrame([
        "name"  => ["Liam", "Sophie", "Jacob"],
        "score" => [8.0, 8.0, 12.0],
    ])

    insertcols!(
        df, 
        3, 
        "note" => ["4.17 below the mean", "4.17 below the mean", "0.17 below the mean"],
        makeunique = true
    )

    return df
end

function get_a_column()
    df = construct_by_constructor()
    col = df[!,"name"]

    return col
end

#df = learn_download()
#df = construct_by_push_row()
#df = construct_by_constructor()
#df = add_a_column()
#col = get_a_column()
@testset "Base" begin
    learn_download()
    unsupported_DataFrame()
    construct_by_constructor()
    add_a_column()
    get_a_column()

    learn_DataFrame()
    learn_VectorVector()
end

nothing
