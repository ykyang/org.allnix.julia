# Book: Julia for Data Analysis
# https://livebook.manning.com/book/julia-for-data-analysis/chapter-2/v-3/10
# https://github.com/bkamins/JuliaForDataAnalysiss

# 2 Getting started with Julia
# k-times winsorized mean

module LearnJuliaDataAnalysis
using Logging
using Test
using InteractiveUtils # supertypes()
using DataStructures

using StatsBase      # Chapter 3
using BenchmarkTools # Chapter 3

using Statistics # Chapter 4
using Plots      # 4.1.7
#pyplot()
# use display() to show plots
using GLM        # 4.3.2

using Random # 5.3
using PyCall # 5.3

import Downloads    # 6
using FreqTables    # 6.5
using NamedArrays   # 6.5
using InlineStrings # 6.7
using PooledArrays  # 6.8
using HTTP          # 7
using JSON3         # 7
using Missings      # 7.2.2
using Dates         # 7.3
using Impute        # 7.4.2

include("Learn.jl")
using .Learn

"""
    parseline(line::AbstractString)

Function from Chapter 6.  Parse line formatted like this
```
0002844::Fantômas - À l'ombre de la guillotine (1913)::Crime|Drama
```

Return record
```
(
    id = "0002844", 
    name = "Fantômas - À l'ombre de la guillotine", 
    year = 1913, 
    genres = SubString{String}["Crime", "Drama"]
)
```
"""
function parseline(line::AbstractString)
    parts = split(line, "::")
    re = r"(.+) \((\d{4})\)"
    # re = Regex(raw"(.+) \((\d{4})\)") # same as above
    rem = match(re, parts[2])
    return (
        id = parts[1],
        name = rem[1],
        year = parse(Int, rem[2]),
        genres = split(parts[3], "|")
    )
end

function learn_memory_layout()
    # https://livebook.manning.com/book/julia-for-data-analysis/chapter-2/v-3/23
    @show bitstring(2) # "0000000000000000000000000000000000000000000000000000000000000010"
    @show bitstring(Int8(2)) # "00000010"
    @show typeof(bitstring(2)) # String
end

function learn_types()
    # https://livebook.manning.com/book/julia-for-data-analysis/chapter-2/v-3/20
    @show typeof(1) # Int64
    @show typeof([1,2,3]) # Vector{Int64}
    # https://livebook.manning.com/book/julia-for-data-analysis/chapter-2/v-3/28
    @show [1,2,3] isa Vector{Int}
end

function learn_ch2()
    # https://livebook.manning.com/book/julia-for-data-analysis/chapter-2/v-3/87
    @test (0.1+0.2) != 0.3
    @test isapprox(0.1+0.2, 0.3)
    # https://livebook.manning.com/book/julia-for-data-analysis/chapter-2/v-3/91
    # Convenient
    @test 0 < 7 < 10
    
    ## Short-circuit evaluation of conditions in Julia
    -1 < 0 && (Ans = "x < 0")
    @test Ans == "x < 0"
    -1 > 0 || (Ans = "!(-1 < 0)")
    @test Ans == "!(-1 < 0)"

    ## Conditional statements return a value
    let x = -4
        y = if x > 0
                sqrt(x)
            else
                sqrt(-x)
            end
        @test y == 2
    end
    ## 2.3.3 Compound expressions
    # begin end
    # ( ; )

    ## 2.3.4 A first approach to calculating the winsorized mean
    
    
    let x=[8,3,1,5,7], k=1 
        y = sort(x)
        @test y == [1,3,5,7,8]
        for i in 1:k
            y[i] = y[k+1]
            y[end-i+1] = y[end-k]
        end
        @test y == [3,3,5,7,7]
        s = 0
        for v in y
            s += v
        end
        @test s == 25
        @test s/length(y) == 5
    end

    
    ## 2.4 Defining functions


    let ## Anonymous functions
        @test map(x->x^2, [1,2,3]) == [1,4,9]
        @test sum(x->x^2, [1,2,3]) == 14
    end

    let # do blocks
        Ans = sum([1,2,3]) do x # This is the first argument function
            x^2
        end
        @test Ans == 14
    end

    function winsorized_mean(x, k)
        y = sort(x)
        for i in 1:k
            y[i] = y[k+1]
            y[end-i+1] = y[end - k ]
        end
        s = 0
        for v in y
            s += v
        end
        return s/length(y)
    end

    # A simplified definition of function computing the winsorized mean
    let
        @test winsorized_mean([8,3,1,5,7], 1) == 5 
    end

    ## Variable scoping rules

    ## Deciding what type restrictions to put in method signature

end

function learn_ch3()
    ## 3.1 Understand Julia's type system

    ## Finding all supertypes of a type
    # print_supertypes(Int64)

    ## Finding all subtypes of a type
    # print_subtypes(Integer, 0)

    ## Union of types
    # Union{String, Missing}

    ## Deciding what type restrictions to put in method signature
    # print_supertypes(typeof([1.0,2.0,3.0]))
    # print_supertypes(typeof(1:3))
    @test AbstractVector == typejoin(typeof([1.0,2.0,3.0]), typeof(1:3))


    ## 3.2 Multiple dispatch in Julia


    ## Rules of defining methods for a function
    fun(x)          = "unsupported type"
    fun(x::Number)  = "a number was passed"
    fun(x::Float64) = "a Float64 value"
    # showrepl(methods(fun))
    @test fun("hello!") == "unsupported type"
    @test fun(1)        == "a number was passed"
    @test fun(1.0)      == "a Float64 value"

    ## Method ambiguity problem

    ## Improved implementation of winsorized mean
    # See winsorized_mean_ch3()
    @test winsorized_mean_ch3([8,3,1,5,7], 1) == 5.0
    @test winsorized_mean_ch3(1:10, 2) == 5.5
    @test_throws MethodError   winsorized_mean_ch3(1:10, "a")
    @test_throws MethodError   winsorized_mean_ch3(10, 1)
    @test_throws ArgumentError winsorized_mean_ch3(1:10, -1)
    @test_throws ArgumentError winsorized_mean_ch3(1:10, 5)


    ## 3.3 Working with packages and modules

    ## How can packages be used in Julia?

    ## Using the StatsBase.jl package to compute winsorized mean
    @test collect(winsor([8,3,1,5,7], count=1)) == [7,3,3,5,7]
    @test mean(winsor([8,3,1,5,7], count=1)) == 5.0
    @test collect(winsor([1,3,5,7,8],prop=0.20)) == [3,3,5,7,7]


    ## Using marcors
    x = rand(10^6)
    # showrepl(@benchmark winsorized_mean_ch3($x, 10^5))
    # @btime winsorized_mean_ch3($x, 10^5)
    # @edit winsor(x, count=10^5)
   
    ## EXERCISE 3.1
    let x = 1:10^6
        y = collect(x)
        # @btime sort($x)
        # @btime sort($y)
    end

    ## 3.4 Using macros
