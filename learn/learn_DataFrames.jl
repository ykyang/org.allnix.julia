using DataFrames
#using UrlDownload
using CSV, HTTP
import Downloads
using Test

# See learn_Downloads.jl for how to download

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

function learn_constructor()
    
    # Like this one the most
    df = DataFrame( # Pair constructor
        "a" => 1:2, 
        "b" => 0  , # auto fill  
    )
    # 2×2 DataFrame
    #  Row │ a      b
    #      │ Int64  Int64
    # ─────┼──────────────
    #    1 │     1      0
    #    2 │     2      0
    # DataFrame([:a => 1:2, :b => 13]) # vector of Pairs constructor
    @test [1,2] == df[!,:a]
    @test [0,0] == df[!,:b]


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
Create a empty DataFrame then fill row-by-row.
"""
function learn_empty_constructor()
    # Create empty data frame
    df = DataFrame(
        [Float64[], String[], Int64[]],  # column data type
        ["cond", "name", "count"]        # column names
    )
    
    # Add rows
    push!(df, [13.0, "H-1", 5])
    push!(df, [17.0, "H-2", 7])

    # Test
    @test [ 13.0,  17.0] == df[!, "cond"]
    @test ["H-1", "H-2"] == df[!, "name"]
    @test [    5,     7] == df[!, :count]
end




function construct_by_constructor()
    df = DataFrame(
        "name"  => ["Liam", "Sophie", "Jacob"],
        "score" => [8.0, 8.0, 12.0],
        "note"  => ["4.17 below the mean", "4.17 below the mean", "0.17 below the mean"]
    )

    return df
end
"""

https://stackoverflow.com/questions/51240161/how-to-insert-a-column-in-a-julia-dataframe-at-specific-position-without-referr
"""
function learn_add_column()
    df = DataFrame(
        "name"  => ["Liam", "Sophie", "Jacob"],
        "score" => [8.0, 8.0, 12.0],
    )

    insertcols!(
        df, 
        3, 
        "note" => ["4.17 below the mean", "4.17 below the mean", "0.17 below the mean"],
        makeunique = true
    )

    @test ["4.17 below the mean", "4.17 below the mean", "0.17 below the mean"] == df[!,"note"]
end

function learn_get_column()
    df = DataFrame(
        "name"  => ["Liam", "Sophie", "Jacob"],
        "score" => [8.0, 8.0, 12.0],
        "note"  => ["4.17 below the mean", "4.17 below the mean", "0.17 below the mean"]
    )

    @test ["Liam", "Sophie", "Jacob"] == df[!, "name"] # by ref
    @test ["Liam", "Sophie", "Jacob"] == df[:, "name"] # by value
end

@testset "Base" begin
    unsupported_DataFrame()
    construct_by_constructor()
    learn_add_column()
    learn_get_column()

    learn_constructor()
    learn_empty_constructor()
end

nothing
