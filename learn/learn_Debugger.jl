using Debugger
db = Debugger

function foo(n)
    x = n+1
    m = (BigInt[1 1; 1 0])^x
    Ans = m[2,1]
    @bp
    return Ans
end

db.@enter foo(3)