end

function winsorized_mean_ch3(x::AbstractVector, k::Integer)
    # https://livebook.manning.com/book/julia-for-data-analysis/chapter-3/v-3/74
    if k < 0 throw(ArgumentError("k must be non-negative")) end
    if !(2*k < length(x)) throw(ArgumentError("k is too large")) end

    y = sort!(collect(x))
    for i in 1:k
        y[i] = y[k+1]
        y[end-k+i] = y[end-k]
    end

    return sum(y)/length(y)
end

function print_supertypes(T)
    map(println, supertypes(T))

    nothing
end

function print_subtypes(T, indent_level=0)
    println(" " ^ indent_level, T)
    for S in subtypes(T)
        print_subtypes(S, indent_level+2)
    end
   

    # OK
    # stack = Stack{Any}()
    # push!(stack, (T,indent_level))
    # while !isempty(stack)
    #     (t,indent) = pop!(stack)
    #     println(" " ^ indent, t)
    #     for subtype in reverse(subtypes(t))
    #         push!(stack, (subtype, indent+2))
    #     end
    # end

    # Wrong
    # que = Queue{Tuple}()
    # enqueue!(que, (T, indent_level))
    # while !isempty(que)
    #     (t,indent) = dequeue!(que)
    #     println(" " ^ indent, t)
    #     map(x->enqueue!(que,x), [(i,indent+2) for i in subtypes(t)])
    # end
end

function aq_data()
    return [10.0   8.04  10.0  9.14  10.0   7.46   8.0   6.58
          8.0   6.95   8.0  8.14   8.0   6.77   8.0   5.76
          13.0   7.58  13.0  8.74  13.0  12.74   8.0   7.71
          9.0   8.81   9.0  8.77   9.0   7.11   8.0   8.84
          11.0   8.33  11.0  9.26  11.0   7.81   8.0   8.47
          14.0   9.96  14.0  8.1   14.0   8.84   8.0   7.04
          6.0   7.24   6.0  6.13   6.0   6.08   8.0   5.25
          4.0   4.26   4.0  3.1    4.0   5.39  19.0  12.50
          12.0  10.84  12.0  9.13  12.0   8.15   8.0   5.56
          7.0   4.82   7.0  7.26   7.0   6.42   8.0   7.91
          5.0   5.68   5.0  4.74   5.0   5.73   8.0   6.89]
end

function learn_ch4()
    ## 4.1 Working with arrays

    ## 4.1.1 Getting the data into a matrix

    ## Creating a matrix
    aq = [10.0   8.04  10.0  9.14  10.0   7.46   8.0   6.58
          8.0   6.95   8.0  8.14   8.0   6.77   8.0   5.76
          13.0   7.58  13.0  8.74  13.0  12.74   8.0   7.71
          9.0   8.81   9.0  8.77   9.0   7.11   8.0   8.84
          11.0   8.33  11.0  9.26  11.0   7.81   8.0   8.47
          14.0   9.96  14.0  8.1   14.0   8.84   8.0   7.04
          6.0   7.24   6.0  6.13   6.0   6.08   8.0   5.25
          4.0   4.26   4.0  3.1    4.0   5.39  19.0  12.50
          12.0  10.84  12.0  9.13  12.0   8.15   8.0   5.56
          7.0   4.82   7.0  7.26   7.0   6.42   8.0   7.91
          5.0   5.68   5.0  4.74   5.0   5.73   8.0   6.89]
    aq = aq_data()
    @test size(aq) == (11,8)
    @test size(aq,1) == 11
    @test size(aq,2) == 8


    ## Working with tuples
    let
        t = (1,2,3) # tuple
        @test t[1] == 1
        @test_throws MethodError t[1] = 2
    end

    ## 4.1.2 Computing baisc statistics of the data stored in a matrix
    # showrepl(mean(aq; dims=1))
    """
    1×8 Matrix{Float64}:
     9.0  7.50091  9.0  7.50091  9.0  7.5  9.0  7.50091
    """
    # showrepl(std(aq; dims=1))
    """
    1×8 Matrix{Float64}:
     3.31662  2.03157  3.31662  2.03166  3.31662  2.03042  3.31662  2.03058
    """
    # x-feature have the same mean and std for each data set
    # so is y-feature.

    # Alternative ways
    # showrepl( map(mean, eachcol(aq)) )
    # showrepl( map(std, eachcol(aq)) )
    # showrepl( [mean(col) for col in eachcol(aq)] ) # list comprehension
    # showrepl( [std(col) for col in eachcol(aq)] )

    ## 4.1.3 Indexing into arrays
    
    # showrepl( [mean(aq[:,j]) for j in axes(aq,2)] )
    # showrepl( [std(aq[:,j]) for j in axes(aq,2)] )

    ## Use view() which returns a view to array

    # showrepl( [mean(view(aq, :, j)) for j in axes(aq,2)] )
    # showrepl( [std(@view aq[:,j]) for j in axes(aq,2)] )

    # showrepl( @benchmark [mean($aq[:,j]) for j in axes($aq,2)] )        # slower
    # showrepl( @benchmark [mean(view($aq, :, j)) for j in axes($aq,2)] ) # faster
    # showrepl( @benchmark [mean(col) for col in eachcol($aq)] )          # faster


    ## 4.1.4 Performance considerations of copying vs. making a view
    let x
        x = ones(10^7, 10)
        # @btime [mean(@view $x[:,j]) for j in axes($x,2)] 
        # @btime [mean($x[:,j]) for j in axes($x,2)]        # slow
        # @btime mean($x,dims=1)
    end

    ## 4.1.5 Calculation of correlations between variables
    # showrepl( [cor(aq[:,i], aq[:,i+1]) for i in 1:2:7] )

    ## Exercise 4.1
    # @btime [cor($aq[:,i], $aq[:,i+1]) for i in 1:2:7]
    # @btime [cor(view($aq,:,i), view($aq,:,i+1)) for i in 1:2:7]

    ## 4.1.6 Fitting a linear regression
    let
        # x = A\B solve
        # Ax= B when A is square
        # norm(A*x - B)
        """
        | 1  x1 |  * | c |   | y1 |
        | 1  x2 |    | a | = | y2 |
        | ...   |            | .. |
        | 1  x3 |            | y3 |

        Minimize
        c + a*x1 - y1 = e1
        c + a*x2 - y2 = e2

        """
        y = aq[:,2]
        X = [ones(axes(y,1)) aq[:,1]]
        #@show X\y
    end
    let
        n = axes(aq,1)
        Ans = [[ones(n) aq[:,i]] \ aq[:,j] for (i,j) in zip(1:2:7,2:2:8)]
        #showrepl(Ans)
    end

    # Coefficient of determination, R²
    # R² = 1 - RSS/TSS
    # RSS = sum of squares of residuals
    # TSS = total sum of squares
    """
    x feature, y target
    """
    function R²(x,y) # Coef of det of error
        X = [ones(axes(x,1)) x]
        model = X \ y
        prediction = X*model
        error = y - prediction

        SS_res = sum(v->v^2, error)
        mean_y = mean(y)
        SS_tot = sum(v->(v-mean_y)^2, y)
        return 1 - SS_res/SS_tot
    end
    let
        Ans = [R²(aq[:,i],aq[:,j]) for (i,j) in zip(1:2:7,2:2:8)]
        #showrepl(Ans)
    end

    ## 4.1.7 Plotting the Anscombe's quartet data
    # plot(
    #     scatter(aq[:,1], aq[:,2]; legend=false),
    #     scatter(aq[:,3], aq[:,4]; legend=false),
    #     scatter(aq[:,5], aq[:,6]; legend=false),
    #     scatter(aq[:,7], aq[:,8]; legend=false)
    # )
    # display(plot([scatter(aq[:,i], aq[:,i+1]; legend=false) for i in 1:2:7]...))

    ## 4.2 Mapping key-value pairs with dictionaries
    ## The Sicherman puzzle
    ## Creating a dictionary
    two_std = let 
        two_std = Dict{Int,Int}()
        for i in 1:6, j in 1:6
            s = i+j
            two_std[s] = get(two_std, s, 0) + 1
        end
        #showrepl(two_std)
        scatter(collect(keys(two_std)), collect(values(two_std));
            legend=false, xaxis=2:12
        )
        
        two_std
    end
    ## Solving the Sicherman puzzle
    let
        all_dice = [
            [1, x2, x3, x4, x5, x6]
            for x2 in 2:11 for x3 in x2:11 for x4 in x3:11 for x5 in x4:11
                for x6 in x5:11
        ]
        #showrepl(all_dice)

        # for d1 in all_dice, d2 in all_dice
        #     test = Dict{Int,Int}()
        #     for i in d1, j in d2
        #         s = i+j
        #         test[s] = get(test, s, 0) + 1
        #     end
        #     if test == two_std
        #         println(d1, " ", d2)
        #     end
        # end
        
        # [1, 2, 2, 3, 3, 4] [1, 3, 4, 5, 6, 8]
    end
    ## Exercise 4.2
    #test_dice()

    ## 4.3 Putting structure to your data using named tuples

    ## 4.3.1 Defining named tuples and accessing their contents
    let
        dataset1 = (x=aq[:,1], y=aq[:,2])
        #showrepl(dataset1)
        data = (
            set1=(x=aq[:,1], y=aq[:,2]),
            set2=(x=aq[:,3], y=aq[:,4]),
            set3=(x=aq[:,5], y=aq[:,6]),
            set4=(x=aq[:,7], y=aq[:,8]),
        )
        #showrepl(data)
    end

    ## 4.3.2 Analyzing Anscombe's quartet data stored in a named tuple
    let
        data = (
            set1=(x=aq[:,1], y=aq[:,2]),
            set2=(x=aq[:,3], y=aq[:,4]),
            set3=(x=aq[:,5], y=aq[:,6]),
            set4=(x=aq[:,7], y=aq[:,8]),
        )
        Ans = map(s -> mean(s.x), data)
        @test Ans isa NamedTuple
        #showrepl(Ans)
        Ans = map(s -> cor(s.x,s.y), data)
        #showrepl(Ans)
        model = lm(@formula(y ~ x), data.set1)
        #showrepl(model)
        Ans = r2(model)
        #showrepl(Ans)

        ## Exercise 4.3
        # display(plot([scatter(s.x,s.y;legend=false) for s in data]...))
        # for s in data
        #     scatter(s.x,s.y;legend=false)
        # end
    end

    ## 4.3.3 Understanding composite types and mutability of values in Julia

    nothing
