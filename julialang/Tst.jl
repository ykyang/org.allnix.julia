"""
Tst

Runner for Tmp.jl

Learn the workflow tip from julialang https://docs.julialang.org/en/v1/manual/workflow-tips/

Run in REPL by
    include("Tst.jl")

Run in Juno by Ctrl-Shift-Enter
Debug in Juno by Juno -> Debug: Run File

"""
module Tst
include("Tmp.jl")
import .Tmp

Tmp.sayhello()
end
