module LearnGeometryForProgrammers
using Test
using Symbolics

@variables Va Vp
eqs = Vector{Equation}()
push!(eqs, Vp ~ 2Va)
push!(eqs, Va + Vp ~ 450)
eq1 = Vp ~ 2Va
#@show typeof(eq1)
@test eq1 isa Equation

Ans = Symbolics.solve_for(
    # [
    #     #Vp ~ 2Va,
    #     eq1,
    #     Va + Vp ~ 450,
    # ],
    eqs,
    [Va,Vp]
)
@test Ans == [150.0, 300.0]

@variables Va Vp Vpx D t
eqs = Equation[]
push!(eqs, Vp ~ Va*Vpx)
push!(eqs, Va*t + Vp*t ~ D)
Ans = Symbolics.solve_for(eqs, [Va,Vp])

let V = Ans[1]
    @show V
    V = simplify(V); @show V
    V = simplify(V; expand=true); @show V
end

let V = Ans[2]
    @show V
    V = simplify(V); @show V
    V = simplify(V; expand=true); @show V
end


end

nothing # to be removed
