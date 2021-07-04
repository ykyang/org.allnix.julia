using Luxor, IterTools
using Colors

## http://juliagraphics.github.io/Luxor.jl/stable/examples/#The-obligatory-%22Hello-World%22
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
function learn_hello_circle()
    plt = @png begin
        fontsize(50)
        Luxor.circle(Point(0,0), 150, :stroke)
        text("hello world", halign=:center, valign=:middle)
    end
    
    return plt
end

# The arrow thing
function learn_hello_arrow()
    plt = @svg begin
        sethue("red")
        randpoint = Point(rand(-200:200), rand(-200:200))
        Luxor.circle(randpoint, 2, :fill)
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


function learn_hello_julia_sector()
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

function learn_hello_pluto()
    S = 15
    plt = @svg begin
        background("slateblue4")
        # Notice O = Point(0,0)

        points = between.(O + (0,S), O - (0,S), range(0,1,length=3)) # broadcast
        hues = [Luxor.julia_red, Luxor.julia_purple, Luxor.julia_green]
        # `enumerate` can be replaced with `pairs`
        for (i, point) in enumerate(points)
            sethue(hues[i])
            Luxor.circle(point, S, :fill)
        end
    end 100 100

    return plt
end

function learn_hello_julia_logos()
    plt = @svg begin
        origin()
        background("white")

        for theta in range(0, step=pi/8, length=16)
            gsave()
            scale(0.2)
            rotate(theta)
            translate(350,0)
            julialogo(action = :fill, bodycolor = randomhue())
            grestore()
        end

        gsave()
        scale(0.3)
        juliacircles()
        grestore()

        translate(150,-150)
        scale(0.3)
        julialogo()
        
    end 600 400

    return plt
end

function triangle(points, degree, color)
    sethue(color)
    poly(points, :fill)
end

function sierpinski(points, degree, colors)
    triangle(points, degree, colors[degree])
    if degree > 1
        p1, p2, p3 = points
        sierpinski(
            [p1, midpoint(p1,p2), midpoint(p1,p3)], 
            degree - 1,
            colors
        )
        sierpinski(
            [p2, midpoint(p1,p2), midpoint(p2,p3)],
            degree - 1,
            colors
        )
        sierpinski(
            [p3, midpoint(p3,p2), midpoint(p1,p3)],
            degree - 1,
            colors
        )

    end
end

function learn_hello_sierpinski_triangle()
    depth = 5
    colors = distinguishable_colors(depth)

    plt = @svg begin
        background("white")
        origin()

        Luxor.circle(Point(0,0), 75, :clip)
        points = ngon(Point(0,0), 150, 3, -pi/2, vertices=true)
        sierpinski(points, depth, colors)
        
    end

    return plt
end

function learn_hello_jupyter(r, m)
    plt = @svg begin
        origin()
        background("white")
        setcolor"antiquewhite"

        squircle(O, 124, 124, :fill)
        squircle(O, 124, 124, :stroke)
        ls = range(1, stop=120, length=18)
        @show ls
        setline(0.5)
        for (n,pt) in enumerate(ngon(O,100,3,vertices=true))
            @layer begin
                rotate(pi/6 + n * 2/3*pi)
                c = m
                for (s,e) in partition(ls, 2, 1)
                    @show (s,e)
                    sethue([Luxor.darker_red, Luxor.darker_green, Luxor.darker_purple][n])
                    sector(O, s, e, -pi/8 + r/10, pi * c, 15, :fill)
                    setcolor"white"
                    sector(O, s, e, -pi/8 + r/10, pi * c, 15, :stroke)
                    c *= m
                end
            end
        end
    end 300 300

    return plt
end

## http://juliagraphics.github.io/Luxor.jl/stable/tutorial/
function learn_tutorial_first_steps()
    @svg begin
        text("Hello world")
        circle(O, 200, :stroke)
    end
end



# plt = learn_hello_world();               display(plt);
# plt = learn_hello_circle();              display(plt);
# plt = learn_hello_arrow();               display(plt); 
# plt = learn_hello_julia_sector();        display(plt);
# plt = learn_hello_pluto();               display(plt);
# plt = learn_hello_julia_logos();         display(plt);
# plt = learn_hello_sierpinski_triangle(); display(plt);
# plt = learn_hello_jupyter(2, 0.95);      display(plt);
# TODO: Not finished yet
plt = learn_tutorial_first_steps(); display(plt);


nothing