# Discrete Mathematics and its Application

module DiscreteMath

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

Algorithm 6 Navie String Matcher, pp.209.  Return indices where `p` matches
substring of `t`.  That is `t` is the text and `p` is the pattern.

Notice the returned indices is not the shifts.  Shifts is one less of indices.
"""
function string_match(t,p)
    n = length(t)
    m = length(p)
    shifts = Int64[]
    for s in 0:n-m # shift
        j = 1
        while (j<=m && t[s+j] == p[j])
            j += 1
        end
        if j > m
            push!(shifts, s)
        end
    end

    return shifts .+ 1
end

"""

Algorithm 7 Cashier's Algorithm, pp.210.  Calculate making `cents` change with 
quarters, dimes, nickels, and pennies, and using the least total number of coins.
The argument `denominations` is a list of values of denominations, such as
`[25,10,5,1]`.  Return number of coins for each denomination.
"""
function change(denominations, cents)
    # denomations must be sorted from large to small
    # number of coins for each denomation
    counts = fill(Int64(0), length(denominations))
    n = cents # remaining number of cents
    for (i,denomination) in enumerate(denominations)
        while n >= denomination
            counts[i] += 1
            n -= denomination
        end
    end

    return counts
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

@testset "Navie String Matcher" begin
    t = "eceyeye"
    p = "eye"

    inds = dm.string_match(t,p)
    @test inds == [3,5]
end

@testset "Cashier's Algorithm" begin
    # 67 cents in
    # denomations of quarter, dime, nickle, penny
    changes = dm.change([25, 10, 5, 1], 67)
    @test changes == [2, 1, 1, 2]
end
nothing
