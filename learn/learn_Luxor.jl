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

# @draw, @drawsvg
# Display in Code, Jupyter, Pluto


function learn_hello_world_4()
    plt = @png begin
        setopacity(0.85)
        steps = 20
        gap = 2
        for (n, θ) in enumerate(range(0, step=2π/steps, length=steps))
            sethue([Luxor.julia_green,
                Luxor.julia_red,
                Luxor.julia_purple,
                Luxor.julia_blue][mod1(n, 4)])
            sector(Point(0, 0), 50, 250 + 2n, θ, θ + 2π/steps - deg2rad(gap), :fill)
        end
    end

    return plt
end

#plt = learn_hello_world()
#plt = learn_hello_world_2()
#plt = learn_hello_world_3()
plt = learn_hello_world_4()

display(plt)

nothing