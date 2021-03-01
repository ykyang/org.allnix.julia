using Logging
using Revise
# https://github.com/timholy/CodeTracking.jl
using CodeTracking
# see also Sugar.jl
# https://discourse.julialang.org/t/source-code-of-a-function/4499/4

"""
    call_1(func, x...)

Call the argument function.  This is for testing delaying calling a function.

...
# Arguments
- `func`: function
...
"""
function call_1(func, x...)
    @info "call_1" 
    func(x...)
end

"""
Use a Dict to pass array of functions to call later.

...
# Arguments
- `db`: Dict of functions
...
"""
function call_2(db, x...)
    @info "call_2"
    func = db["func_1"]
    func(x...)
end

function func_1()
    @info "func_1"
end

function func_2(a,b)
    # Does comment included in code_string?
    # Yes, it does.
    @info "func_2: $a, $b"
end

# call_1(func_1)
# call_1(func_2, 13, 17)

db = Dict()
db["func_1"] = func_1
call_2(db)
#db["func_1"]()

code = @code_string(func_2(1,2))
@info code
@which call_2(Dict())