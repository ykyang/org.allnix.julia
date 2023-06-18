module LearnGeometryForProgrammer

using Logging
using PythonCall
using Symbolics
using LinearAlgebra
using Test

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
      Line
          R = P + t d, t >= 0

      Triangle
          S = A + uAB + vAC
          u ≥ 0, v ≥ 0, u + v ≤ 1
      
      Intersection
                R = S
          P + t d = A + uAB + vAC

      Scalar form in 3D
      Px + tdx = Ax + ABxu + ACxv
      Py + tdy = Ay + AByu + ACyv
      Pz + tdz = Az + ABzu + ACzv
3.8.3 Making the equations into code
"""
function learn_3_8_3_py()
    sympy = pyimport("sympy")
    @info "Listing 3.1 Solving the ray-triangle intersection symbolically"
    indent = "    "
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
        #@info "$(indent)$(solution)"
        @info "$(indent)t = $(solution[t])"
        @info "$(indent)u = $(solution[u])"
        @info "$(indent)v = $(solution[v])"
        # {t: (ABx*ACy*Az - ABx*ACy*Pz - ABx*ACz*Ay + ABx*ACz*Py - ABy*ACx*Az + ABy*ACx*Pz + ABy*ACz*Ax - ABy*ACz*Px + ABz*ACx*Ay - ABz*ACx*Py - ABz*ACy*Ax + ABz*ACy*Px)/(ABx*ACy*dz - ABx*ACz*dy - ABy*ACx*dz + ABy*ACz*dx + ABz*ACx*dy - ABz*ACy*dx), 
        #  u: (ACx*Ay*dz - ACx*Az*dy - ACx*Py*dz + ACx*Pz*dy - ACy*Ax*dz + ACy*Az*dx + ACy*Px*dz - ACy*Pz*dx + ACz*Ax*dy - ACz*Ay*dx - ACz*Px*dy + ACz*Py*dx)            /(ABx*ACy*dz - ABx*ACz*dy - ABy*ACx*dz + ABy*ACz*dx + ABz*ACx*dy - ABz*ACy*dx), 
        #  v: (-ABx*Ay*dz + ABx*Az*dy + ABx*Py*dz - ABx*Pz*dy + ABy*Ax*dz - ABy*Az*dx - ABy*Px*dz + ABy*Pz*dx - ABz*Ax*dy + ABz*Ay*dx + ABz*Px*dy - ABz*Py*dx)           /(ABx*ACy*dz - ABx*ACz*dy - ABy*ACx*dz + ABy*ACz*dx + ABz*ACx*dy - ABz*ACy*dx)}
          
        @info "Collect (simplify) terms"
        @info "$(indent)Simplify divisor"
        divisor = let 
            divisor = (ABx*ACy*dz - ABx*ACz*dy - ABy*ACx*dz + ABy*ACz*dx + ABz*ACx*dy - ABz*ACy*dx)
            @info "$(indent)divisor = $(divisor)"
            divisor = sympy.collect(divisor, (dx,dy,dz))
            @info "$(indent)divisor = $divisor" # [ Info: divisor = dx*(ABy*ACz - ABz*ACy) + dy*(-ABx*ACz + ABz*ACx) + dz*(ABx*ACy - ABy*ACx)
            divisor
        end

        @info "$(indent)Simplify t"
        t = let numerator = (ABx*ACy*Az - ABx*ACy*Pz - ABx*ACz*Ay + ABx*ACz*Py - ABy*ACx*Az + ABy*ACx*Pz + ABy*ACz*Ax - ABy*ACz*Px + ABz*ACx*Ay - ABz*ACx*Py - ABz*ACy*Ax + ABz*ACy*Px)
          denominator = divisor
          @info "$(indent^2)numerator = $numerator"
          numerator = sympy.collect(numerator, (ACx, ACy, ACz))
          @info "$(indent^2)numerator = $numerator"

          numerator/denominator
        end
        @info "$(indent)Simplify u"
        u = let numerator = (ACx*Ay*dz - ACx*Az*dy - ACx*Py*dz + ACx*Pz*dy - ACy*Ax*dz + ACy*Az*dx + ACy*Px*dz - ACy*Pz*dx + ACz*Ax*dy - ACz*Ay*dx - ACz*Px*dy + ACz*Py*dx)
            denominator = divisor
            @info "$(indent^2)numerator = $numerator"
            numerator = sympy.collect(numerator, (dx, dy, dz))
            @info "$(indent^2)numerator = $numerator"

            numerator/denominator
        end
        @info "$(indent)Simplify v"
        v = let numerator = (-ABx*Ay*dz + ABx*Az*dy + ABx*Py*dz - ABx*Pz*dy + ABy*Ax*dz - ABy*Az*dx - ABy*Px*dz + ABy*Pz*dx - ABz*Ax*dy + ABz*Ay*dx + ABz*Px*dy - ABz*Py*dx)
            denominator = divisor
            @info "$(indent^2)numerator = $numerator"
            numerator = sympy.collect(numerator, (dx, dy, dz))
            @info "$(indent^2)numerator = $numerator"

            numerator/denominator
        end

        ## Check intersection with
        ## if div == 0.:
        ##     return False
        ## if t >= 0. and u >= 0. and v >= 0. and (u+v) <= 1.:
        ##   return True
        ## return False
          
        nothing
    end
end
"""
4.    Projective geometric transformations
4.1   Some special cases of geometric transformations
      fi: R -> R, for i in 1:n
