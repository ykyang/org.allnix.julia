module LearnGeometryForProgrammer

using Logging
using PythonCall
using Symbolics


function learn_1_6_py()
    ## Learn 1.6 using Python

    sympy = pyimport("sympy")

    indent = "    "
    @info "Listing 1.1 Numeric solution in SymPy"
    let 
        Va, Vp = sympy.symbols("Va Vp")

        # @show pytype(Va) # pytype(Va) = <py class 'sympy.core.symbol.Symbol'>
        # @show Vp # Vp = <py Vp>
        solution = sympy.solve([
            Vp - Va * 2,
            Va*1 + Vp*1 - 450,
        ], (Va,Vp)) 
        # @show solution # solution = <py {Va: 150, Vp: 300}>
        
        @info "$(indent)$(solution)"
    end

    @info "Listing 1.2 Symbolic solution in SymPy"
    let 
        Va, Vp, Vpx, D, t = sympy.symbols("Va Vp Vpx D t")

        solution = sympy.solve([
            Vp - Va*Vpx,
            Va*t + Vp*t - D,
        ], (Va, Vp))
        @info "$(indent)$(solution)"
        @info "$(indent)Python: $(sympy.pycode(solution))"
        @info "$(indent)Julia: $(sympy.julia_code(solution))"
        @info "$(indent)LaTeX: $(sympy.latex(solution))"
    end

    nothing
end

function learn_1_6()
    ## Learn 1.6 using Julia
    indent = "    "

    @info "Listing 1.1 Numeric solution in SymPy"
    let
        @variables Va Vp
        Ans = Symbolics.solve_for([
            Vp ~ Va*2, 
            Va*1 + Vp*1 ~ 450,
        ],[Va,Vp])
        @info "$(indent)$([Va,Vp])=$(Ans)"
    end
    @info "Listing 1.2 Symbolic solution in SymPy"
    let 
        @variables Va, Vp, Vpx, D, t
        Ans = Symbolics.solve_for([
            Vp ~ Va*Vpx,
            Va*t + Vp*t ~ D,
        ], [Va,Vp])
        @info "$(indent)$([Va,Vp])=$(Ans)"
        Ans = Symbolics.simplify.(Ans)
        @info "$(indent)$([Va,Vp])=$(Ans)"

    end
end

"""
2.    Terminology and jargon
2.1.1 Numbers
      ℕ, natural number, do not include zero, 1, 2, 3, ...
      ℕ0, ISO 80000-2, include zero, 0, 1, 2, ...
      ℤ, integer
      ℚ, rational
      Irrational
      ℝ, real number
      Imaginary number
      Complex number
2.1.2 Vectors TODO
2.2   Vertices and triangles
2.2.1 Being pedantic about triangles
2.2.2 Triangle quality TODO
      Degenerate triangle, zero area, needle, cap
      Manifold triangle mesh
      Near-degenerate triangles
      Rin/Rout metric
2.3   Lines, planes, and their equations
2.3.1 Lines and planes
      General form, implicit
      Canonical equation
2.3.2 The parametric form for 3D lines
      Parametric form
2.4   Functions and geometric transformations
2.4.1 What is a function?
      Codomain, range
2.4.2 Function types most commonly used in geometric modeling
      Geometric transformation
      Signed distance function
2.5   The shortest possible introduction to matrix algebra
2.5.1 What is algebra?
      Isomorphism
2.5.2 How does matrix algebra work?
3.    The geometry of linear equations
3.1   Linear equations as lines and planes
      Definition of linear equation, solution


"""


end

nothing