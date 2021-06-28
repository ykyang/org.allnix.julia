using Compose

using Colors, Measures

#compose(context(), circle(), fill("gold"))

#composition = compose(compose(context(), rectangle()), fill("tomato"))

## The compose function accepts S-expressions
# S-expression
composition = compose(context(), rectangle(), fill("tomato"))

#draw(SVG("tomato.svg", 4cm, 4cm), composition)
composition |> SVG("tomato.svg", 4cm, 4cm)

composition = compose(context(),
        (context(), circle(), fill("bisque")),
        (context(), rectangle(), fill("tomato")),
)
composition |> SVG("tomato_bisque.svg", 10cm, 10cm)

## Trees can be visualized with introspect
tomato_bisque = compose(context(),
        (context(), circle(), fill("bisque")),
        (context(), rectangle(), fill("tomato")),
)

#introspect(tomato_bisque) |> SVG("introspect.svg", 10cm, 10cm)

figsize = 6mm
t = table(3, 2, 1:3, 2:2, y_prop=[1.0, 1.0, 1.0])
t[1,1] = [compose(context(minwidth=figsize + 2mm, minheight=figsize),
                  circle(0.5, 0.5, figsize/2), fill(LCHab(92, 10, 77)))]
t[2,1] = [compose(context(minwidth=figsize + 2mm, minheight=figsize),
                  rectangle(0.5cx - figsize/2, 0.5cy - figsize/2, figsize, figsize),
                  fill(LCHab(68, 74, 192)))]
t[3,1] = [compose(context(minwidth=figsize + 2mm, minheight=figsize),
                  polygon([(0.5cx - figsize/2, 0.5cy - figsize/2),
                           (0.5cx + figsize/2, 0.5cy - figsize/2),
                           (0.5cx, 0.5cy + figsize/2)]),
                  fill(LCHab(68, 74, 29)))]
t[1,2] = [compose(context(), text(0, 0.5, "Context", hleft, vcenter))]
t[2,2] = [compose(context(), text(0, 0.5, "Form", hleft, vcenter))]
t[3,2] = [compose(context(), text(0, 0.5, "Property", hleft, vcenter))]
composition = compose(context(), t, fill(LCHab(92, 10, 77)), fontsize(10pt))
composition |> SVG("intro.svg", 10cm, 10cm)


## Contexts specify a coordinate system for their children
# https://giovineitalia.github.io/Compose.jl/latest/tutorial/#Contexts-specify-a-coordinate-system-for-their-children
composition = compose(context(), fill("tomato"),
    (context(0,0,0.5,0.5), circle()),
    (context(0.5,0.5,0.5,0.5), circle()),
)
composition |> SVG("tomatos.svg", 10cm, 10cm)
#introspect(composition) |> SVG("introspect.svg", 10cm, 10cm)



nothing
