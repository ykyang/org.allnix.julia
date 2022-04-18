"""
Utility and convenience stuff
"""
module Learn
"""

Print in REPL style format.
"""
function showrepl(x;io=stdout)
    # https://discourse.julialang.org/t/how-to-get-a-function-to-print-stuff-with-repl-like-formatting/45877/4
    show(io,"text/plain",x)
    println(io)
end

export showrepl
end