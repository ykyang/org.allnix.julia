# parse
a0 = parse(Int, "32")
println(typeof(a0))

# trunc
a1 = trunc(Int64, 3.444)
a2 = trunc(Int64, 3.999)
println(typeof(a1))

b1 = floor(Int64, 3.444)
b2 = floor(Int64, 3.999)

c1 = round(Int64, 3.444)
c2 = round(Int64, 3.999)

d1 = ceil(Int64, 3.444)
d2 = ceil(Int64, 3.444)

# Math Functions
e = log10(100)
println(log10(100))
e2 = log(2.718281828459045)

f1 = sind(90)
f2 = sin(pi/2)
