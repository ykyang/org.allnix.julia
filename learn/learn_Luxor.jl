using Luxor

# http://juliagraphics.github.io/Luxor.jl/stable/examples/#The-obligatory-%22Hello-World%22
function learn_hello_world()
    Drawing(1000, 1000, "hello-world.png")
    origin()
    background("black")
    sethue("red")
    fontsize(50)
    text("hello world")
    finish()
    preview()
end

# circle with hello
function learn_hello_world_2()
    plt = @png begin
        fontsize(50)
        circle(Point(0,0), 150, :stroke)
        text("hello world", halign=:center, valign=:middle)
    end
    
    return plt
end

# The arrow thing
function learn_hello_world_3()
    plt = @svg begin
        sethue("red")
        randpoint = Point(rand(-200:200), rand(-200:200))
        circle(randpoint, 2, :fill)
        sethue("black")
        foreach(
            f -> arrow(f, between(f, randpoint, 0.1), arrowheadlength=6),
            first.(collect(Table(fill(20, 15), fill(20, 15))))
        )
    end

    return plt
end

#plt = learn_hello_world()
#plt = learn_hello_world_2()
plt = learn_hello_world_3()

display(plt)

nothing