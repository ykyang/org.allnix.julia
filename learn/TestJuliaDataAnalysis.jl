module TestJuliaDataAnalysis
using Test
using Logging

include("LearnJuliaDataAnalysis.jl")

current_logger = global_logger()
global_logger(ConsoleLogger(stdout, Logging.Info))

@testset "Chapter 2" begin
    LearnJuliaDataAnalysis.learn_ch2()
end

global_logger(current_logger)
end