4.1.1 Translation
      xt = xi + sin(t)
      yt = yi + cos(t)
      Parametric transformation
4.1.2 Scaling
      xs = axi
      ys = byi
      Transformation composition
      the order of operations matters
4.1.3 Rotation
      xr =  cos(t) xi + sin(t) yi
      yr = -sin(t) xi + cos(t) yi
4.2   Generalizations
4.2.1 Linear transformations in Euclidean space
      xt = a11xi + a12yi
      yt = a21xi + a22yi
      Two-point transformation
      TODO Listing 4.1
4.2.2 Bundling rotation, scaling, and translation in a single affine transformation
      xt = a11xi + a12yi + a13
      yt = a21xi + a22yi + a23
      TODO Listing 4.2
4.2.3 Generalizing affine transformations to projective transformations
      To transform (x,y) to (xp,yp)
      xp = (a*x + b*y + c)/(g*x + h*y + i)
      yp = (d*x + e*y + f)/(g*x + h*y + i)
4.2.4 An alternative to projective transformations
      Bilinear transformation
4.3   Projective space and homogeneous coordinates
4.3.1 Expanding the whole space with homogeneous coordinates
      IMPORTANT
      x = xp/wp
      y = yp/wp
      xp = wp * x
      yp = wp * y
      wp = wp
4.3.2 Making all the transformations a single matrix multiplication: Why?
      xp = (axi + byi + cwi)/(gxi + hyi + iwi)
      yp = (dxi + eyi + fwi)/(gxi + hyi + iwi)
      wp = 1

      if 0 ≠ (gxi+hyi+iwi), multiply (gxi + hyi + iwi) to equations above
      xp = axi + byi + cwi
      yp = dxi + eyi + fwi
      wp = gxi + hyi + iwi

      In projective coordinate, (xp,yp,wp), 2(xp,yp,wp) are the same point
      in Euclidean coordinate.
      
      xp   a b c   xi
      yp = d e f * yi
      wp   g h i   wi

      translation matrix
      1 0 dx
      0 1 dy
      0 0 1
      rotation matrix
       cos(r) sin(r)      0
      -sin(r) cor(r)      0
            0      0      1
      scaling matrix
      sx  0  0
       0 sy  0
       0  0  1



      Composition
      Parallelization
          Associativity
      An idle transformation
          Identity matrix, E
      A transformation that puts things back as they were
          TODO: code
