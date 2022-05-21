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

# macro replshow(x)
#     return :( 
#         show(stdout, "text/plain", repr(begin local value = $(esc(x)) end));
#         println(stdout);
#     )
# end

export showrepl, @replshow
end