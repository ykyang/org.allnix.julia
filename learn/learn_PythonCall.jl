module LearnPythonCall

## Do not use matplotlib directly.  Use it through PythonPlot

using PythonCall
using Test

## https://cjdoris.github.io/PythonCall.jl/stable/pythoncall-reference/

function learn_numpy()
    # TODO: Learn more
    np = pyimport("numpy")
    @pyexec """
    import numpy as np
    a = np.array([[1, 2], [3, 4]], order='F')
    #print(a[1,0])
    """ => a
    @test pyconvert(Float64,a[1,0]) == 3
    @pyexec a => "b = a[:,0]" => b # [1,3]
    @test pyconvert(Bool, np.array_equal(b, np.array([1,3])))
    
    nothing
end
function learn_pyeval()
    ## https://discourse.julialang.org/t/define-python-function-in-julia-file-with-pythoncall/98593/6
    ## https://cjdoris.github.io/PythonCall.jl/stable/pythoncall-reference/#PythonCall.@pyexec 
    ## @pyexec [inputs =>] code [=> outputs]

    ## @pyeval [inputs =>] code [=> T]
    Ans = @pyeval (x=1.1, y=2.2) => `x+y` => Float64; @test Ans == 1.1 + 2.2
    ## pyeval([T=Py], code, globals, locals=nothing)
    Ans = pyeval(Float64, "x+y", LearnPythonCall, (x=1.1, y=2.2)); @test Ans == 1.1 + 2.2 
end
function learn_pyexec()
    ## @pyexec [inputs =>] code [=> outputs]
    @pyexec (x=1.1, y=2.2) => `Ans=x+y` => Ans::Float64; ; @test Ans == 1.1 + 2.2
    ## pyexec([T=Nothing], code, globals, locals=nothing)
    Ans, = pyexec(@NamedTuple{ans::Float64}, "ans=x+y", LearnPythonCall, (x=1.1,y=2.2)); @test Ans == 1.1 + 2.2
end
function learn_def_function()
    ## Define function in local scope, and make it available in Julia
    @pyexec """
    def fib(n):
        a, b = 0, 1
        while a < n:
            #print(a, end=' ')
            a, b = b, a+b
        #print()
        return a,b
    """ => fib
    Ans = fib(4) # (5,8) Python object
    ## Test in Julia
    @test pyconvert(Bool, fib(4) == pytuple((5,8)))   # compare then convert
    @test pyconvert(Tuple{Int64,Int64}, Ans) == (5,8) # convert then compare
    ## Test in Python
    @pyexec fib => """assert fib(4) == (5,8), "Should be (5,8)" """

    ## Define functions across multiple pyexec
    pyexec("""
    def fn1():
        #print('fn1()')
        pass
    """, LearnPythonCall)
    ## Test if fn2 see fn1
    pyexec("""
    def fn2():
        fn1()
    """, LearnPythonCall)
    
    pyexec("fn2()", LearnPythonCall)
    @test_throws PyException pyexec("fn2()", Main)
    @pyexec "fn2()" # no need for module name?
end

function learn_pytype()
    re = pyimport("re")
    @show re
    @show typeof(re)
    @show pytype(re)
end
end