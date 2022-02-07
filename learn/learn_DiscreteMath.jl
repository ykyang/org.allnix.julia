# Discrete Mathematics and its Application
# See test_DiscreteMath.jl for testing functions.
# See runtest_DiscreteMath.jl for running tests.

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

Algorithm 6 Navie String Matcher, pp.209.  

Return indices where `p` matches
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

"""

Algorithm 8 Greedy Algorithm for Scheduleing Talks.

```
df = DataFrame(
        "topic" => ["Talk 1", "Talk 2", "Talk 3"],
        "start" => [Time(8,00),  Time(9,00),  Time(11,00)],
        "end"   => [Time(12,00), Time(10,00), Time(12,00)],
    )
```
"""
function schedule(df)
    S = similar(df,0) # Copy df types without rows
    pdf = sort(df, ["end"])
    for row in eachrow(pdf)
        if compatible(S, row["start"], row["end"])
            push!(S, row)
        end
    end

    return S
end

"""

Test if the new talk with start time `s` and end time `e` is compatible
with existing talks stored in `S`.  `S` is a DataFrame with columns of
`topic`, `start`, `end`.
"""
function compatible(S, s, e)
    if isempty(S)
        return true
    end
    # The new start and end time cannot be within any talk
    for row in eachrow(S)
        start_time = row["start"]
        end_time = row["end"]
        if s > end_time 
            return true
        end
        if e < start_time
            return true
        end
    end

    return false
end

export product, bubble_sort!, insertion_sort!, string_match, change,
       schedule

end # module DiscreteMath

