using Test

include("learn_DataFrames.jl")

import ..LearnDataFrames
using ..LearnDataFrames

@testset "Base" begin
    LearnDataFrames.unsupported_DataFrame()
    LearnDataFrames.learn_add_column()
    LearnDataFrames.learn_eltype()
    LearnDataFrames.learn_get_column()
    LearnDataFrames.learn_constructor()
    LearnDataFrames.learn_empty_constructor()
    #LearnDataFrames.learn_csv()
    LearnDataFrames.learn_csv_io()
    LearnDataFrames.learn_groupby_1()
    LearnDataFrames.learn_hcat()
    LearnDataFrames.learn_rename()
    LearnDataFrames.learn_row_iteration()
    LearnDataFrames.learn_set_value()
    LearnDataFrames.learn_sort()
    LearnDataFrames.learn_transform_1()
    LearnDataFrames.learn_filter_1()
    LearnDataFrames.learn_unique()
    LearnDataFrames.test_simple_table2()
end

nothing
