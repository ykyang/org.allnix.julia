module ch12
using Printf
# ------
# Tuples
# https://benlauwens.github.io/ThinkJulia.jl/latest/book.html#chap12
# ------

# --------------------
# Tuples Are Immutable
# https://benlauwens.github.io/ThinkJulia.jl/latest/book.html#_tuples_are_immutable
# --------------------
x = ('a', 'b')
typeof(x)

# single element tuple
x = ('a')
typeof(x) # Char
x = ('a', )
typeof(x) # Tuple{Char}

# tuple()
x = tuple(1, 'a', pi)
x[2]
x[2:3]

# compare
y = tuple(1, 'a', pi)

x == y
x > y

# ----------------
# Tuple Assignment
# ----------------
a, b = 1, 2, 3

a = 5
b = 7
a, b = b, a

# split
addr = "julius.caesar@rome"
uname, domain = split(addr, '@')

# -----------------------
# Tuples as Return Values
# -----------------------
x = divrem(7, 3)
q,r = divrem(7,3)
# -------------------------------
# Variable-length Argument Tuples
# -------------------------------

# gather (slurp)
function printall(args...)
    println(args)
end
printall(1, 2, '3')

# scatter (splat)
x = (7,3)
# divrem(x) error
divrem(x...)

# Exercise 12-1
function sumall(args...)
    sum = 0
    for value in args
        sum += value
    end

    return sum
end

sumall(1,2,3)

# -----------------
# Arrays and Tuples
# -----------------
str = "abc"
x = [1, 2, 3]
# zip
z = zip(str, x)
for p in z
    println(p)
end
#println(collect(z)) # [('a', 1), ('b', 2), ('c', 3)]

for (char, num) in z
    @printf("%g %s\n", num, char)
end

# enumerate
for (ind, char) in enumerate("abc")
    #println(typeof(ind))
    #println(typeof(char))
    @printf("%i %s\n", ind, char)
end

# -----------------------
# Dictionaries and Tuples
# -----------------------
dict = Dict('a'=>1, 'b'=>2, 'c'=>3)
for (key,value) in dict
    @printf("%s %i\n", key, value)
end

z = zip(str, x)
dict = Dict(z)
for (key,value) in dict
    @printf("%s %i\n", key, value)
end

dict = Dict()
dict['a', 1] = 3
dict['b', 1] = 4
for ((well, stage), num) in dict
    @printf("%s,%i: %i\n", well, stage, num)
end

# ----------------------
# Sequences of Sequences
# ----------------------
println(sort([13, 7, 5]))
println(reverse([13, 7, 5]))
end
