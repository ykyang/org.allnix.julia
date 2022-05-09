# Book: Julia for Data Analysis
# https://livebook.manning.com/book/julia-for-data-analysis/chapter-2/v-3/10

# 2 Getting started with Julia
# k-times winsorized mean

module LearnJuliaDataAnalysis
using Logging
using Test

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

end

current_logger = global_logger()
global_logger(ConsoleLogger(stdout, Logging.Info))

# learn_memory_layout()
# learn_types()
# learn_ch2()

global_logger(current_logger)
end