"""

Need to turn on compiled mode by `C` to run through DataFrames code.
Cannot use `u` when DataFrames is used in the code because it is super slow.
Use `bp add line` to set break point instead of `u line`.
"""
#
# Use ` to enter Julia mode to exame variables
# Use backspace to go back to debug mode
# 
using Debugger
db = Debugger

"""
    foo(n)

Dummy function for learning Debugger.
"""
function foo(n)
    x = n+1
    m = (BigInt[1 1; 1 0])^x
    Ans = m[2,1]
    #@bp
    # bp add 22
    return Ans
end

#db.@run foo(3)
#db.@enter foo(3)

nothing