using ThinkJulia


# Exercise 4-1
🐢 = Turtle() # \:turtle:
T = 🐢
# @svg begin
#     forward(T, 100)
#     turn(T, -90)
#     forward(T, 100)
#     turn(T, -90)
#     forward(T, 100)
#     turn(T, -90)
#     forward(T, 100)
# end





# Exercise 4-2, 4-4
function square(t, len = 100)
    for i in 1:4
        forward(t, len)
        turn(t, -90)
    end
end

# Exercise 4-5
function polygon(t, n, len = 100)
    degree = 360/n;
    for i in 1:n
        forward(t, len)
        turn(t, -degree)
    end
end

# Exercise 4-6
function circle(t, r)
    # Approximate by polygon of n-sides
    # circumference = n * len = pi * 2r, better one with tan?
    # len = pi*2r/n
    # len
    #
    # Could be better.

    n = 100 # sides of polygon
    circumference = pi * 2r
    len = circumference / n
    degree = 360/n

    polygon(t, n, len)
end

# Exercise 4-7
function arc(t, r, angle)
    n = 100 # sides of polygon
    circumference = pi * 2r * angle/360
    len = circumference / n
    degree = angle/n

    #polygon(t, n, len)
    for i in 1:n
        forward(t, len)
        turn(t, -degree)
    end
end

@svg begin
    # Exercise 4-1
    # for i in 1:4
    #     forward(T, 100)
    #     turn(T, -90)
    # end

    # Exercise 4-3
    square(T)

    # Exercise 4-4
    square(T, 10)

    # Exercise 4-5
    polygon(T, 7, 80)

    # Exercise 4-6
    circle(T, 30)

    # Exercise 4-7
    arc(T, 120, 270)
end

# TODO
# Exercise 4-8
# Exercise 4-12

println("DONE")
