using Test
"""
    add(a,b)

Return `a + b`.

Base library use this pattern to document variant of methods and define abstract
function name.
"""
function add end

function add(a,b)
    a+b
end

# A Fix2 defined for add for convenience
"""
    add(b)

Create a function that adds its argument to `b`, i.e.
a function equivalent to `f(x) = add(x,b)`.

Base library use this pattern to document variant of methods.
"""
add(x) = Base.Fix2(add, x)

function learn_Fix2()
    data = [1, 3, 5,  7, 11]
    Ans  = data .+ 3         # [4, 6, 8, 10, 14]
   
    # Using Fix2, concise 
    @test Ans == add(3).(data)
    # Not using Fix2, verbose
    add3(a) = add(a,3)
    @test Ans == add3.(data)

    equal3 = ==(3) # Built-in Fix2
    @test true == equal3(3)
    @test false == equal3(5)
end

@testset "Fix2" begin
    learn_Fix2()
end

nothing
