# https://github.com/JuliaPlots/Makie.jl
# http://juliaplots.org/MakieReferenceImages/
# http://juliaplots.org/MakieReferenceImages/gallery/index.html

# Need to restart Julia in order to switch the backend
glmakie    = false
cairomakie = false
wglmakie   = false

glmakie    = true
#cairomakie = true
#wglmakie = true



# GLMakie.jl
# GLMakie.jl is in a sub-directory of Makie.jl.  The old GLMakie.jl package
# is deprecated.
# add GLMakie
if glmakie
    using GLMakie
end

# CairoMakie.jl
if cairomakie
    using CairoMakie
end

if wglmakie
    using WGLMakie
end

#using AbstractPlotting # not necessary
using LinearAlgebra
import GeometryBasics
gb = GeometryBasics
using Colors

function learn_basic_lines()
    x = range(0, 10, length=100)
    y = sin.(x)
    #fig = lines(x, y)
    lines(x, y)
    # @show typeof(fig)
    # if glmakie
    # # fig isa AbstractPlotting.FigureAxisPlot
    #     display(fig)
    # end
    # if cairomakie
    # # fig isa Makie.FigureAxisPlot
    #     display(fig)
    # end

    # fig
end

function learn_basic_scatter()
    x = range(0, 10, length=100)
    y = sin.(x)
    scatter(x, y)
end

function learn_basic_multiple_plots()
    x = range(0, 10, length=100)
    y1 = sin.(x)
    y2 = cos.(x)

    lines(x, y1)
    lines!(x, y2)
    current_figure()
end

function learn_basic_attributes()
    x = range(0, 10, length=100)
    y1 = sin.(x)
    y2 = cos.(x)

    lines(x, y1, color = colorant"darkred", linewidth=5)
    lines!(x, y2, color = colorant"darkblue")
    current_figure()
end

function learn_basic_attributes_2()
    x = range(0, 10, length=100)
    y1 = sin.(x)
    y2 = cos.(x)

    scatter(x, y1, color = colorant"darkred", markersize=5)
    plt = scatter!(x, y2, color = colorant"darkblue", markersize=10)
    plt.color = colorant"darkgreen"

    current_figure()
end
function learn_basic_attributes_3()
    x = range(0, 10, length=100)
    y1 = sin.(x)
    y2 = cos.(x)

    scatter(x, y1, color = :red, markersize = range(5, 15, length=100))
    sc = scatter!(x, y2, color = range(0, 1, length=100), colormap = :thermal)
    sc.colorrange = (0.25, 0.75)
    current_figure()
end

function learn_basic_attributes_4()
    x = range(0, 10, length=100)
    y = sin.(x)

    colors = repeat([:crimson, :dodgerblue, :slateblue1, :sienna1, :orchid1], 20)

    scatter(x, y, color = colors, markersize = 20)
end

function learn_basic_simple_legend()
    x = range(0, 10, length=100)
    y1 = sin.(x)
    y2 = cos.(x)

    lines(x, y1, color = :red, label = "sin")
    lines!(x, y2, color = :blue, label = "cos")
    axislegend()
    current_figure()
end
"""

Construct `Figure` manually.
"""
function learn_basic_subplots()
    #x = LinRange(0, 10, 100)
    x = range(0, 10, length=100)
    y = sin.(x)

    fig = Figure()
    lines(fig[1, 1], x, y, color = :red)
    lines(fig[1, 2], x, y, color = :blue)
    lines(fig[2, 1:2], x, y, color = :green)
    display(fig)
end

function learn_basic_constructing_axes()
    fig = Figure()
    ax1 = Axis(fig[1,1])
    ax2 = Axis(fig[1,2])
    ax3 = Axis(fig[2, 1:2])
    display(fig)

    # .. from IntervalSets.jl
    lines!(ax1, -pi..pi, sin)
    lines!(ax2, 0..10, cos)
    lines!(ax3, 0..10, sqrt)

    ax1.title = "sin"
    ax2.title = "cos"
    ax3.title = "sqrt"

    ax1.ylabel = "amplitude"
    ax3.ylabel = "amplitude"
    ax3.xlabel = "time"
end