end
function dice_distribution(d1, d2)
    rolls = Dict{Int,Int}()
    for i in d1, j in d2
        s = i+j
        rolls[s] = get(rolls, s, 0) + 1
    end

    return rolls
end
function test_dice()
    two_std = dice_distribution(1:6, 1:6)
    all_dice = [
        [1, x2, x3, x4, x5, x6]
        for x2 in 2:11 for x3 in x2:11 for x4 in x3:11 for x5 in x4:11
            for x6 in x5:11
    ]
    for d1 in all_dice, d2 in all_dice
        test = dice_distribution(d1,d2)
        if test == two_std
            println(d1, " ", d2)
        end
    end
end

function learn_ch5()
    ## 5.1 Vectorizing your code using broadcasting
    ## 5.1.1 Syntax and meaning of boradcasting in Julia
    let
        x = [1 2 3] # 1x3
        y = [1,2,3] # 3x1
        @test x*y == [14]
        a = [1,2,3]
        b = [4,5,6]
        @test a.*b == [4,10,18]
        @test map(*, a, b) == [4,10,18]
        ## eachindex()
        @test [a[i]*b[i] for i in eachindex(a,b)] == [4,10,18]
    end
    ## 5.1.2 Expansion of length-1 dimensions in broadcasting
    let
        @test [1,2,3] .^ 2 == [1,4,9]
        @test [1,2,3] .* [1 2 3] == [
            1 2 3
            2 4 6
            3 6 9
        ]
        Ans = ["x", "y", "z"] .=> [sum minimum maximum]
        #showrepl(Ans)
        @test abs.([1,-2,3,-4]) == [1,2,3,4]
        @test string(1,2,3) == "123"
        @test string.("x", 1:3) == ["x1", "x2", "x3"]

        f(i::Int) = string("Got integer ", i)
        f(s::String) = string("Got string ", s)
        #showrepl(f.([1, "1"]))
    end
    ## 5.1.3 Protection of collections from being broadcasted over
    let
        @test in.([1,3,5], Ref([1,2,3,4])) == [true,true,false]
        ## BitMatrix display as 0s, 1s
        #showrepl(isodd.([1,2,3,4].*[1 2 3 4]))
    end
    ## Exercise 5.1
    let
        Ans = parse.(Int, ["1", "2", "3"])
        @test Ans == [1,2,3]
    end
    ## 5.1.4 Analyzing Anscombe's quartet data using broadcasting
    let
        aq = aq_data()
        ## eachcol
        Ans = mean.(eachcol(aq))
        #showrepl(Ans)
    end
    """
    Given x, y, solve c, a where

        | 1  x1 |  * | c |   | y1 |
        | 1  x2 |    | a | = | y2 |
        | ...   |            | .. |
        | 1  x3 |            | y3 |

        Minimize
        c + a*x1 - y1 = e1
        c + a*x2 - y2 = e2

    """
    function R2(x, y)
        X = [ones(length(y)) x]
        model = X \ y
        #showrepl(model)
        pred = X * model
        SS_res = sum( (y .- pred) .^ 2 )
        SS_tot = sum( (y .- mean(y)) .^ 2 )
        return 1 - SS_res/SS_tot
    end
    let
        aq = aq_data()
        Ans = [R2(aq[:,i],aq[:,j]) for (i,j) in zip(1:2:7,2:2:8)]
        #showrepl(Ans)
    end
    ## 5.2 Defining methods with parametric types
    ## 5.2.1 Most collection types in Julia are parametric
    @test typeof([]) == Vector{Any}
    @test eltype([]) == Any
    @test eltype(Float64[]) == Float64
    @test typeof(Dict()) == Dict{Any,Any}
    @test eltype(Dict()) == Pair{Any,Any}
    @test typeof(1 => 2) == Pair{Int,Int}
    ## 5.2.2 Rules for subtyping of parametric types
    @test [1,2] isa AbstractVector{Int}
    @test !([1,2] isa AbstractVector{Real})
    @test [1,2] isa AbstractVector{<:Real}
    @test [1,2] isa AbstractVector{T} where T<:Real
    ## 5.2.3 Using the subtyping rules to define the covariance function
    function ourcov(x::AbstractVector{<:Real}, y::AbstractVector{<:Real}) # Covariance
        len = length(x)
        @assert len == length(y)
        return sum((x .- mean(x)) .* (y .- mean(y)))/(len - 1)
    end
    @test isapprox( ourcov(1:4, [1,3,2,4]), 1.333, atol=1e-3 )
    @test isapprox( cov(1:4, [1,3,2,4]), 1.333, atol=1e-3 )

    ## identity() narrow down element type
    @test typeof( identity.(Any[1,2,3]) ) == Vector{Int}
    @test typeof( identity.(Any[1, 2.0]) ) == Vector{Real}
    
    ## 5.3 Integration with Python
    let
        Random.seed!(1234) 
        cluster1 = randn(100, 5) .- 1; @test (100,5)==size(cluster1); #showrepl(cluster1)
        cluster2 = randn(100, 5) .+ 1; @test (100,5)==size(cluster2); #showrepl(cluster1)
        data5 = vcat(cluster1, cluster2); @test (200,5)==size(data5)
        # using Conda
        # Conda.add("scikit-learn")
        manifold = pyimport("sklearn.manifold"); #showrepl(manifold)
        tsne = manifold.TSNE(n_components=2, init="random", learning_rate="auto",
            random_state=1234); #showrepl(tsne)
        data2 = tsne.fit_transform(data5); @test (200,2)==size(data2); #showrepl(data2)
        p = scatter(data2[:,1], data2[:,2]; color=[fill("black",100); fill("gold",100)], legend=false)
        display(p)
    end
    ## Exercise 5.2
    let
        Random.seed!(1234) 
        cluster1 = randn(100, 5) .- 0.4; @test (100,5)==size(cluster1); #showrepl(cluster1)
        cluster2 = randn(100, 5) .+ 0.4; @test (100,5)==size(cluster2); #showrepl(cluster1)
        data5 = vcat(cluster1, cluster2); @test (200,5)==size(data5)
        # using Conda
        # Conda.add("scikit-learn")
        manifold = pyimport("sklearn.manifold"); #showrepl(manifold)
        tsne = manifold.TSNE(n_components=2, init="random", learning_rate="auto",
            random_state=1234); #showrepl(tsne)
        data2 = tsne.fit_transform(data5); @test (200,2)==size(data2); #showrepl(data2)
        p = scatter(data2[:,1], data2[:,2]; color=[fill("black",100); fill("gold",100)], legend=false)
        display(p)
    end
