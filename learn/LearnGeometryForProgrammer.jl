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

end

nothing