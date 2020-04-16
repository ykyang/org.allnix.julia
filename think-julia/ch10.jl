# Chapter 10. Arrays
# https://benlauwens.github.io/ThinkJulia.jl/latest/book.html#chap10

# An Array is a Sequence
[10, 20, 30]
["crunchy frog", "ram bladder"]

# heterogeneous array
["spam", 2.0, 5, [10, 20]]

# [] empty array
typeof([])

cheeses = ["Cheddar", "Edam", "Gouda"];
numbers = [42, 123]
typeof(cheeses)

# Arrays Are Mutable
numbers[2] = 5
println(numbers)

# IN operator
"Edam" ∈ cheeses
"Brie" ∈ cheeses

# Traversing an Array
# https://benlauwens.github.io/ThinkJulia.jl/latest/book.html#_traversing_an_array
for cheese in cheeses
    println(cheese)
end

# with index
for i in eachindex(cheeses)
    println(cheeses[i])
end
