import JSON, JSON3
using Test

function learn_JSON()
    s = "{\"a_number\" : 5.0, \"an_array\" : [\"string\", 9]}"
    j = JSON.parse(s)
    JSON.print(stdout, j, 4)
    # out = IOBuffer()
    # JSON.print(out, j)
    # @show String(take!(out))
    @show JSON.json(j)
end


learn_JSON()

nothing