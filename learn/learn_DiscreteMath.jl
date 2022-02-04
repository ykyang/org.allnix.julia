# Discrete Mathematics and its Application

module DiscreteMath

"""

Algorithm 4 The Bubble Sort on pp.208.

Sort array `a` using bubble sort.
"""
function bubble_sort!(a)
    n = length(a)
    for i in 1:n-1
        for j in 1:n-i
            if a[j] > a[j+1]
                a[j], a[j+1] = a[j+1], a[j] # swap the Julia way
            end
        end
    end

    nothing
end

"""

Algorithm 5 The Insertion Sort, pp.208
"""
function insertion_sort!(a)
    for j in 2:length(a)
        i = 1
        while a[j] > a[i]
            i += 1
        end
        # a[j] <= a[i], move a[j] to where a[i] is
        m = a[j] # tmp storage
        # shift a[i]..a[j-1] one position to the right
        # this is easier to understand then the k stuff in the book
        a[i+1:j] .= a[i:j-1] 
        a[i] = m
    end

    nothing
end

"""

Boolean product on pp.193
"""
function product(A::Matrix{Bool}, B::Matrix{Bool})
    # Check size(A)[2] == size(B)[1] ???
    X = Matrix{Bool}(undef, size(A)[1], size(B)[2])
    for i in 1:size(A)[1]
        for j in 1:size(B)[2]
            X[i,j] = any(A[i,:] .& B[:,j])
        end
    end

    return X
end



end # module DiscreteMath

using Test

dm = DiscreteMath # short hand



@testset "Boolean Product" begin
    # Example 9, pp.193
    C = Bool[0 0 1; 1 0 0; 1 1 0;]
    C2 = dm.product(C,C)
    @test C2 == [1 1 0; 0 0 1; 1 0 1;]
    C3 = dm.product(C2,C)
    @test C3 == [1 0 1; 1 1 0; 1 1 1;]
    C4 = dm.product(C3,C)
    @test C4 == [1 1 1; 1 0 1; 1 1 1;]
    C5 = dm.product(C4,C)
    @test C5 == [1 1 1; 1 1 1; 1 1 1;]
end

@testset "Bubble Sort" begin
    a = [5,4,3,2,1]

    b = copy(a)
    dm.bubble_sort!(b)
    @test b == [1,2,3,4,5]
end

@testset "Insertion Sort" begin
    a = [5,4,3,2,1]

    b = copy(a)
    dm.insertion_sort!(b)
    @test b == [1,2,3,4,5]
end

nothing
