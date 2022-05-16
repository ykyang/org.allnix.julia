# Book: Julia for Data Analysis
# https://livebook.manning.com/book/julia-for-data-analysis/chapter-2/v-3/10

# 2 Getting started with Julia
# k-times winsorized mean

module LearnJuliaDataAnalysis
using Logging
using Test
using InteractiveUtils # supertypes()
using DataStructures

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
    fun(x) = println("unsupported type")
    fun(x::Number) = println("a number was passed")
    fun(x::Float64) = println("a Float64 value")
    # fun("hello!")
    # fun(1)
    # fun(1.0)
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


current_logger = global_logger()
global_logger(ConsoleLogger(stdout, Logging.Info))

# learn_memory_layout()
# learn_types()
# learn_ch2()

global_logger(current_logger)
end