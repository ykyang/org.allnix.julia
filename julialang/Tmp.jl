"""
Tmp

Example module from Julia workflow tip https://docs.julialang.org/en/v1/manual/workflow-tips/

Use this module by running Tst.jl
"""
module Tmp

export sayhello

function sayhello()
    println("Hello")
end
end