function learn_basic_legend()
    fig = Figure()
    ax1, l1 = lines(fig[1,1], 0..10, sin, color=:darkred)
    ax2, l2 = lines(fig[2,1], 0..10, cos, color=:lightblue)
    Legend(fig[1:2,2], [l1,l2], ["sin", "cos"])


    display(fig)
end

function learn_basic_colorbar()
    fig, ax, hm = heatmap(randn(20,20))

    Colorbar(fig[1,2], hm)

    #@show fig # = (backgroundcolor = :pink)
    #fig.attributes[:backgroundcolor] = :pink
    fig.scene.backgroundcolor = :pink
    ax.aspect = 1
    display(fig)

    # does not work
    # heatmap(
    #     randn(20,20),
    #     figure = (backgroundcolor = :pink)
    # )
end

function learn_plotting_arrows()
    x2y = 2/3
    fig = Figure(resolution = (500, 500/x2y))
    ax = Axis(fig[1,1], backgroundcolor=:black)
    ax.aspect = x2y

    xs = range(0, 2pi, length=20)
    ys = range(0, 2pi/x2y, length=20)
    
    us = [sin(x)*cos(y) for x in xs, y in ys]
    vs = [-cos(x)*sin(y) for x in xs, y in ys]
    # strength = vec(
    #     @. sqrt(us^2 + vs^2)
    # )
    strength = vec(sqrt.(us .^ 2 .+ vs .^ 2))

    ar = arrows!(xs, ys, us, vs, arrowsize=0.1, lengthscale=0.3, arrowcolor=strength, linecolor=strength)

    display(fig)
end

function learn_plotting_arrows_2()
    ps = [Point3(x,y,z) for x in -5:2:5 for y in -5:2:5 for z in -5:2:5]
    ns = map(p -> 0.1 * Vec3(p[2], p[3], p[1]), ps)
    lengths = norm.(ns)
    fig, ax, ar = arrows(
        ps, ns, fxaa=true, # anti_aliasing
        #linecolor = :gray, arrowcolor = :black,
        linecolor = lengths, arrowcolor = lengths,
        linewidth = 0.1, #arrowsize = Vec3(0.3,0.3,0.4),
        align = :center, axis = (type=Axis3,),
        quality = 50
    )
    #di = DataInspector(fig)
    display(fig)
end

# broken
function sec_animated_surface_wireframe()
    scene = Scene();
    function xy_data(x, y)
        r = sqrt(x^2 + y^2)
        r == 0.0 ? 1f0 : (sin(r)/r)
    end
    
    r = range(-2, stop = 2, length = 50)
    surf_func(i) = [Float32(xy_data(x*i, y*i)) for x = r, y = r]
    z = surf_func(20)
    surf = surface!(scene, r, r, z)[end]
    
    wf = wireframe!(scene, r, r, lift(x-> x .+ 1.0, surf[3]),
        linewidth = 2f0, color = lift(x-> to_colormap(x)[5], surf[:colormap])
    )
    N = 150
    scene
    record(scene, "output.mp4", range(5, stop = 40, length = N)) do i
        surf[3] = surf_func(i)
    end
end

function sec_arrows_3d()
    function SphericalToCartesian(r::T,θ::T,ϕ::T) where T<:AbstractArray
        x = @.r*sin(θ)*cos(ϕ)
        y = @.r*sin(θ)*sin(ϕ)
        z = @.r*cos(θ)
        Point3f0.(x, y, z)
    end
    n = 100^2 #number of points to generate
    r = ones(n);
    θ = acos.(1 .- 2 .* rand(n))
    φ = 2π * rand(n)
    pts = SphericalToCartesian(r,θ,φ)
    arrows(pts, (normalize.(pts) .* 0.1f0), arrowsize = 0.02, linecolor = :green, arrowcolor = :darkblue)
end

