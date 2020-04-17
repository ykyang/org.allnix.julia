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

# Array Slices
t = ['a', 'b', 'c', 'd', 'e', 'f']
print(t[1:3])
print(t[3:end])

t[2:3] = ['x', 'y']
println(t)

# Array Library

# push!
t = ['a', 'b', 'c']
push!(t, 'd')
println(t)

# append!
t1 = ['a', 'b', 'c']
t2 = ['d', 'e']
append!(t1, t2)
println(t1)

# sort! & sort
t = ['d', 'c', 'e', 'b', 'a']
tsorted = sort(t)
println(t)       # ['d', 'c', 'e', 'b', 'a']
println(tsorted) # ['a', 'b', 'c', 'd', 'e']

sort!(t)
println(t) # ['a', 'b', 'c', 'd', 'e']

# Map, Filter and Reduce

# Reduce: An operation like this that combines a sequence of elements into
#         a single value is sometimes called a reduce operation.

# Instead of doing this
function addall(t)
    sum = 0
    for v in t
        sum += v
    end
    return sum
end
addall(1:0.5:3)

# sum(itr)
sum(1:0.5:3)

# Map: “maps” a function (in this case uppercase) onto each of the elements in a sequence.
"""
    capitalizeall(itr)

Capitalize each element of itr.
"""
function capitalizeall(itr) # ::1-D array
    res = []
    for v in itr
        push!(res, uppercase(v))
    end

    return res
end
capitalizeall(['a', 'b'])

# Filter: Selects some of the elements and filters out the others.
"""
    onlyupper(itr)

Returns only upper case elements of itr
"""
function onlyupper(itr)
    ret = []
    for v in itr
        if v == uppercase(v)
            push!(ret, v)
        end
    end

    return ret
end
line = onlyupper(['a', 'B', 'C'])
println(line) # Any['B', 'C']

# Dot Syntax

# use on operator
t = [1, 2, 3]
println(t.^2) # [1, 4, 9]

# use on function
t = uppercase.(["abc", "def", "ghi"])
println(t) # ["ABC", "DEF", "GHI"]

# Deleting (Inserting) Elements

# splice!
t = ['a', 'b', 'c']
splice!(t, 2)
println(t) # ['a', 'c']

# pop!
t = ['a', 'b', 'c']
pop!(t)
println(t) # ['a', 'b']

# popfirst!
t = ['a', 'b', 'c']
popfirst!(t)
println(t) # ['b', 'c']

# push!
# pushfirst!
# deleteat!
# insert!
