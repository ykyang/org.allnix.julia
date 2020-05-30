for x=10:10:20, y=1:2
    # y rotates than x
    println(x+y)

end

# List comprehension
[println(i) for i in collect(1:5)]
# x rotates then y
[println(x+y) for x in [10, 20], y in [1,2]]
