# Book: Julia for Data Analysis
# https://livebook.manning.com/book/julia-for-data-analysis/chapter-2/v-3/10

# 2 Getting started with Julia
# k-times winsorized mean

module JuliaDataAnalysis

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

current_logger = global_logger()
global_logger(ConsoleLogger(stdout, Logging.Info))

learn_memory_layout()
learn_types()

global_logger(current_logger)
end