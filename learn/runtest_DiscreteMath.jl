using Test

include("test_DiscreteMath.jl")
import ..TestDiscreteMath

@testset "Boolean Product" begin
    TestDiscreteMath.test_product()
end

@testset "Bubble Sort" begin
    TestDiscreteMath.test_bubble_sort!()
end

@testset "Insertion Sort" begin
    TestDiscreteMath.test_insertion_sort!()
end

@testset "Navie String Matcher" begin
    TestDiscreteMath.test_string_match()
end

@testset "Cashier's Algorithm" begin
    TestDiscreteMath.test_change()
end

@testset "Greedy Algorithm for Scheduleing Talks" begin # pp.212
    TestDiscreteMath.test_schedule()
end

@testset "Brute-Force Algorithm for Closest Pair of Points" begin
    TestDiscreteMath.test_closest_pair()
end

nothing