end

function learn_ch6()
    movie_file = "movies.dat"

    ## 6.1 Getting and inspecting the data
    let file = movie_file # Download file
        if !isfile(file)    
            Downloads.download("https://raw.githubusercontent.com/" *
                               "sidooms/MovieTweetings/" *
                                "44c525d0c766944910686c60697203cda39305d6/" *
                                "snapshots/10K/movies.dat",
                                file)

            # Content of movies.dat
            """
            0002844::Fantômas - À l'ombre de la guillotine (1913)::Crime|Drama
            0007264::The Rink (1916)::Comedy|Short
            0008133::The Immigrant (1917)::Short|Comedy|Drama|Romance
            .
            .
            .
            """
        end
    end

    let x=10 # Interpolate variable
        @test "I have $x apples"    == "I have 10 apples"
        @test "I have $(2x) apples" == "I have 20 apples"
    end

    let # Line continuation in String
        a = "https://raw.githubusercontent.com/" *
            "sidooms/MovieTweetings/" *
            "44c525d0c766944910686c60697203cda39305d6/" *
            "snapshots/10K/movies.dat"
        b = "https://raw.githubusercontent.com/\
            sidooms/MovieTweetings/\
            44c525d0c766944910686c60697203cda39305d6/\
            snapshots/10K/movies.dat"
        @test a == b
    end

    let # raw string literals
        @test raw"C:\Users" == "C:\\Users"
    end
    
    ## Reading contents of a file
    movies = let 
        movies = readlines(movie_file)
        @test typeof(movies) == Vector{String}
        @test length(movies) == 3096 # rows

        movies
    end

    ## 6.2 Splitting strings
    
    let
        movie = first(movies) # first line
        movie_parts = split(movie, "::")
        @test typeof(movie_parts) == Vector{SubString{String}}
        @test movie_parts == ["0002844", "Fantômas - À l'ombre de la guillotine (1913)", "Crime|Drama"]

        @test supertype(String) == AbstractString
        @test supertype(SubString{String}) == AbstractString
    end

    ## 6.3 Working with strings using regular expressions

    let
        movie = first(movies) # first line
        movie_parts = split(movie, "::")

        @test movie_parts[2] == "Fantômas - À l'ombre de la guillotine (1913)"

        rx = r"(.+) \((\d{4})\)"
        m = match(rx, movie_parts[2]); #showrepl(m)

        @test m[1] == "Fantômas - À l'ombre de la guillotine"
        @test m[2] == "1913"
        @test parse(Int, m[2]) == 1913
    end

    ## Writing a parser of a single line of movies.dat file
    let movies=movies
        record = parseline(movies[1]); #showrepl(record)
        @test record.id == "0002844" 
        @test record.name == "Fantômas - À l'ombre de la guillotine"
        @test record.year == 1913
        @test record.genres == ["Crime", "Drama"]
    end

    ## 6.4 Extracting a subset from a string with indexing
    let
        # Note, 0x61 is hex
        # 0o is octal
        # 0b is binary
        @test codeunits("a") == Base.CodeUnits("a") == UInt8[0x61] # 97 in dec
        @test codeunits("ε") == UInt8[0xce,0xb5]
        @test codeunits("∀") == UInt8[0xe2,0x88,0x80]
    end
    let movies = movies
        record = parseline(movies[1]); #showrepl(record)
        word = first(record.name, 8)
        @test word == "Fantômas" # as expected
        @test record.name[1:8] == "Fantôma" # missing 1 char
        # Check with eachindex()
        for i in eachindex(word)
            #println(i, ": ", word[i])
        end
        # Useful string functions
        @test length(word) == 8
        @test chop(word, head=1, tail=2) == "antôm"
        @test first(word, 2) == "Fa"
        @test last(word, 2) == "as"
    end
    ## ASCII strings
    let
        @test isascii("Hello World!")
        @test !isascii("∀ x: x≥0")
    end
    ## The Char type
    let word = "Fantômas"
        #           57  
        @test word[1] == 'F'
        @test word[5] == 'ô'
        @test_throws StringIndexError word[6] == 'm' # StringIndexError: invalid index [6], valid nearby indices [5]=>'ô', [7]=>'m'
        @test word[7] == 'm'
    end

    ## 6.5 Analyzing genres frequency in movies.dat
    
    
    let movies = movies
        ## Finding common movie genres
        records = parseline.(movies)
        @test length(records) == 3096

        """1. Create a single vector containing genres"""
        genres = String[]
        for record in records
            append!(genres, record.genres)
        end
        
        """2. Create a frequency table using the freqtable() from FreqTables.jl"""
        table = freqtable(genres); #showrepl(table)
        @test table isa NamedArrays.NamedVector
        sort!(table); #showrepl(table)
        @test table["News"]  == 4    # min
        @test table["Drama"] == 1583 # max
        @test names(table) isa Vector{Vector{String}}; #showrepl(names(table))
        @test names(table)[1][1] == "News"
        @test names(table)[1][2] == "Film-Noir"

        ## Understanding genre popularity evolution over the years

        #showrepl(movies)
        years = [record.year for record in records]
        has_drama = ["Drama" in record.genres for record in records]
        """
        Use FreqTables to calculate proportions of true/false for 
        each year.
        """
        drama_prop = proptable(years, has_drama; margins=1);
        """
        Dim1 ╲ Dim2 │    false      true
        ────────────+───────────────────
        1913        │      0.0       1.0
        1916        │      1.0       0.0
        1917        │      0.0       1.0
        """
        #showrepl(drama_prop)
        # display(plot(names(drama_prop,1), drama_prop[:,2]; legend=false,
        #     xlabel="year", ylabel="Drama probability"
        # ))
    end        
    ## Exercise 6.1
    let movies = movies
        records = parseline.(movies)
        years = [record.year for record in records]; #showrepl(years)
        table = freqtable(years); #showrepl(table)
        # display(plot(names(table), table[:]; legend=false,
        #     xlabel="Year", ylabel="No. of Movies"
        # ))
    end
   
    ## 6.6 Introducing symbols
    """
    comparison for equality, but you want it to be very fast
    create values that have a Symbol type
    """
    ## 6.6.1 Creating symbols
    let
        s1 = Symbol("x"); @test s1 == :x; @test s1 isa Symbol
        s2 = Symbol("hello world!"); # no other way to construct?
        s3 = Symbol("x", 1); @test s3 == :x1
    end
    ## 6.6.2 Using symbols
    let
        @test supertype(Symbol) isa Any
        @test :x == :x
        @test :x != :y

        ## Listing 6.6
        n = 10^6
        names = string.("x", 1:n); @test length(names) == n
        symbols = Symbol.(names);  @test length(symbols) == n
        #@btime "x" in $names  # 5.000 ms (0 allocations: 0 bytes)
        #@btime :x in $symbols # 397.000 μs (0 allocations: 0 bytes)

        """
        CHOOSING BETWEEN STRING AND SYMBOL IN YOUR CODE
        ... prefer to use strings in your program ...
        ... perform a lot of comparisons ... do not expect to have to manipulate
        ... and you require maximum performance, ... using Symbol
        """
    end

    ## 6.7 Using fixed-width string types to improve performance
    """
    ... even more efficient storage format than both standard String and
    Symbol.
    """
    ## Available fixed-width strings
    """
    ... recommended to perform an appropriate type selection automatically ...
    ... InlineString ... inlinestrings ...
    """
    let
        s1 = InlineString("x"); @test s1 isa String1
        s2 = InlineString("∀"); @test s2 isa String3
        sv = inlinestrings(["The", "quick", "brown"]); @test sv isa Vector{String7}
        # @test Int[] isa Vector{Int64}
    end
    ## Performance of fixed-width strings
    ## Listing 6.7
    let 
        n = 10^6
        Random.seed!(1234)
        s1 = [randstring(3) for i in 1:n]; @test length(s1) == n
        s2 = inlinestrings(s1); @test s2 isa Vector{String3}; @test length(s2) == n
        """... compare how much memory ..."""
        @test Base.summarysize(s1) == 19000040
        @test Base.summarysize(s2) ==  4000040
        """... the performance of sorting ..."""
        # @btime sort($s1)   # 257.064 ms (4 allocations: 11.44 MiB)
        # @btime sort($s2)   #   6.541 ms (6 allocations: 7.65 MiB)

        ## Exercise 6.2
        s3 = Symbol.(s1); @test length(s3) == n
        # @btime sort($s3)   # 209.589 ms (4 allocations: 11.44 MiB)
        # @btime unique($s1) # 150.966 ms (49 allocations: 10.46 MiB)
        # @btime unique($s2) #  30.505 ms (48 allocations: 6.16 MiB)
        # @btime unique($s3) #  27.572 ms (49 allocations: 10.46 MiB)
    end

    ## 6.8 Compressing vectors of strings with PooledArrays.jl
    """... compare the memory footprint of uncompressed vs. compressed data."""
    ## 6.8.1 Creating a file containing flower names
    ## 6.8.2 Reading in the data to a vector and compressing it
    let filename = "iris.txt", n = 10^6 
        if !isfile(filename) open(filename, "w") do io
            for i in 1:n
                println(io, "Iris setosa")
                println(io, "Iris virginica")
                println(io, "Iris versicolor")
            end
        end end

        @test isfile(filename)

        uncompressed = readlines(filename)
        @test length(uncompressed) == 3*n
        """...compress this vector..."""
        compressed = PooledArray(uncompressed) # slow
        @test length(compressed) == 3*n
        @test Base.summarysize(uncompressed) == 88000040
        @test Base.summarysize(compressed)   == 12000600
    end
    ## 6.8.3 Internal design of PooledArray
    """
    ... It will be beneficial to use pooled vectors if you have a collection
    of strings that have few unique values ...
    """
    ## 6.9 Choosing an appropriate storage for collections of strings
    """
    ... premature optimization is the root of all evil. ...
    """
    ## 6.10 Summary
    raw"""
    ... Downloads.download() ...
    ... "a" * "b" == "ab" ...
    ... x = 10 ... "$x" == "10" ...
    ... raw"C:\DIR" ...
    ... split("a,b", ",") ...
    ... SubString{String} ...
    ... specify AbstractString as a type parameter in function ...
    ... regular expressions ... r"a.a" ...
    ... parse(Int, "10") ...
    ... length(), chop(), first(), and last() ...
    ... FreqTables.freqtable and proptable ...
    ... Symbol ... :some_symbole ...
    ... InlineStrings ... inlinestrings() ... String1, String3 ...
    ... PooledArrays ...
    ... CSV.jl ...
    """
