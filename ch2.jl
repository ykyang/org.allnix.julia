y = 7
x = 4
text = typeof(y)
println(text)
z = 3x + y
println(z)
println(0 < x < 3) # false

# One line comment

#=
Mulitple line comment
=#

text = isa(x, Int64)
println(text)

# casting
text = trunc(Int64, 3.14159) # small case type name as a function
println(text)
text = trunc(Int64, -3.14159) # small case type name as a function
println(text)

# display an object
#display(z)


arr = [100,10,0]
println("typeof(arr): $(typeof(arr))")

arr3 = Float64[]
println("typeof(arr3): $(typeof(arr3))")

function f()
  # type can only be specified in function
  x::Int64 = 50
  println("typeof(x): $(typeof(x))")
  println("x = $x")

  s::String = "A string"
  println("typeof(s): $(typeof(s))")
end

f()
