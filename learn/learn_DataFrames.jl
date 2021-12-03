using DataFrames
#using UrlDownload
using CSV, HTTP
import Downloads
using Test
using TerminalPager
using PrettyTables
using Formatting

# See learn_Downloads.jl for how to download

"""
This is not supported in 1.0

See learn_empty_constructor()
"""
function unsupported_DataFrame()
    @test_throws ArgumentError DataFrame(
            [String, Float64, String],
            ["name", "score", "note"]
    )
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

function learn_csv()
    url = "https://archive.ics.uci.edu/ml/machine-learning-databases/auto-mpg/auto-mpg.data-original"
    

    # Download to a file
    tmp = Downloads.download(url)
    csv = CSV.File(
        tmp,
        delim = ' ',
        ignorerepeated = true,
        header = [
            :mpg, :cylinders, :displacement, :horsepower,
            :weight, :acceleration, :year, :origin, :name,  
        ],
        missingstring = "NA",
    )
    rm(tmp)
    df = DataFrame(csv)

    return df
end

function learn_csv_io()
    df = simple_table2()

    filename = "simple_table.csv"
    
    CSV.write(filename, df)

    df_read = DataFrame(CSV.File(filename))

    #display(df_read)

    @test df == df_read

    #rm(filename)
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

function learn_groupby_1()
    mdf = DataFrame(
        [
            [1,        2,    3],        # A
            [true, false, true],        # B
            [1,    nothing,  3],        # C
            [nothing, nothing, nothing] # D
        ],
        ["A", "B", "C", "D"]
    )

    # group by :B
    gdf = groupby(mdf, "B") 
    df = gdf[(true,)] # group of B == true
    #pager(df)
    df[:,"D"] = df[!,"A"] ./ df[!,"C"]
    #pager(mdf)
end

function learn_hcat() # https://dataframes.juliadata.org/stable/lib/functions/#Base.hcat
    df1 = DataFrame(A=1:3, B=1:3)
    df2 = DataFrame(A=4:6, B=4:6)

    df3 = hcat(df1, df2, makeunique=true) # copycols = true
    @test df3.A !== df1.A
    df3 = hcat(df1, df2, makeunique=true, copycols=false) # by ref so ...
    @test df3.A === df1.A 

    @test_throws ArgumentError hcat(df1, df2, makeunique=false) # Duplicate variable names
    

    df1 = DataFrame(A=1:3, B=1:3)
    df2 = DataFrame(A=4:6,        C=4:6, D=5:7)
    df3 = hcat(df1, df2[!, [2, 3]])
    @test df3.A == df1.A
    @test df3.C == df2.C
end

function learn_row_iteration()
    df = simple_table()
    for row in eachrow(df)
        # @show typeof(row)
        # @show row["A"]
    end
end

function learn_set_value()
    df = simple_table()
    @test 1.0 == df[1,"A"]
    df[1,"A"] = 13.0 # How efficient is this?
    @test 13.0 == df[1,"A"]

    # Row is referenced to internal data
    df = simple_table()
    row = df[1,:]
    @test 1 == row["A"]
    row["A"] = 13.0
    @test 13 == row["A"]
    @test 13 == df[1,"A"] # referenced
end

function learn_sort()
    mdf = DataFrame(
        [
            Int64[1, 2, 3], # A
            Int64[3, 2, 1], # B
            Int64[3, 1, 2], # C
        ],
        ["A", "B", "C"]
    )

    df = sort(mdf, ["B"])
    @test [1,2,3] == df[!,"B"]
    @test [2,1,3] == df[!,"C"]
end