end

"""
    learn_ch7()

Handling time series data and missing values
"""
function learn_ch7()
    """
    ... analyzing the PLN/USD exchange ... Web API ... https://api.nbp.pl/en.html ...
    format of the data ... HTTP GET ... handling errors ... extracting the PLN/USD
    exchange rate ... statistical analysis ... plotting ... JSON format ...
    """
    ## 7.1 Understanding the NBP Web API
    ## 7.1.1 Getting the data via a web browser
    """
    https://api.nbp.pl/api/exchangerates/rates/a/usd/2020-06-01/?format=json

    {
        "table":"A",
        "currency":"dolar amerykański",
        "code":"USD",
        "rates":[
            {"no":"105/A/NBP/2020", "effectiveDate":"2020-06-01", "mid":3.9680}
        ]
    }
    """
    ## 7.1.2 Getting the data using Julia
    query = "https://api.nbp.pl/api/exchangerates/rates/a/usd/2020-06-01/?format=json"
    
    ## Read from server
    # response = HTTP.get(query)
    # @test response.body isa Vector{UInt8}
    # json = JSON3.read(response.body)

    ## Copied here so no need to query every time
    # From UInt8
    response = UInt8[0x7b, 0x22, 0x74, 0x61, 0x62, 0x6c, 0x65, 0x22, 0x3a, 0x22, 0x41, 0x22, 0x2c, 0x22, 0x63, 0x75, 0x72, 0x72, 0x65, 0x6e, 0x63, 0x79, 0x22, 0x3a, 0x22, 0x64, 0x6f, 0x6c, 0x61, 0x72, 0x20, 0x61, 0x6d, 0x65, 0x72, 0x79, 0x6b, 0x61, 0xc5, 0x84, 0x73, 0x6b, 0x69, 0x22, 0x2c, 0x22, 0x63, 0x6f, 0x64, 0x65, 0x22, 0x3a, 0x22, 0x55, 0x53, 0x44, 0x22, 0x2c, 0x22, 0x72, 0x61, 0x74, 0x65, 0x73, 0x22, 0x3a, 0x5b, 0x7b, 0x22, 0x6e, 0x6f, 0x22, 0x3a, 0x22, 0x31, 0x30, 0x35, 0x2f, 0x41, 0x2f, 0x4e, 0x42, 0x50, 0x2f, 0x32, 0x30, 0x32, 0x30, 0x22, 0x2c, 0x22, 0x65, 0x66, 0x66, 0x65, 0x63, 0x74, 0x69, 0x76, 0x65, 0x44, 0x61, 0x74, 0x65, 0x22, 0x3a, 0x22, 0x32, 0x30, 0x32, 0x30, 0x2d, 0x30, 0x36, 0x2d, 0x30, 0x31, 0x22, 0x2c, 0x22, 0x6d, 0x69, 0x64, 0x22, 0x3a, 0x33, 0x2e, 0x39, 0x36, 0x38, 0x30, 0x7d, 0x5d, 0x7d]
    json = JSON3.read(response) 
    # From String
    response = """{"table":"A","currency":"dolar amerykański","code":"USD","rates":[{"no":"105/A/NBP/2020","effectiveDate":"2020-06-01","mid":3.9680}]}"""
    json = JSON3.read(response) 

    let ## Side note: String()
        response = UInt8[0x7b, 0x22, 0x74, 0x61, 0x62, 0x6c, 0x65, 0x22, 0x3a, 0x22, 0x41, 0x22, 0x2c, 0x22, 0x63, 0x75, 0x72, 0x72, 0x65, 0x6e, 0x63, 0x79, 0x22, 0x3a, 0x22, 0x64, 0x6f, 0x6c, 0x61, 0x72, 0x20, 0x61, 0x6d, 0x65, 0x72, 0x79, 0x6b, 0x61, 0xc5, 0x84, 0x73, 0x6b, 0x69, 0x22, 0x2c, 0x22, 0x63, 0x6f, 0x64, 0x65, 0x22, 0x3a, 0x22, 0x55, 0x53, 0x44, 0x22, 0x2c, 0x22, 0x72, 0x61, 0x74, 0x65, 0x73, 0x22, 0x3a, 0x5b, 0x7b, 0x22, 0x6e, 0x6f, 0x22, 0x3a, 0x22, 0x31, 0x30, 0x35, 0x2f, 0x41, 0x2f, 0x4e, 0x42, 0x50, 0x2f, 0x32, 0x30, 0x32, 0x30, 0x22, 0x2c, 0x22, 0x65, 0x66, 0x66, 0x65, 0x63, 0x74, 0x69, 0x76, 0x65, 0x44, 0x61, 0x74, 0x65, 0x22, 0x3a, 0x22, 0x32, 0x30, 0x32, 0x30, 0x2d, 0x30, 0x36, 0x2d, 0x30, 0x31, 0x22, 0x2c, 0x22, 0x6d, 0x69, 0x64, 0x22, 0x3a, 0x33, 0x2e, 0x39, 0x36, 0x38, 0x30, 0x7d, 0x5d, 0x7d]
        @test !isempty(response)
        String(response) # response is empty after this
        @test isempty(response)
    end

    @test json.table    == "A"
    @test json.currency == "dolar amerykański"
    @test json.code     == "USD"
    @test json.rates[1].no            == "105/A/NBP/2020"
    @test json.rates[1].effectiveDate == "2020-06-01"
    @test json.rates[1].mid           ==3.9680

    let ## Side note: only()
        @test only([1]) == 1
        @test_throws ArgumentError only([])
        @test_throws ArgumentError only([1,2])
    end

    """7.1.3 Handling cases when NBP Web API query fails"""
    """
    https://api.nbp.pl/api/exchangerates/rates/a/usd/2020-06-06/?format=json

    404 NotFound - Not Found - Brak danych
    """
    let
        """Using the try-catch-end block to handle exceptions"""
        function query_nbp(query)
            try
                response = HTTP.get(query)
                json = JSON3.read(response.body)
                return only(json.rates).mid
            catch e
                if e isa HTTP.ExceptionRequest.StatusError
                    return missing
                else
                    rethrow(e)
                end
            end
        end
        ## Disabled so do not query all the time
        # query = "https://api.nbp.pl/api/exchangerates/rates/a/usd/" *
        #         "2020-06-01/?format=json"
        # @test query_nbp(query) == 3.968
        # query = "https://api.nbp.pl/api/exchangerates/rates/a/usd/" * 
        #         "2020-06-06/?format=json"
        # @test ismissing(query_nbp(query))
    end
    """7.2 Missing data in Julia"""
    """7.2.1 Definition of the missing value"""
    """
    Julia provides support for representing missing values in the statistical
    sense, that is for situations where no value is available for a variable in
    an observation, but a valid value theoretically exists.
    """
    @test ismissing(missing)
    @test !ismissing(1)
    """
    ... nothing ... absence of the value 
    ... missing ... value exists but has not been recorded.
    """
    
    """7.2.2 Working with missing values"""
    """7.2.2. Propagation of missing values in functions"""

    """
    ... many functions silently propagate missing, ...
    ... three-valued-logic ... true, false, or missing from logical operation.
    """
    @test ismissing(1 + missing)
    @test ismissing(sin(missing))
    @test ismissing(1 == missing)
    @test ismissing(1 > missing)
    @test ismissing(1 < missing)

    @test_throws TypeError if missing end
    @test_throws TypeError missing && true
    @test_throws TypeError missing && false
    """
    ... coalesce() returns its first non-missing position argument or
    missing if all ... missing
    """
    @test coalesce(missing, true) == true   # true if missing
    @test coalesce(missing, false) == false # false if missing
    """7.2.2. Comparison operators guaranteeing Boolean result"""
    @test isequal(      1,missing) == false
    @test isequal(missing,missing) == true
    """... missing is greater than all numbers ..."""
    @test isless(      1, missing) == true
    @test isless(    Inf, missing) == true
    @test isless(missing, missing) == false
    """... === always returns a Bool ..."""
    @test missing === missing
    let
        a = [1]
        b = [1]
        @test isequal(a,b)
        @test a == b
        @test !(a === b)
    end
    """Relationship between ===, == and isequal()"""
    """1. === always returns Bool"""
    """2. == falls back to ===, if no special method defined"""
    @test ismissing(     13 == missing)
    @test ismissing(missing == missing)
    @test (13.0 == NaN) == false
    @test (NaN  == NaN) == false
    @test +0.0 == -0.0
    """3. isequal() is like == but always return Bool, special values are..."""
    @test isequal(   13.0, missing) == false
    @test isequal(missing, missing) == true
    """isequal() is used to compare keys in dictionaries"""

    
    let
        """7.2.2. Replacing missing values in collections"""
        x = [1, missing, 3, 4, missing]
        @test coalesce.(x, 0) == [1,0,3,4,0]
        @test ismissing(sum(x))      # Adding missing value results in missing
        """7.2.2. Skipping missing values in computations"""
        y = skipmissing(x)
        @test sum(y) == 8
    end

    """7.2.2. Enabling missing propagation in a function"""
    let
        fun(x::Int, y::Int) = x + y # function does not accept missing
        @test fun(1, 2) == 3
        @test_throws MethodError fun(1, missing)
        
        fun2 = passmissing(fun) # Enable fun() to handle missing
        @test fun2(1, 2) == 3
        @test ismissing(fun2(1, missing)) # Accept missing and return missing
    end
    
    let
        """
        Exercise 7.1

        Given a vector v = ["1", "2", missing, "4"], parse it so that strings are
        converted to numbers and missing value remains a missing value.
        """        
        v = ["1", "2", missing, "4"]
        ms_parse = passmissing(parse)
        Ans = ms_parse.(Int, v); #@show Ans
        @test isequal(Ans, [1,2,missing,4])
        
    end
    
    """7.3 Getting the time series data from NBP Web API"""
    
    """
    ... get the data for all days of June 2020 ... work with dates ...
    timestamps ... Dates ...
    """
    
    """7.3.1 Working with dates"""

    let
        d = Date("2020-06-01")
        @test d isa Date
        @test d == Date(2020,06,01)
        @test year(d)  == 2020
        @test month(d) == 6
        @test day(d)   == 1

        @test dayname(d)   == "Monday"
        @test dayofweek(d) == 1

        """... a vector of dates ..."""
        dates = Date.(2020, 6, 1:30)
        @test length(dates) == 30
        @test first(dates) == Date(2020,6,1)
        @test last(dates) == Date(2020,6,30)
        """... add dates with durations to get new dates ..."""
        @test Date(2020,6,1) + Day(1) == Date(2020,6,2)
        """... a range of dates ..."""
        dates = Date(2020,5,20):Day(1):Date(2020,7,5)
        @test length(dates) == 47
        @test first(dates) == Date(2020,5,20)
        @test last(dates) == Date(2020,7,5)
        @test collect(dates) isa Vector{Date}
    end
    
    let
        """
        EXERCISE 7.2
    
        Create a vector containing first days of each month in the year 2021.
        """
        @test dayname.(Date(2021,1,1):Month(1):Date(2021,12,31)) == ["Friday", "Monday", "Monday", "Thursday", "Saturday", "Tuesday", "Thursday", "Sunday", "Wednesday", "Friday", "Monday", "Wednesday"]
    end

    """7.3.2 Fetching data from NBP Web API for a range of dates"""
    
    let
        dates = Date.(2020, 6, 1:30)
        ## Disabled so do not query all the time
        # rates = get_rate.(dates)
        rates = Union{Missing, Float64}[3.968, 3.9303, 3.9121, 3.9573, 3.9217, missing, missing, 3.9197, 3.9453, 3.918, missing, 3.9299, missing, missing, 3.9413, 3.9058, 3.9532, 3.9589, 3.9741, missing, missing, 3.9667, 3.9311, 3.9395, 3.9623, 3.9697, missing, missing, 3.9656, 3.9806]
    end
    """7.4 Analyzing the data fetched from NBP Web API"""
    """
    ... basic summary statistics ... missing data ... plot ...
    """

    """7.4.1 Computing summary statistics"""
    let
        rates = Union{Missing, Float64}[3.968, 3.9303, 3.9121, 3.9573, 3.9217, missing, missing, 3.9197, 3.9453, 3.918, missing, 3.9299, missing, missing, 3.9413, 3.9058, 3.9532, 3.9589, 3.9741, missing, missing, 3.9667, 3.9311, 3.9395, 3.9623, 3.9697, missing, missing, 3.9656, 3.9806]
        @test ismissing(mean(rates))
        @test ismissing(std(rates))
        let ## Side note
            x = [1,2,missing]
            @test ismissing(mean(x))
            @test mean(skipmissing(x)) == 1.5 # not 1
        end
        @test isapprox(mean(skipmissing(rates)), 3.945; atol=1e-3)
        @test isapprox(std(skipmissing(rates)), 0.022; atol=1e-3)
    end
    """7.4.2 Finding in which days of week we have the most missing values"""
    let
        dates = Date.(2020, 6, 1:30)
        rates = Union{Missing, Float64}[3.968, 3.9303, 3.9121, 3.9573, 3.9217, missing, missing, 3.9197, 3.9453, 3.918, missing, 3.9299, missing, missing, 3.9413, 3.9058, 3.9532, 3.9589, 3.9741, missing, missing, 3.9667, 3.9311, 3.9395, 3.9623, 3.9697, missing, missing, 3.9656, 3.9806]
        Ans = proptable(dayname.(dates), ismissing.(rates), margins=1)
        
        """... Boolean vector ..."""
        Ans = dayname.(dates) .== "Thursday" .&& ismissing.(rates)
        @test dates[Ans] == [Date(2020,6,11)] # Poland national holiday
    
        """7.4.3 Plotting the PLN/USD exchange rate"""
        # display(
        #     plot(dates, rates; xlabel="day", ylabel="PLN/USD", legend=false)
        # )
        """... skip ... missing ..."""
        rates_ok = .!ismissing.(rates)
        # display(
        #     plot(dates[rates_ok], rates[rates_ok]; xlabel="day", ylabel="PLN/USD", legend=false)
        # )
        """
        ... linearly interpolated ... missing ...
        Impute.interp ... Impute.jl ...
        """
        rates_filled = Impute.interp(rates)
        @test any(ismissing.(rates_filled)) == false # no missing
        #display(plot(dates[rates_ok], rates[rates_ok]; legend=false))
        #display(scatter!(dates, rates_filled; legend=false))
    
        """
        EXERCISE 7.3
    
        The NBP Web API allows you to get a sequence of rates for a period of dates.
        For example, the query "https://api.nbp.pl/api/exchangerates/rates/a/usd/2020-06-01/2020-06-30/?format=json"
        returns a sequence of rates from June 2020 for dates where the rate is
        present. In other words, dates for which there is no rate are skipped.
        Your task is to parse the result of the above query and confirm that the
        obtained result is consistent with the data we collected in the dates and
        rates vectors.
        """
    
        date_1 = Date(2020,6,1)
        date_2 = Date(2020,6,30)
        ## Disabled so do not query all the time
        #dates,rates = query_nbp(date_1, date_2)
        dates2 = ["2020-06-01", "2020-06-02", "2020-06-03", "2020-06-04", "2020-06-05", "2020-06-08", "2020-06-09", "2020-06-10", "2020-06-12", "2020-06-15", "2020-06-16", "2020-06-17", "2020-06-18", "2020-06-19", "2020-06-22", "2020-06-23", "2020-06-24", "2020-06-25", "2020-06-26", "2020-06-29", "2020-06-30"]
        rates2 = [3.968, 3.9303, 3.9121, 3.9573, 3.9217, 3.9197, 3.9453, 3.918, 3.9299, 3.9413, 3.9058, 3.9532, 3.9589, 3.9741, 3.9667, 3.9311, 3.9395, 3.9623, 3.9697, 3.9656, 3.9806]

        @test Date.(dates2) == dates[rates_ok]
        @test rates2 == rates[rates_ok]
    end
