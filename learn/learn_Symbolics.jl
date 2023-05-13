module LearnSymbolics

using Test
using Symbolics

@variables x y
@show typeof(x)
z = x^2 + y
Ans = substitute(z, Dict(x=>2,y=>3))
println(Ans)
@test Ans == 7

Ans = substitute(z, Dict(y=>3))
println(Ans)

Ans = Symbolics.solve_for([x+y~0, x-y~2],[x,y])
println(Ans)
@test Ans == [1.0, -1.0]



## https://symbolics.juliasymbolics.org/stable/examples/perturbation/
"""
# Arguments
- `f`: Equation, `f(x)`
- `x`: Variable
- `xᵢ`: Initial guess
"""
function solve_newton(f, x, xᵢ; abstol=1e-8, maxiter=50)
    xₙ = xᵢ
    ## xn+1 = fn+1(xn) = xn - f(xn)/f'(xn)
    fₙ₊₁ = x - f/Symbolics.derivative(f, x) # Equation

    for i in 1:maxiter
        xₙ₊₁ = substitute(fₙ₊₁, Dict(x=>xₙ))
        if abs(xₙ₊₁ - xₙ) < abstol
            return xₙ₊₁
        else
            xₙ = xₙ₊₁
        end
    end
    ## maxiter reached
    return xₙ₊₁
end

let
    @variables x
    f = x^5 + x - 1
    Ans = solve_newton(f, x, 1)
    @show Ans
    @show substitute(f, Dict(x=>Ans))
end

"""

f(x) = ax + bx^2 + cx^3 + dx^4 + ex^2 + gx^4
Collect coefficients of various powers of x's

# Arguments
- `ns`: Array of powers whose coefficients will be collected
- `x`: Variable

"""
function collect_powers(eqn, x, ns; max_power=100)
    ## Remove orders higher than maximium of ns
    vars = Dict(x^j => 0 for j = maximum(ns)+1:max_power)
    eqn = substitute(eqn, vars) # call expand(eqn) outside of this function

    coefs = Num[]
    zero_powers = Dict(x^j => 0 for j=1:maximum(ns))
    
    for i in ns
        powers = zero_powers
        #powers = copy(zero_powers)
        powers[x^i] = 1
        push!(coefs, substitute(eqn, powers))
        powers[x^i] = 0
    end

    return coefs
end

## Solving the Quintic: x^5 + x = 1
## https://symbolics.juliasymbolics.org/stable/examples/perturbation/#Solving-the-Quintic
let
    n = 10 # 2
    @variables ε a[1:n] a₀
    # ₀ ε
    a₀ = 1
    #x = a₀ + a[1]*ε + a[2]*ε^2 # x(ε)
    x = a₀
    for i = 1:n
        x = x + a[i]*ε^i
    end
    @show x
    eqn = x^5 + ε*x - 1
    #@show expand(eqn)
    #@show simplify(expand(eqn))
    ε_coefs = collect_powers(expand(eqn), ε, 1:n) # coef of ε in terms of a's
    # 1: 1 + 5a[1]
    # 2: 10(a[1]^2) + 5a[2] + a[1]
    #a_vals = Dict(a₀=>a₀) # store values of a₀, a[1], a[2] ...
    a_vals = Dict() # store values of a₀, a[1], a[2] ...
    for i in 1:length(a)
        eq = substitute(ε_coefs[i], a_vals)
        a_vals[a[i]] = Symbolics.solve_for(eq~0, a[i])
    end

    @show a_vals
    @show substitute(x, a_vals)
    y = substitute(x, a_vals)
    @show substitute(y, Dict(ε=>1))

end

end

nothing
