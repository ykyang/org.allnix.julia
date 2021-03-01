# https://github.com/JuliaPlots/Makie.jl
# http://juliaplots.org/MakieReferenceImages/
# http://juliaplots.org/MakieReferenceImages/gallery/index.html
using Makie
#using AbstractPlotting # not necessary
using LinearAlgebra
import GeometryBasics
gb = GeometryBasics

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
#sec_animated_surface_wireframe()
#sec_arrows_3d()
#sec_axis_surface()
sec_merged_color_mesh()
#sec_shading()
#sec_volume()

test_rect()
#test_mesh()