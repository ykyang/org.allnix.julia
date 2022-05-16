module TestJuliaDataAnalysis
using Test
using Logging

include("LearnJuliaDataAnalysis.jl")

current_logger = global_logger()
global_logger(ConsoleLogger(stdout, Logging.Info))

@testset "Chapters" begin
    LearnJuliaDataAnalysis.learn_ch2()
    LearnJuliaDataAnalysis.learn_ch3()
end

global_logger(current_logger)
end