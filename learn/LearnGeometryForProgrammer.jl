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
3.1.1 Introducing a hyperplane
      Hyperplane
3.1.2 A solution is where hyperplanes intersect
      Indeterminate, linearly dependent
      Almost-parallel hyperplanes
3.2   Overspecified and underspecified systems
3.2.1 Overspecified systems
      Solved numerically and inaccurately
3.2.2 Underspecified systems
      Solved symbolically
3.3   A visual example of an interactive linear solver
3.3.1 The basic principle of iteration
      Iteration
3.3.2 Starting point and exit conditions
      Tolerance
3.3.3 Convergence and stability
      Stability: Not to accumulate error
3.4   Direct solver
3.4.1 Turning an iterative solver into a direct one
TODO  3.4.2 Algorithm complexity
3.5   Linear equations system as matrix multiplication
3.5.1 Matrix equations
3.5.2 What types of matrices we should know about
      Identity matrix, diagonal matrix, triangular matrix
3.5.3 Things we're allowed to do with equations
      Scale all coefficients, add equations together, swap equations
3.6   Solving linear systems with Gaussian elimination and LU-decomposition
3.6.1 An example of Gaussian elimination
3.6.2 What do "elimination" and "decomposition" mean?
3.7   Which solver fits my problem best?
3.7.1 When to use an elimination-based one
3.7.2 When to use an iterative one
3.7.3 When to use neighter
3.8   Practical example: Does a ray hit a triangle?
3.8.1 The ray-triangle intersection problem
3.8.2 Forming a system
      Px + tdx = Ax + ABxu + ACxv
      Py + tdy = Ay + AByu + ACyv
      Pz + tdz = Az + ABzu + ACzv
3.8.3 Making the equations into code
"""

function learn_3_8_3_py()
      sympy = pyimport("sympy")
      indent = "    "
      @info "Listing 3.1 Solving the ray-triangle intersection symbolically"
      let
          # Solve for t, u, v
          # Px + tdx = Ax + ABxu + ACxv
          # Py + tdy = Ay + AByu + ACyv
          # Pz + tdz = Az + ABzu + ACzv

          Px, Py, Pz    = sympy.symbols("Px Py Pz")
          dx, dy, dz    = sympy.symbols("dx, dy, dz")
          Ax, Ay, Az    = sympy.symbols("Ax, Ay, Az")
          ABx, ABy, ABz = sympy.symbols("ABx, ABy, ABz")
          ACx, ACy, ACz = sympy.symbols("ACx, ACy, ACz")
          t, u, v       = sympy.symbols("t, u, v")

          solution = sympy.solve([
            Px + t*dx - (Ax + ABx*u + ACx*v),
            Py + t*dy - (Ay + ABy*u + ACy*v),
            Pz + t*dz - (Az + ABz*u + ACz*v),
          ], (t, u, v))
          @info "$(indent)$(solution)"
          # {t: (ABx*ACy*Az - ABx*ACy*Pz - ABx*ACz*Ay + ABx*ACz*Py - ABy*ACx*Az + ABy*ACx*Pz + ABy*ACz*Ax - ABy*ACz*Px + ABz*ACx*Ay - ABz*ACx*Py - ABz*ACy*Ax + ABz*ACy*Px)/(ABx*ACy*dz - ABx*ACz*dy - ABy*ACx*dz + ABy*ACz*dx + ABz*ACx*dy - ABz*ACy*dx), 
          #  u: (ACx*Ay*dz - ACx*Az*dy - ACx*Py*dz + ACx*Pz*dy - ACy*Ax*dz + ACy*Az*dx + ACy*Px*dz - ACy*Pz*dx + ACz*Ax*dy - ACz*Ay*dx - ACz*Px*dy + ACz*Py*dx)            /(ABx*ACy*dz - ABx*ACz*dy - ABy*ACx*dz + ABy*ACz*dx + ABz*ACx*dy - ABz*ACy*dx), 
          #  v: (-ABx*Ay*dz + ABx*Az*dy + ABx*Py*dz - ABx*Pz*dy + ABy*Ax*dz - ABy*Az*dx - ABy*Px*dz + ABy*Pz*dx - ABz*Ax*dy + ABz*Ay*dx + ABz*Px*dy - ABz*Py*dx)           /(ABx*ACy*dz - ABx*ACz*dy - ABy*ACx*dz + ABy*ACz*dx + ABz*ACx*dy - ABz*ACy*dx)}
          
          # divisor: (ABx*ACy*dz - ABx*ACz*dy - ABy*ACx*dz + ABy*ACz*dx + ABz*ACx*dy - ABz*ACy*dx)
          divisor = sympy.collect(ABx*ACy*dz - ABx*ACz*dy - ABy*ACx*dz + ABy*ACz*dx + ABz*ACx*dy - ABz*ACy*dx, (dx,dy,dz))
          # divisor = dx*(ABy*ACz - ABz*ACy) + dy*(-ABx*ACz + ABz*ACx) + dz*(ABx*ACy - ABy*ACx)
          
      end
end

end

nothing