function sec_axis_surface()
    vx = -1:0.01:1
    vy = -1:0.01:1

    f(x, y) = (sin(x*10) + cos(y*10)) / 4
    scene = Scene(resolution = (500, 500))
    # One way to style the axis is to pass a nested dictionary / named tuple to it.
    surface!(scene, vx, vy, f, axis = (frame = (linewidth = 2.0,),))
    psurf = scene[end] # the surface we last plotted to scene
    # One can also directly get the axis object and manipulate it
    axis = scene[Axis] # get axis

    # You can access nested attributes likes this:
    axis[:names, :axisnames] = ("\\bf{ℜ}[u]", "\\bf{𝕴}[u]", " OK\n\\bf{δ}\n γ")
    tstyle = axis[:names] # or just get the nested attributes and work directly with them

    tstyle[:textsize] = 10
    tstyle[:textcolor] = (:red, :green, :black)
    tstyle[:font] = "helvetica"

    psurf[:colormap] = :RdYlBu
    wh = widths(scene)
    t = text!(
        campixel(scene),
        "Multipole Representation of first resonances of U-238",
        position = (wh[1] / 2.0, wh[2] - 20.0),
        align = (:center,  :center),
        textsize = 20,
        font = "helvetica",
        raw = :true
    )
    c = lines!(scene, Circle(Point2f0(0.1, 0.5), 0.1f0), color = :red, offset = Vec3f0(0, 0, 1))
    scene
    #update surface
    # TODO explain and improve the situation here
    psurf.converted[3][] = f.(vx .+ 0.5, (vy .+ 0.5)')
    scene
end
function sec_merged_color_mesh()
    function colormesh((geometry, color))
        mesh1 = gb.normal_mesh(geometry)
        npoints = length(GeometryBasics.coordinates(mesh1))
        return gb.pointmeta(mesh1; color=fill(color, npoints))
    end
    # create an array of differently colored boxes in the direction of the 3 axes
    x = Vec3f0(0); baselen = 0.2f0; dirlen = 1f0
    rectangles = [
        (Rect(Vec3f0(x), Vec3f0(dirlen, baselen, baselen)), RGBAf0(1,0,0,1)),
        (Rect(Vec3f0(x), Vec3f0(baselen, dirlen, baselen)), RGBAf0(0,1,0,1)),
        (Rect(Vec3f0(x), Vec3f0(baselen, baselen, dirlen)), RGBAf0(0,0,1,1))
    ]
    
    meshes = map(colormesh, rectangles)
    #@show meshes
    mesh(merge(meshes))
end
function sec_shading()
    #mesh(gb.Sphere(Point3f0(0), 1f0), color = :orange, shading = true)
    mesh(gb.Sphere(gb.Point3(0.0), 1.0), color = :orange, shading = true)
end

function sec_volume()
    volume(rand(32, 32, 32), algorithm = :mip)
end

function test_rect()
    rect1 = gb.Rect(0.,0., 0.,  1.,2., 3.)
    mesh(rect1, color = :purple, shading = true)
    rect2 = gb.Rect(1.,1., 1.,  1.,2., 3.)
    mesh!(rect2, color = :orange, shading = true)

    #mesh([rect1,rect2], color = [:purple, :orange], shading = true)
    current_figure()
end

function test_mesh()
    vertices = [
        0.0 0.0 1.0;
        1.0 0.0 1.0;
        1.0 1.0 1.0;
        0.0 1.0 0.0;        
    ]
    faces = [
       1 2 3;
     #  3 4 1;
    ]
    scene = mesh(vertices, faces, color = :orange)
    faces = [
       3 4 1;
    ]
    mesh!(vertices, faces, color = :purple)

    # mesh(
    # [(0.0, 0.0, 1.0), (0.5, 1.0, 0.0), (1.0, 0.0, 0.0)], color = :orange,
    # shading = false
    # )

    current_figure()
end

## Basic Tutorial ----------------------------------------------- Basic Tutorial
#learn_basic_lines()
#learn_basic_scatter()
#learn_basic_multiple_plots()

## http://makie.juliaplots.org/dev/basic-tutorial.html#Array-attributes
#learn_basic_attributes()
#learn_basic_attributes_2()
#learn_basic_attributes_3()
#learn_basic_attributes_4()

## http://makie.juliaplots.org/dev/basic-tutorial.html#Simple-legend
#learn_basic_simple_legend()
#learn_basic_subplots()
#learn_basic_constructing_axes()
#learn_basic_legend()
#learn_basic_colorbar()

## Layout Tutorial --------------------------------------------- Layout Tutorial


## Plotting Functions --------------------------------------- Plotting Functions
#learn_plotting_arrows()
learn_plotting_arrows_2()



#sec_animated_surface_wireframe()
#sec_arrows_3d()
#sec_axis_surface()
#sec_merged_color_mesh()
#sec_shading()
#sec_volume()

#test_rect()
#test_mesh()


