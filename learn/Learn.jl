"""
Utility and convenience stuff
"""
module Learn

"""
    @log msg

Construct a `String` with `string(s1, s2, \$msg)`.
If variable `indent` is defined then `s1 = indent` otherwise
`s1 = ""`.  If variable `tab` is defined then `s2 = tab` otherwise
`s2 = ""`.
"""
macro log(msg)
    esc(quote
        local s1 = (@isdefined indent) && isa(indent,AbstractString) ? indent : ""
        local s2 = (@isdefined tab)    && isa(tab,AbstractString)    ? tab    : ""
        string(s1, s2, $msg)
    end)
end

"""
    @log n msg

Construct a `String` with `string(s1, s2^\$n, \$msg)`.
If variable `indent` is defined then `s1 = indent` otherwise
`s1 = ""`.  If variable `tab` is defined then `s2 = tab` otherwise
`s2 = ""`.

This is used for constructing indented log message.
"""
macro log(n, msg)
    esc(quote
        local s1 = (@isdefined indent) && isa(indent,AbstractString) ? indent : ""
        local s2 = (@isdefined tab)    && isa(tab,AbstractString)    ? tab    : ""
        string(s1, s2^$n, $msg)
    end)
end
macro log(tab, n, msg)
    esc(quote
        local s1 = (@isdefined indent) && isa(indent,AbstractString) ? indent : ""
        string(s1, $tab^$n, $msg)
    end)
end

"""
    showrepl(x;io=stdout)

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

export @log, showrepl
end