function insert_element(values)
  push!(values, -10)
end

list = [1,2,3]
insert_element(list)
println(list)

f(x,y) = x^3 + x*y - y
g(a, b = 5) = a + b
k(x; a1=1, a2=2) = x * (a1+a2)

println(f(3,2))

println("g(3) + f(1,2) = $( g(3) + f(1,2) )")
println("k(2) = $(k(2))")

cubes = map(x->x^3, [1,2,3,5])
println("$cubes")

println("$([1:3])")

a = split("A,B,C,D",",")
println("typeof(a): $(typeof(a))")
println("a: $(a)")

str::String = "This is a string"
println(str)
