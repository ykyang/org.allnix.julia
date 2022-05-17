# Book: Julia for Data Analysis
# https://livebook.manning.com/book/julia-for-data-analysis/chapter-2/v-3/10

# 2 Getting started with Julia
# k-times winsorized mean

module LearnJuliaDataAnalysis
using Logging
using Test
using InteractiveUtils # supertypes()
using DataStructures

using StatsBase      # Chapter 3
using BenchmarkTools # Chapter 3

include("Learn.jl")
using .Learn

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

function learn_ch4()
    ## 4.1 Working with arrays


    ## 4.1.1 Getting the data into a matrix
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
    @test size(aq) == (11,8)
    @test size(aq,1) == 11
    @test size(aq,2) == 8

    ## 4.2 Mapping key-value pairs with dictionaries
end

current_logger = global_logger()
global_logger(ConsoleLogger(stdout, Logging.Info))

# learn_memory_layout()
# learn_types()
# learn_ch2()

global_logger(current_logger)
end # LearnJuliaDataAnalysis