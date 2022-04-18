using Test

include("learn_Dates.jl")
import ..LearnDates

@testset "Base" begin
    LearnDates.learn_constructors()
    LearnDates.learn_durations_comparisons()
    LearnDates.learn_accessor()
    LearnDates.learn_query()
    LearnDates.learn_time_type_period_arithmetic()
    LearnDates.learn_adjuster()
    LearnDates.learn_period_types()
    LearnDates.learn_rounding()
    LearnDates.learn_parse()
    LearnDates.learn_print()
    LearnDates.learn_arithemtic()
    LearnDates.learn_schedule_monthly()
end