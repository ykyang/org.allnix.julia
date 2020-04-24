# Workflow tip from julialang 
# https://docs.julialang.org/en/v1/manual/workflow-tips/
module Tst
include("Tmp.jl")
import .Tmp

Tmp.sayhello()
end
