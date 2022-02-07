# Use runtest_DiscreteMath.jl to run all tests.
# Use function to run individual test.

include("learn_DiscreteMath.jl")

module TestDiscreteMath
using Test
using DataFrames
using Dates

using ..DiscreteMath

function test_product()
    # Example 9, pp.193
    C = Bool[0 0 1; 1 0 0; 1 1 0;]
    C2 = product(C,C)
    @test C2 == [1 1 0; 0 0 1; 1 0 1;]
    C3 = product(C2,C)
    @test C3 == [1 0 1; 1 1 0; 1 1 1;]
    C4 = product(C3,C)
    @test C4 == [1 1 1; 1 0 1; 1 1 1;]
    C5 = product(C4,C)
    @test C5 == [1 1 1; 1 1 1; 1 1 1;]
end

function test_bubble_sort!()
    a = [5,4,3,2,1]

    b = copy(a)
    bubble_sort!(b)
    @test b == [1,2,3,4,5]
end

function test_insertion_sort!()
    a = [5,4,3,2,1]

    b = copy(a)
    insertion_sort!(b)
    @test b == [1,2,3,4,5]
end

function test_string_match()
    t = "eceyeye"
    p = "eye"

    inds = string_match(t,p)
    @test inds == [3,5]
end

function test_change()
    # 67 cents in
    # denomations of quarter, dime, nickle, penny
    changes = change([25, 10, 5, 1], 67)
    @test changes == [2, 1, 1, 2]
end

function test_schedule()
    df = DataFrame(
        "topic" => ["Talk 1", "Talk 2", "Talk 3"],
        "start" => [Time(8,00),  Time(9,00),  Time(11,00)],
        "end"   => [Time(12,00), Time(10,00), Time(12,00)],
    )
    rdf = DiscreteMath.schedule(df)
    @test ["Talk 2","Talk 3"] == rdf[!,"topic"]

    df = DataFrame(
        "topic" => ["Talk 1", "Talk 2", "Talk 3"],
        "start" => [Time(8,00), Time(9,00),  Time(9,45)],
        "end"   => [Time(9,15), Time(10,00), Time(11,00)],
    )
    rdf = DiscreteMath.schedule(df) 
    @test ["Talk 1", "Talk 3"] == rdf[!, "topic"]
end 


end # module TestDiscreteMath