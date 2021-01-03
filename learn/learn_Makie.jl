# https://github.com/JuliaPlots/Makie.jl
using Makie
#using AbstractPlotting # not necessary
using LinearAlgebra

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

function sec_volume()
    volume(rand(32, 32, 32), algorithm = :mip)
end

#sec_animated_surface_wireframe()
#sec_arrows_3d()
#sec_axis_surface()
#sec_volume()