end

"""
    query_nbp(query::AbstractString)

Query NBP (National Bank of Poland?) with exception handling.
The query is in this format
```
query = "https://api.nbp.pl/api/exchangerates/rates/" *
        "a/usd/2020-06-01/?format=json"
```

Using the try-catch-end block to handle exceptions
"""
function query_nbp(query::AbstractString)
    try
        response = HTTP.get(query)
        json = JSON3.read(response.body)
        return only(json.rates).mid
    catch e
        if e isa HTTP.ExceptionRequest.StatusError
            return missing
        else
            rethrow(e)
        end
    end
end

"""
    get_rate(date::Date)

Get exchange rate from NBP.
"""
function get_rate(date::Date)
    query = "https://api.nbp.pl/api/exchangerates/rates/" *
            "a/usd/$date/?format=json"
    try
        response = HTTP.get(query)
        json = JSON3.read(response.body)
        return only(json.rates).mid
    catch e
        if e isa HTTP.ExceptionRequest.StatusError
            return missing
        else
            rethrow(e)
        end
    end
end


"""
    query_nbp(date_1::Date, date_2::Date)

Get exchange rates between two dates.  Only valid data is returned from the server.
"""
function query_nbp(date_1::Date, date_2::Date)
    query = "https://api.nbp.pl/api/exchangerates/rates/" *
                "a/usd/$(date_1)/$(date_2)/?format=json"
    try
        response = HTTP.get(query)
        json = JSON3.read(response.body)
        dates = [rate.effectiveDate for rate in json.rates]
        rates = [rate.mid for rate in json.rates]
        return dates, rates
    catch e
        if e isa HTTP.ExceptionRequest.StatusError
            return missing
        else
            rethrow(e)
        end
    end