function learn_transform_1()
    #pager(simple_table())
    # 10×3 DataFrame
    # Row │ A        B        C
    #     │ Float64  Float64  Float64
    #─────┼───────────────────────────
    #   1 │     1.0     11.0    101.0
    #   2 │     2.0     12.0    102.0
    #   3 │     3.0     13.0    103.0
    #   4 │     4.0     14.0    104.0
    #   5 │     5.0     15.0    105.0
    #   6 │     6.0     16.0    106.0
    #   7 │     7.0     17.0    107.0
    #   8 │     8.0     18.0    108.0
    #   9 │     9.0     19.0    109.0
    #  10 │    10.0     20.0    110.0

    # Assign same value back to the same column
    df = simple_table()
    transform!(df, "A" => x -> x, renamecols=false )
    @test simple_table() == df


    # Assign same value to a new column
    # Notice the () around the anonymous function
    df = simple_table()
    transform!(df, "A" => (x -> x) => "AA")
    @test df[!,"A"] == df[!,:AA]

    
    # Create A2 = 2*A
    df = simple_table()
    transform!(df, "A" => (x -> x*2) => "A2")
    @test df[!,"A"] .* 2 == df[!, "A2"]
    

    # Create ABC = A + B + C
    # Notice the () around ((a,b,c) -> a+b+c), this is a must
    df = simple_table()
    transform!(df, ["A", "B", "C"] => ((a,b,c) -> a+b+c) => "ABC")
    @test df[!, "A"] + df[!, "B"] + df[!, "C"] == df[!,"ABC"]   

    # Same but use a function
    df = simple_table()
    transform!(df, ["A", "B", "C"] => 
        function(a,b,c) 
            return a+b+c
        end 
        => "ABC"
    )
    @test df[!, "A"] + df[!, "B"] + df[!, "C"] == df[!,"ABC"]

    # Create D = min(A,B)
    df = simple_table()
    df[:,"A2"] = [1.2, 1.1, 3.0, 4.3, 5.0, 5.9, 7.2, 7.8, 9.3, 9.4]
    transform!(df, ["A", "A2"] => ((a,b) -> min.(a,b)) => "D")
    #@show df
    transform!(df, ["A", "A2"] => (ByRow((a,b)->min(a,b))) => "D")
    #@show df
    transform!(df, ["A"] => ((a) -> min.(a,5)) => "D")
    #@show df
end

function learn_filter_1()
    #pager(simple_table())
    # 10×3 DataFrame
    # Row │ A        B        C
    #     │ Float64  Float64  Float64
    #─────┼───────────────────────────
    #   1 │     1.0     11.0    101.0
    #   2 │     2.0     12.0    102.0
    #   3 │     3.0     13.0    103.0
    #   4 │     4.0     14.0    104.0
    #   5 │     5.0     15.0    105.0
    #   6 │     6.0     16.0    106.0
    #   7 │     7.0     17.0    107.0
    #   8 │     8.0     18.0    108.0
    #   9 │     9.0     19.0    109.0
    #  10 │    10.0     20.0    110.0

    df = simple_table()
    filter!(row -> row["A"] <=5, df)
    @test (5,3) == size(df)

    # Same but use a function, use this for longer function
    df = simple_table()
    filter!(function(row)
        return row["A"] <= 5
    end, df)
    @test (5,3) == size(df)

    # Keep 3 <= A <= 7
    df = simple_table()
    filter!(row -> 3 <= row["A"] <= 7, df)
    @test (5,3) == size(df)
    @test [3,4,5,6,7] == df[!,"A"]

    # Remove 3 <= A <= 7
    df = simple_table()
    filter!(row -> !(3 <= row["A"] <= 7), df)
    @test (5,3) == size(df)
    @test [1,2,8,9,10] == df[!,"A"]
    @test [11,12,18,19,20] == df[!,"B"]
    @test [101,102,108,109,110] == df[!,"C"]

end
"""

Printing and formatting with PrettyTables
"""
function learn_formatting()
    formatter = function(v, i, j)
        if j in [2]
            return sprintf1("%'7.0f", v)
        else
            return v
        end
    end

    df = DataFrame(Dict(
        "a" => Float64[1000000, 2000000],
        "b" => Float64[10000000, 20000000],
    ))

    pretty_table(df, formatters=formatter)

end

function simple_table()
    df = DataFrame(
        [1.0:1:10, 11.0:1:20, 101.0:1:110],
        ["A", "B", "C"]
    )

    return df
end

function simple_table2()
    df = DataFrame(
        "A" => 1:10,
        "B" => 1.0:1:10.0,
    )

    return df
end

function test_simple_table2()
    df = simple_table2()

    @test eltype(df.A) == Int64
    @test eltype(df.B) == Float64
end

@testset "Base" begin
    unsupported_DataFrame()

    learn_add_column()
    learn_get_column()

    learn_constructor()
    learn_empty_constructor()
    #learn_csv()
    learn_csv_io()

    learn_groupby_1()
    learn_hcat()

    learn_row_iteration()
    learn_set_value()
    learn_sort()
    learn_transform_1()
    learn_filter_1()

    test_simple_table2()
end

#df = learn_csv()

nothing
