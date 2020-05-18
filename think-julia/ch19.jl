# Named Tuples
# https://benlauwens.github.io/ThinkJulia.jl/latest/book.html#_named_tuples
x = (a = 1, b = 2)
x.a
x.b

# Functions: Compact form
f(x, y) = x + y
f(3,2)

# Anonymous Functions
x -> x^2 + 2x + 1

# Keyword Arguments
function myplot(x, y; style = "solid", width = 10)
    println("style: $style")
    println("width: $width")

    nothing
end

myplot(10, 3, style = "dash", width = 13)

# Closures
# Function uses variable defined outside of calling scope
foo(x) = () -> x^2
bar = foo(2) # closure
bar() # 4

# -------
# Blocks
# -------
begin
    bar = foo(3)
    bar()
end

# let Blocks
x, y, z = 1, 2, 3
let x = 1, z
    @show x y z
end
@show x y z

# do Blocks
# Auto close files

# Style 1
open("testfile.txt", "w") do io
    println(io, "Hello World!")
end

# Style 2
open(io->read(io, String), "testfile.txt")

# -----------------
# Control Flow: Ternary Operator
# -----------------

# -------------------
# Control Flow: Coroutines or Task
# -------------------
function generator(ch::Channel)
    while true
        put!(ch, rand(Float64))
    end
end

randgen = Channel(generator)
take!(randgen)
take!(randgen)

# ------
# Types
# ------

# Parametric Types
struct Point{T<:Real}
    x::T
    y::T
end

pt = Point(0.0, 0.0)
pt = Point(1,2)

# --------
# Methods
# --------
# Parametric Methods
# Short form: isintpoint(pt::Point{T}) where {T} = (T === Int64)
function isintpoint(pt::Point{T}) where {T}
    (T === Int64)
end

isintpoint(pt)