end

"""
Part 2: Toolbox for Data Analysis

... DataFrames.jl ... data analysis piplines ... 
fetching, reading, transformation data ...
"""

"""
    learn_ch8()

Chapter 8: First steps with data frames
```
This chapter covers
... compressed files
... CSV ... Apache Arrow ... SQLite ...
... get columns ...
... statistics of data ...
... visualization ... 

... DataFrames.jl ... chess puzzle ... popularity vs. difficulty ...
data ... Lichess ... bzip2 ... CSV ... select column ... Apache Arrow ...
SQLite ...
```
"""
function learn_ch8()
    """8.1 Fetching, unpacking, and inspecting the data"""
    let
        
        # https://github.com/bkamins/JuliaForDataAnalysis/blob/main/puzzles.csv.bz2
        filename = "puzzles.csv.bz2"
        url = "https://github.com/bkamins/JuliaForDataAnalysis/blob/main/puzzles.csv.bz2" 
        #url = "https://database.lichess.org/lichess_db_puzzle.csv.bz2"
       
        if isfile(filename)
            @info "$filename already present"
        else
            @info "Download $filename"
            Download.download(url, filename)
        end
    end
end

current_logger = global_logger()
global_logger(ConsoleLogger(stdout, Logging.Info))

# learn_memory_layout()
# learn_types()
# learn_ch2()
# learn_ch4()
# learn_ch5()
# learn_ch6()
# learn_ch7()
learn_ch8()

global_logger(current_logger)
end # LearnJuliaDataAnalysis