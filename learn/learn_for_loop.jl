# Learn for-loop

using Test

"""

Learn for-loop syntax
```
for i in 1:2, j in 3:4
end
```
"""
function learn_for_comma()
    ijs = []

    for i in 1:2, j in 3:4
        push!(ijs, (i,j))
    end

    @test [
        (1,3),
        (1,4),
        (2,3),
        (2,4)
    ] == ijs
end

function learn_comprehension()
    # List of pairs
    x1 = [(i,j) for i in 1:2 for j in 3:4]
    @test [
        (1, 3), 
        (1, 4), 
        (2, 3), 
        (2, 4)
    ] == x1

    # Matrix of pairs
    x2 = [(i,j) for i in 1:2,j in 3:4]
    @test [
        (1, 3) (1, 4); 
        (2, 3) (2, 4)
    ] == x2

    # Flatten
    # Notice the order is different from x1
    @test [(1, 3), (2, 3), (1, 4), (2, 4)] == x2[:]
    @show [
        (1, 3), 
        (2, 3), 
        (1, 4), 
        (2, 4)
    ] == vec(x2)
end

@testset "For-Loop" begin
    learn_for_comma()
    learn_comprehension()
end

nothing