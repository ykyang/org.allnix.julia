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

Algorithm 8 Greedy Algorithm for Scheduleing Talks, pp.212.

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

"""
    closest_pair(P)

Algorithm 3 Brute-Force Algorithm for Closest Pair of Points, pp.238.

Find the closest pair of points in `P`.  Each row of `P` is a point, and the
number of rows in `P` is the number of points.  Return the row numbers of the
two closes points, and the shortest distance.  
If two pairs are the same minimum distance then the first
pair is returned.

# Example
```
julia> P = [1 1 1; 2 2 2; 3 3 3; 4 4 4]
julia> ans,dist = DiscreteMath.closest_pair(P)
julia> @test ans == [1,2]
julia> @test dist == 3^0.5
```
"""
function closest_pair(P)
    min_pair =[0,0]
    min_dist_sqr = typemax(Float64)
    for i in 2:size(P)[1] # row
        for j in 1:i-1    # compare 1:i-1 with i
            dist_sqr = sum((P[j,:] .- P[i,:]).^2)
            if dist_sqr < min_dist_sqr
                min_pair = [j,i]
                min_dist_sqr = dist_sqr
            end
        end
    end

    return min_pair, min_dist_sqr^0.5
end

"""
    gcd(a::Int64,b::Int64)

Learn The Euclidean Algorithm, pp.283
```
a = b⋅q + r
gcd(a,b) == gcd(b,r)
gcd(287,91)
287 = 91 * 3 + 14
91  = 14 * 6 + 7
14  = 7 * 2  + 0
```
Is this easier to understand?
```
gcd(r0,r1)

For hand calculation,
r0 = r1·q1 + r2 
r1 = r2·q2 + r3
r2 = r3·q3 + r4
r3 = r4·q4 + r5
r4 = r5·q5 + 0

r5 = gcd(r0,r1) = gcd(r1,r2) = gcd(r2,r3) = gcd(r3,r4)

For code,
r0 = r1·q1 + r2
r0 = r1, r1 = r2
repeat until r1 == 0, return r0


Store results in arrays, r, q
j = 2:n
r[0] = r[1]·q[1] + r[2]
...
r[j-2] = r[j-1]·q[j-1] + r[j]
...
r[n-2] = r[n-1]·q[n-1] + r[n]
r[n-1] = r[n]·q[n]


```
"""
function gcd(r0::Int64,r1::Int64)
    # r0 = r1·q1 + r2
    # r0 = r1, r1 = r2
    # repeat until r1 == 0, return r0
    #
    
    while r1 != 0
        r2 = mod(r0,r1)
        r0, r1 = r1, r2
    end

    return r0

    # a1 = a, b1 = b
    #
    # if b1 == 0 return a1
    # a1 = b1·q1 + r1
    # a2 = b1, b2 = r1
    #
    # if b2 == 0, return a2
    # a2 = b2q2 + r2
    # a3 = b2, b3 = r2

    # Old approach
    # gcd(a::Int64,b::Int64)
    # while b != 0
    #     r = mod(a,b)
    #     a,b = b,r
    # end

    # return a
end
"""

Learn finding Bezout coefficients with backward Euclidean Algorithm,
Example 17, on pp.286.

```
Bezout's Theorem
gcd(a,b) = s·a + t·b

s0 = 1, s1 = 0
t0 = 0, t1 = 1

j = 2
s2 = s0 - q1·s1
t2 = t0 - q1·t1

j = 2:n
s[j] = s[j-2] - q[j-1]*s[j-1]
t[j] = t[j-2] - q[j-1]*t[j-1]


a = 252, b = 198
a1 = 252, b1 = 198

a1 = 
```
"""
function gcd_backward(a, b)

end

"""

Use the extended Euclidean algorithm to find Bezout coefficients, pp.286.
```
Bezout's Theorem
gcd(a,b) = s·a + t·b

s0 = 1, t0 = 0
s1 = 0, t1 = 1

j = 2
s2 = s0 - q1·s1
t2 = t0 - q1·t1
j = 3
s3 = s1 - q2·s2
t3 = t1 - q2·t2

j = 2:n
s[j] = s[j-2] - q[j-1]*s[j-1]
t[j] = t[j-2] - q[j-1]*t[j-1]
```

Using to Julia index
```
The Euclidean Algorithm, find gcd(r1,r2)
r1 = r2·q2 + r3 # j = 3
r2 = r3·q3 + r4 # j = 4
r3 = r4·q4 + r5
r4 = r5·q5 + r6 # j = 6
r5 = r6·q6      # j = 7

r6 = gcd(r1,r2) = r[j-1]

j = 3:n
r[j-2] = r[j-1]·q[j-1] + r[j]
Solve q[j-1], r[j]

s1 = 1, t1 = 0
s2 = 0, t2 = 1

j = 3
s3 = s1 - q2·s2
t3 = t1 - q2·t2

j = 3:n
s[j] = s[j-2] - q[j-1]*s[j-1]
t[j] = t[j-2] - q[j-1]*t[j-1]


```

Return `gcd(r1,r2), s, t`
"""
function extended_euclidean_algorighm(r1::Int64,r2::Int64)
    # rs = Int64[r1, r2]
    # qs = Int64[-9999]
    # ss = Int64[1,0]
    # ts = Int64[0,1]

    # for j = 3:1000
    #     # q3 = fld(r1,r2)
    #     q = fld(rs[j-2], rs[j-1]) # q[j-1]
    #     r = mod(rs[j-2], rs[j-1]) # r[j]
    #     if r == 0    break    end
    #     push!(qs, q)
    #     push!(rs, r)
    #     s = ss[j-2] - qs[j-1]*ss[j-1] # s[j]
    #     t = ts[j-2] - qs[j-1]*ts[j-1] # t[j]
    #     push!(ss, s)
    #     push!(ts, t)
    # end
    # return (rs[end], ss[end], ts[end])

    s1, s2 = 1, 0
    t1, t2 = 0, 1
    while r2 != 0
        r3 = mod(r1,r2)
        q2 = fld(r1,r2)
        s3 = s1 - q2*s2
        t3 = t1 - q2*t2

        r1,r2 = r2,r3
        s1,s2 = s2,s3
        t1,t2 = t2,t3
    end
    return r1,s1,t1
end

export product, bubble_sort!, insertion_sort!, string_match, change,
       schedule

end # module DiscreteMath

