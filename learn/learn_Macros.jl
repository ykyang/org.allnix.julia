## https://docs.julialang.org/en/v1/manual/metaprogramming/

using Test

macro zerox()
    return esc(:(x=0)) # Escape x from local scope
end

function test_zerox()
    x = 1
    @zerox
    @test x == 0 # x == 1 without the esc() in the macro
    
    nothing
end


## Non-standard string literals

"""
    flag_str(str, tail)

```julia
julia> flag"Hello"World
Hello World
```
"""
macro flag_str(str, tail)
    # flag"Hello"World
    # Hello World
    :(println($str, " ", $tail))
end

## Generated functions

@generated function fun(x)
    Core.println(x) # Only print the first time the function is called
    return :(x * x)
end