"""
function learn_4_3_2() # Julia version
    a1 = [1 0 -1;  0 1 -1; 0 0 1;]
    a2 = [0 1  0; -1 0  0; 0 0 1;]
    a3 = [1 0  1;  0 1  1; 0 0 1;]

                          #       0  1  0
    c = a3 * a2 * a1      # c =  -1  0  2
                          #       0  0  1
    @test c ==  [0 1 0; -1 0 2; 0 0 1]

    p1 = [0.75, 0.5, 1]; @test size(p1) == (3,)
    p2 = [1.25, 0.5, 1]
    p3 = [1.25, 1.5, 1]
    p4 = [0.75, 1.5, 1]
    pt1 = c * p1; @test pt1 == [0.50, 1.25, 1.00]
    pt2 = c * p2; @test pt2 == [0.50, 0.75, 1.00]
    pt3 = c * p3; @test pt3 == [1.50, 0.75, 1.00]
    pt4 = c * p4; @test pt4 == [1.50, 1.25, 1.00]


                     #         0 -1  2
    c_inv = inv(c)   # c_inv = 1  0  0
                     #         0  0  1
    @test c_inv == [0 -1 2; 1 0 0; 0 0 1]
    @test p1 == c_inv * pt1
    @test p2 == c_inv * pt2
    @test p3 == c_inv * pt3
    @test p4 == c_inv * pt4
    
    ## Use cofactor instead of inverse
    @test transpose(cofactor(c)) * pt1 == [0.75, 0.5, 1] # p1
    @test transpose(cofactor(c)) * pt2 == [1.25, 0.5, 1] # p2
    @test transpose(cofactor(c)) * pt3 == [1.25, 1.5, 1] # p3
    @test transpose(cofactor(c)) * pt4 == [0.75, 1.5, 1] # p4

end
function minor(M, i, j)
    return M[1:end .!= i,1:end .!= j]
end
function test_minor()
                              # 1 2 3
    A = [1 2 3; 4 5 6; 7 8 9] # 4 5 6
                              # 7 8 9
    @test minor(A,1,1) == [5 6; 8 9]
    @test minor(A,2,2) == [1 3; 7 9]
    @test minor(A,3,3) == [1 2; 4 5]
    @test minor(A,2,3) == [1 2; 7 8]

end
function cofactor(M)
    ## https://byjus.com/cofactor-formula/
    C = fill(0.0, size(M)) #similar(M)
    for i in 1:size(M,1), j in 1:size(M,2)
      C[i,j] = (-1)^(i+j) * det(minor(M,i,j))
    end

    return C
end
function test_cofactor()
                              # 1 2 3
    A = [1 2 3; 4 5 6; 7 8 9] # 4 5 6
                              # 7 8 9
    C = cofactor(A)
    #@show C
    @test C[1,1] == 45 - 48
    @test C[2,1] == -(18 - 24)
    @test C[2,3] == -(8 - 14)
    @test C ==  [-3.0 6.0000000000000036 -3.0000000000000018; 6.0 -12.0 6.0; -2.9999999999999982 6.0 -3.0]
    @test round.(C, digits=1) ==  [-3.0    6.0  -3.0;
                                    6.0  -12.0   6.0;
                                   -3.0    6.0  -3.0]
    
end
function learn_4_3_2_sympy()
    NS = @__MODULE__
    pyexec("""
    import sympy as sp
    a1 = sp.Matrix([[1, 0, -1], [ 0, 1, -1], [0, 0, 1]])
    a2 = sp.Matrix([[0, 1,  0], [-1, 0,  0], [0, 0, 1]])
    a3 = sp.Matrix([[1, 0,  1], [ 0, 1,  1], [0, 0, 1]])
    c = a3 * a2 * a1
    print('c = ', c) # Matrix([[0, 1, 0], [-1, 0, 2], [0, 0, 1]])
    #  0, 1, 0
    # -1, 0, 2
    #  0, 0, 1
    
    p1 = sp.Matrix([0.75, 0.5, 1])
    p2 = sp.Matrix([1.25, 0.5, 1])
    p3 = sp.Matrix([1.25, 1.5, 1])
    p4 = sp.Matrix([0.75, 1.5, 1])
    print('p1 = ', p1)
    print('p2 = ', p2)
    print('p3 = ', p3)
    print('p4 = ', p4)
    print()
    pt1 = c * p1 # Matrix([[0.500000000000000], [1.25000000000000],  [1]])
    pt2 = c * p2 # Matrix([[0.500000000000000], [0.750000000000000], [1]])
    pt3 = c * p3 # Matrix([[1.50000000000000],  [0.750000000000000], [1]])
    pt4 = c * p4 # Matrix([[1.50000000000000],  [1.25000000000000],  [1]])
    print('pt1 = ', pt1)
    print('pt2 = ', pt2)
    print('pt3 = ', pt3)
    print('pt4 = ', pt4)
    print()
    c_inv = c.inv()
    print('c_inv = ', c_inv) # Matrix([[0, -1, 2], [1, 0, 0], [0, 0, 1]])
    print()
    # 0, -1, 2
    # 1,  0, 0
    # 0,  0, 1
    print('p1 = c_inv*pt1 = ', c_inv*pt1) # p1 = c_inv*pt1 =  Matrix([[0.750000000000000], [0.500000000000000], [1]])
    print('p2 = c_inv*pt2 = ', c_inv*pt2) # p2 = c_inv*pt2 =  Matrix([[1.25000000000000], [0.500000000000000], [1]])
    print('p3 = c_inv*pt3 = ', c_inv*pt3) # p3 = c_inv*pt3 =  Matrix([[1.25000000000000], [1.50000000000000], [1]])
    print('p4 = c_inv*pt4 = ', c_inv*pt4) # p4 = c_inv*pt4 =  Matrix([[0.750000000000000], [1.50000000000000], [1]])
    """, NS)
    
    
    pyexec("""
    def minor(M, i, j):
        m = M[:,:]
        m.col_del(j)
        m.row_del(i)
        return m
    """, NS)
    
    pyexec("""
    print(minor(c, 1, 1)) # Matrix([[0, 0], [0, 1]])
    """, NS)

    pyexec("""
    def cofactor(M):
        C = M[:,:]
        for i in range(M.shape[0]):
            for j in range(M.shape[1]):
                determinant = minor(M,i,j).det()
                sign = 1 if (i+j)%2 == 0 else -1
                C[i,j] = sign*determinant
        return C
    """, NS)

    pyexec("""
    print('cofactor(c).T * pt1 = ', cofactor(c).T * pt1) # cofactor(c).T * pt1 =  Matrix([[-0.750000000000000], [-0.500000000000000], [-1]])
    print('cofactor(c).T * pt2 = ', cofactor(c).T * pt2) # cofactor(c).T * pt2 =  Matrix([[-1.25000000000000], [-0.500000000000000], [-1]])
    print('cofactor(c).T * pt3 = ', cofactor(c).T * pt3) # cofactor(c).T * pt3 =  Matrix([[-1.25000000000000], [-1.50000000000000], [-1]])
    print('cofactor(c).T * pt4 = ', cofactor(c).T * pt4) # cofactor(c).T * pt4 =  Matrix([[-0.750000000000000], [-1.50000000000000], [-1]])
    """, NS)
end
function learn_4_3_2_numpy() # TODO
      @pyexec """
      import numpy as np
      a1 = np.array([[1, 0, -1], [ 0, 1, -1], [0, 0, 1]])
      a2 = np.array([[0, 1,  0], [-1, 0,  0], [0, 0, 1]])
      a3 = np.array([[1, 0,  1], [ 0, 1,  1], [0, 0, 1]])

      c = a3 @ a2 @ a1
      # print(c)
      # [[ 0  1  0]
      #  [-1  0  2]
      #  [ 0  0  1]]

      p1 = np.array([0.75, 0.5, 1])
      p2 = np.array([1.25, 0.5, 1])
      p3 = np.array([1.25, 1.5, 1])
      p4 = np.array([0.75, 1.5, 1])

      print(c @ p1) # [0.5  1.25 1.  ]
      print(c @ p2) # [0.5  0.75 1.  ]
      print(c @ p3) # [1.5  0.75 1.  ]
      print(c @ p4) # [1.5  1.25 1.  ]

      """
end
"""
4.4   Practical examples
4.4.1 Scanning with a phone
      [
      xt1 * x1 * g + xt1 * y1 * h + xt1 * i - x1 * a - y1 * b - c,
      yt1 * x1 * g + yt1 * y1 * h + yt1 * i - x1 * d - y1 * e - f,
      xt2 * x2 * g + xt2 * y2 * h + xt2 * i - x2 * a - y2 * b - c,
      yt2 * x2 * g + yt2 * y2 * h + yt2 * i - x2 * d - y2 * e - f,
      xt3 * x3 * g + xt3 * y3 * h + xt3 * i - x3 * a - y3 * b - c,
      yt3 * x3 * g + yt3 * y3 * h + yt3 * i - x3 * d - y3 * e - f,
      xt4 * x4 * g + xt4 * y4 * h + xt4 * i - x4 * a - y4 * b - c,
      yt4 * x4 * g + yt4 * y4 * h + yt4 * i - x4 * d - y4 * e - f,
      i - 1
      ], (a, b, c, d, e, f, g, h, i))
      
      TODO: use sympy to simplify above equations

      [
      xt1 * i - c,
      yt1 * i - f,
      xt2 * g + xt2 * i - a - c,
      yt2 * g + yt2 * i - d - f,
      xt3 * g + xt3 * h + xt3 * i - a - b - c,
      yt3 * g + yt3 * h + yt3 * i - d - e - f,
      xt4 * h + xt4 * i - b - c,
      yt4 * h + yt4 * i - e - f,
      i - 1
      ], (a, b, c, d, e, f, g, h, i))
4.4.2 Does a point belong to a triangle?

"""

end
