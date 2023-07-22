module LearnMakie

# https://github.com/JuliaPlots/Makie.jl
# http://juliaplots.org/MakieReferenceImages/
# http://juliaplots.org/MakieReferenceImages/gallery/index.html

using Dates
using ColorSchemes

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
using CircularArrays

using Test

## https://docs.makie.org/stable/documentation

## default color sequence
# Makie.wong_colors()

## Colormap
## https://docs.juliaplots.org/latest/generated/colorschemes/

function learn_colormap_1()
    fig = Figure(); ax = Axis(fig[1,1])
    x = range(0,pi*5, length=100)
    y = sin.(x)
    # plot = lines!(ax, x, y; color=y,
    #     linewidth=5,
    #     colormap = cgrad(:tab10, categorical=true)
    # )
    plot = scatter!(ax, x, y; 
        #color=(y .+ 1)./2,
        color = y,
        #linewidth=5,
        markersize = 20,
        colormap = cgrad(:Accent_3, ([-1, -0.25, 0.25, 1] .+ 1)./2; categorical=true),
        colorrange = (-0.75, 0.75),
    )
    DataInspector(fig)
    bar = Colorbar(fig[1,2], plot)

    fig
end

## Basic Tutorial
## https://docs.makie.org/stable/tutorials/basic-tutorial/#basic_tutorial

## Adding a plot to an axis
function learn_basic_tutorial_1()
    ## https://docs.makie.org/stable/tutorials/basic-tutorial/#adding_a_plot_to_an_axis
    fig = Figure()
    ax = Axis(fig[1,1])
    x = range(0, 10, length=100)
    y = sin.(x)
    R = lines!(ax, x, y)
    # @show R; # R = Lines{Tuple{Vector{Point{2, Float32}}}}
    DataInspector(fig)

    display(fig)
end
## Scatter plot
function learn_basic_tutorial_2()
    ## https://docs.makie.org/stable/tutorials/basic-tutorial/#scatter_plot
    fig = Figure()
    ax = Axis(fig[1,1])
    x = range(0, 10, length=100)
    y = sin.(x)
    R = scatter!(ax, x, y)
    # @show R # R = Scatter{Tuple{Vector{Point{2, Float32}}}}
    R = DataInspector(fig)
    # @show R # R is a DataInspector object

    display(fig)
end
## Creating Figure, Axis and plot in one call
function learn_basic_tutorial_3()
    ## https://docs.makie.org/stable/tutorials/basic-tutorial/#creating_figure_axis_and_plot_in_one_call
    x = range(0, 10; length=100)
    y = sin.(x)
    # fig, ax, plot = lines(x,y)
    R = lines(x,y); # @show typeof(R) # typeof(R) = Makie.FigureAxisPlot
    
    @test R.figure isa Figure
    @test R.axis   isa Axis
    @test R.plot   isa AbstractPlot

    display(R)
end
## Passing Figure and Axis styles
function learn_basic_tutorial_4()
   ## https://docs.makie.org/stable/tutorials/basic-tutorial/#passing_figure_and_axis_styles
    x = range(0, 10; length=100)
    y = sin.(x)
    R = scatter(x, y;
        figure = (; resolution=(400,400)),
        axis = (; title="Scatter plot", xlabel="x label"),
    )
end
## Argument conversions
function learn_basic_tutorial_5()
    ## https://docs.makie.org/stable/tutorials/basic-tutorial/#argument_conversions
    lines(0..10, sin) # 0..10 is a ClosedInterval
    lines(0:1:10, cos)
    lines([Point(0,0), Point(5,10), Point(10,5)])
end
## Layering multiple plots
function learn_basic_tutorial_6()
    ## https://docs.makie.org/stable/tutorials/basic-tutorial/#layering_multiple_plots
    x = range(0, 10; length=100)
    fig, ax, l1 = lines(x, sin)
    l2 = lines!(ax, x, cos)
    
    fig # no need to use display() if last statement
end
## Attributes
function learn_basic_tutorial_7()
    ## https://docs.makie.org/stable/tutorials/basic-tutorial/#attributes
    # :red or "red"
    # "#ffccbk"
    # RGBf(0.5, 0, 0.6) or RGBAf(0.3, 0.8, 0.2, 0.8)
    # (:red, 0.5) where 0.5 is alpha
    # See https://juliagraphics.github.io/Colors.jl/stable/
    x = range(0,10; length=100)
    fig, ax, l1 = lines(x, sin; color=:tomato)
    l2 = lines!(ax, x, cos; color=RGBf(0.2,0.7,0.9))

    fig
end
## scatter
function learn_basic_tutorial_7_1()
    fig = Figure(); ax = Axis(fig[1,1])
    x = range(0, 10; length=100); y = sin.(x);

    sc1 = scatter!(ax, x, y; color=:coral, markersize=15)
    sc2 = scatter!(ax, x, cos; color=:dodgerblue, markersize=10)
    
    sc1.markersize = 20
    sc1.color = (:coral, 0.2)
    sc1.strokewidth = 2 
    sc1.strokecolor = :coral

    fig
end
## Array attributes
function learn_basic_tutorial_8()
    ## https://docs.makie.org/stable/tutorials/basic-tutorial/#array_attributes
    fig = Figure(); ax = Axis(fig[1,1])
    x = range(0, 10; length=100)
    plot = scatter!(ax, x, sin; 
        markersize = range(5, 30; length=100),
        color      = range(0,1; length=100),
        colormap   = :thermal,
    )

    fig
end
## colorrange
function learn_basic_tutorial_8_1()
    fig = Figure(); ax = Axis(fig[1,1])
    x = range(0, 10; length=100)
    plot = scatter!(ax, x, sin; 
        markersize = range(5, 30; length=100),
        color      = range(0,1; length=100),
        colormap   = :thermal,
        colorrange = (0.33, 0.66)
    )
    
    fig
end
## explicit colors
function learn_basic_tutorial_8_2()
    fig = Figure(); ax = Axis(fig[1,1])
    x = range(0, 10; length=100)
    colors = CircularArray([:crimson, :dodgerblue, :slateblue1, :sienna1, :orchid1])[1:length(x)]
    plot = scatter!(ax, x, sin; color=colors, markersize=20)

    fig
end
## Simple legend
function learn_basic_tutorial_9()
    ## https://docs.makie.org/stable/tutorials/basic-tutorial/#simple_legend
    fig = Figure(); ax = Axis(fig[1,1])
    x = range(0, 10, length=100)
    l1 = lines!(ax, x, sin, label="sin", color=:tomato)
    l2 = lines!(ax, x, cos, label="cos", color=:dodgerblue)
    axislegend(ax)

    fig
end
## Subplots
function learn_basic_tutorial_10()
    ## https://docs.makie.org/stable/tutorials/basic-tutorial/#subplots
    fig = Figure()
    ax1 = Axis(fig[1,1]); ax2 = Axis(fig[1,2]); ax3 = Axis(fig[2,1:2])
    x = range(0, 10; length=100)
    y = sin.(x)

    lines!(ax1, x, y; color=:tomato)
    lines!(ax2, x, y; color=:dodgerblue)
    lines!(ax3, x, y; color=:green)

    fig 
end
## Legend and Colorbar
function learn_basic_tutorial_11()
    ## https://docs.makie.org/stable/tutorials/basic-tutorial/#legend_and_colorbar
    fig = Figure()
    colors = CircularArray(Makie.wong_colors())
    ax1,l1 = lines(fig[1,1], 0..10, sin, color=colors[1])
    ax2,l2 = lines(fig[2,1], 0..10, cos, color=colors[2])
    l = Legend(fig[1:2,2], [l1,l2], ["sin", "cos"])

    fig
end
## colorbar
function learn_basic_tutorial_11_1()
    fig,ax,plot = heatmap(randn(20,20))
    bar = Colorbar(fig[1,2], plot)

    fig
end



## DateTime, Date, Time
# https://discourse.julialang.org/t/date-axis-in-makie/63430
# https://beautiful.makie.org/dev/examples/generated/2d/lines/line_time/
function learn_datetime_1()
    fig = Figure(resolution=(1600,900)); ax = Axis(fig[1,1])
    y = 1:10
    dates = DateTime(2023,07,01):Year(1):DateTime(2032,07,01)
    x = Dates.datetime2epochms.(dates)
    lines!(ax, x, y)

    # xticks
    ax.xticks = (x, Dates.format.(dates, dateformat"yyyy-mm-dd"))
    ax.xticklabelrotation = pi/4
    ax.xticklabelalign = (:right, :center)

    fig
end



## Heatmap
function learn_heatmap_1()
    ## https://docs.makie.org/stable/examples/plotting_functions/heatmap/#heatmap
    fig = Figure()
    ax = Axis(fig[1,1])
    xs = range(0, 10; length=25)
    ys = range(0, 15, length=25)

    ## shading=flat in matplotlib
    zs = [cos(x)*sin(y) for x in xs[1:end-1], y in ys[1:end-1]]
    ## shading in matplotlib
    #zs = [cos(x)*sin(y) for x in xs, y in ys]

    hm = heatmap!(ax, xs, ys, zs)
    Colorbar(fig[:, end+1], hm)

    fig
end
function learn_heatmap_2()
    ## shading=flat

    fig = Figure()
    ax = Axis(fig[1,1])
    xs = 0:4
    ys = 0:3
    zs = [
        1  5   9
        2  6  10
        3  7  11
        4  8  12
    ]

    ## zs = 
    # +--> y
    # |   1  5   9
    # x   2  6  10
    #     3  7  11
    #     4  8  12
    # 
    # plotted as
    #     9  10  11  12
    # y   5   6   7   8
    # |   1   2   3   4
    # +--> x
    hm = heatmap!(ax, xs, ys, zs)
    Colorbar(fig[:, end+1], hm)
    
    fig
end

function learn_heatmap_3()
    ## https://docs.makie.org/stable/documentation/colors/
    colormap = :Accent_8
    colormap = :Dark2_8
    ## Transparent
    colormap = colorscheme_alpha(ColorSchemes.Dark2_8, 0.2;ncolors=8); colorrange=(1,8);
    colormap = colorscheme_alpha(ColorSchemes.Set3_12, 0.2;ncolors=12); colorrange=(1,12);
        
    alpha = 0.1f0
    colormap = ColorScheme([
        RGBA{Float32}(0.0f0,       0.44705883f0, 0.69803923f0, alpha),
        RGBA{Float32}(0.9019608f0, 0.62352943f0, 0.0f0,        alpha),
        RGBA{Float32}(0.0f0,       0.61960787f0, 0.4509804f0,  alpha),
        RGBA{Float32}(0.8f0,       0.4745098f0,  0.654902f0,   alpha),
        RGBA{Float32}(0.3372549f0, 0.7058824f0,  0.9137255f0,  alpha),
        RGBA{Float32}(0.8352941f0, 0.36862746f0, 0.0f0,        alpha),
        RGBA{Float32}(0.9411765f0, 0.89411765f0, 0.25882354f0, alpha),]); colorrange=(1,7)



    fig = Figure(); ax = Axis(fig[1,1])
    xs = 0:4; ys = 0:3
    z = NaN

    eles = []
    let v = 1
        zs = [
            v z z
            v v z
            v v z
            z z z
        ]
        plot = heatmap!(ax, xs, ys, zs; 
            #transparency=true,
            colormap=colormap, colorrange=colorrange)

        for i in 1:10
            zs = [
                v z z
                z z z
                z z z
                z z z
            ]
            plot = heatmap!(ax, xs, ys, zs; 
                #transparency=true,
                colormap=colormap, colorrange=colorrange)
        end
        ele = PolyElement(color=Makie.wong_colors()[v], points=Point2f[(0,0), (1,0), (1,1), (0,1)])
        push!(eles, ele)
    end

    
    
    let v = 4
        zs = [
            z z z
            z v v
            z v v
            z z v
        ]
        plot = heatmap!(ax, xs, ys, zs;
            #transparency=true,
            #alpha=0.01,
            colormap=colormap,
            #color=[(:tomato,0.2)],
            colorrange=colorrange)
        for i in 1:10
            zs = [
                z z z
                z z z
                z z z
                z z v
            ]
            plot = heatmap!(ax, xs, ys, zs;
                #transparency=true,
                #alpha=0.01,
                colormap=colormap,
                #color=[(:tomato,0.2)],
                colorrange=colorrange)
        end
        ele = PolyElement(color=Makie.wong_colors()[v], points=Point2f[(0,0), (1,0), (1,1), (0,1)])
        push!(eles, ele)
    end

    Legend(fig[1,2], eles, ["1", "4"])
    fig
end

function colorscheme_alpha(cscheme::ColorScheme, alpha::T = 0.5; 
    ncolors=12) where T<:Real
    ## https://juliagraphics.github.io/ColorSchemes.jl/stable/basics/#Alpha-transparency
    return ColorScheme([RGBA(get(cscheme, k), alpha) for k in range(0, 1, length=ncolors)])
end




## Learn multiple axis

function learn_multiaxis_1()
    ## https://docs.makie.org/stable/examples/blocks/axis/index.html#creating_a_twin_axis
    fig = Figure()
    
    ax1 = Axis(fig[1,1], yticklabelcolor=:dodgerblue)
    ax2 = Axis(fig[1,1], yticklabelcolor=:tomato, yaxisposition=:right)

    hidespines!(ax2)
    hidexdecorations!(ax2)
    
    lines!(ax1, 0..10, sin, color=:dodgerblue)
    lines!(ax2, 0..10, x->100*cos(x), color=:tomato)

    linkxaxes!(ax1, ax2)
    linkyaxes!(ax2, ax2)

    fig
end
"""
    learn_multiaxis_2()

Follow the logic of run_multiaxes()
"""
function learn_multiaxis_2()
    ## Follow multiaxes() below
    fig = Figure()
    
    axs = []; twins = [];
    push!(axs, Axis(fig[1,1]))
    push!(twins, axs[1])
    #mainax = 
    let # green
        ax = Axis(fig[1,1]); push!(axs, ax); push!(twins, ax)
        x = 90:0.1:91
        plot = scatter!(ax, x, x->rand()*10.0^rand(-2:2))
        plot.marker=:utriangle
        plot.color = :green
        plot.markersize=16
        ax.yscale = log10
        ax.yminorticksvisible = true
        ax.yminorticks = [x*10^y for x in 1.0:9, y in -4.0:1][:]
        ax.yticklabelcolor = :green
        ax.ytickcolor = :green
        ax.leftspinecolor = :green
        ax.rightspinevisible = false
        setproperty!.(ax, [:leftspinecolor, :ytickcolor], [:green, :green])
        ylims!(ax, 1e-4, 100)
        
    end

    let # red
        ax = Axis(fig[1,1]); push!(axs, ax); push!(twins, ax)
        x = 84:90
        y = @. 780 + 10*sin(x-2)
        low_eb = high_eb = fill(2, length(x))
        plot = errorbars!(ax, x, y, low_eb, high_eb)
        plot.whiskerwidth=10
        plot = scatter!(ax, x, y)
        plot.marker = :rect
        plot.markersize = 15
        plot.color = :tomato
        props = [
            :yaxisposition    :right
            :yticklabelcolor  :tomato
            :ytickcolor       :tomato
            :rightspinecolor  :tomato
            :leftspinevisible false
        ]
        setproperty!.(ax, props[:,1], props[:,2])
        ylims!(ax, 765, 795) 
    end
    let # blue
        ax = Axis(fig[1,1]); push!(axs, ax)
        x = 84:90
        y = @. 0.6*(x-82) + 0.2*sin(x)
        plot = lines!(ax, x, y, color=:dodgerblue)
        plot = scatter!(ax, x, y, marker=:circle, markersize=16, color=:dodgerblue)
        twin = Axis(fig[1,2]); push!(twins, twin)
        ax.yticklabelsvisible = false
        hidespines!(ax)
        hidedecorations!(twin)
        hidespines!(twin)
        twin.rightspinevisible=true
        twin.rightspinecolor = :dodgerblue
        twin.yaxisposition = :right
        twin.ytickcolor = :dodgerblue
        twin.yticksvisible = true
        twin.yticklabelsvisible = true
        twin.yticklabelcolor = :dodgerblue
        ylims!(ax, 0, 6)
        ylims!(twin, 0, 6)
        colsize!(fig.layout, 2, Auto(0))
    end

    for ax in axs[1:1]
        ax.leftspinevisible = false
        ax.rightspinevisible = false
        ax.yticksvisible = false
        ax.yticklabelsvisible = false
    end
    for ax in axs[2:end]
        ax.topspinevisible = false
        ax.bottomspinevisible = false
    end

    for ax in axs
        xlims!(ax, 93, 82)
        ax.xgridvisible = false
        ax.ygridvisible = false
    end
    fig
end

"""
    learn_multiaxis_3()

Display 4 y-axis and a view are.

1         2         3
y    y         y    y 
|    |---------|    | 
|    | View    |    | 
|    | Area    |    | 
|    |---------|    | 

1         2               3
yax[1]    vax[1]          yax[4]
          vax[2]=yax[2]
          vax[3]=yax[3]
          vax[4]
"""
function learn_multiaxis_3()
    fig = Figure()
    no_axis = 4
    vaxs = Vector{Axis}(undef, no_axis) # view axis
    yaxs = Vector{Axis}(undef, no_axis) # y-axis axis
    vaxind = 2 # view axis index
    
    ## Create all axis
    for i in 1:no_axis
        vaxs[i] = Axis(fig[1,vaxind])
    end
    #@show vaxs

    ## Create axis for y-axis
    for i in 1:vaxind-1
        yaxs[i] = Axis(fig[1,i])
    end
    for i in vaxind:vaxind+1
        yaxs[i] = vaxs[i]
    end
    for i in vaxind+2:no_axis
        yaxs[i] = Axis(fig[1,i-1])
    end
    
    ## Clear axis
    for ax in vcat(vaxs,yaxs)
        props = [
            :xgridvisible        false
            :ygridvisible        false
            :leftspinevisible    false
            :rightspinevisible   false
            :topspinevisible     false
            :bottomspinevisible  false
            :xticksvisible       false
            :xticklabelsvisible  false
            :yticksvisible       false
            :yticklabelsvisible  false
        ]
        setproperty!.(ax, props[:,1], props[:,2])
    end
    

    let color = :black, yaxind = 1
        vax = vaxs[yaxind]
        yax = yaxs[yaxind]
        x = 93:0.1:94
        plot = scatter!(vax, x, rand(Float64,length(x)), color=color)
        ylims!(vax, 0, 1)
        ylims!(yax, 0, 1)
        props = [
            :leftspinevisible    true
            :yticksvisible       true
            :yticklabelsvisible  true
            :ytickcolor          color
            :yticklabelcolor     color
            :leftspinecolor      color
            :ylabel              L"Fraction$$"
            :ylabelcolor         color
        ]
        setproperty!.(yax, props[:,1], props[:,2])
        colsize!(fig.layout, yaxind, Auto(0))
    end

    let color = :green, yaxind = 2
        vax = vaxs[yaxind]
        yax = yaxs[yaxind]
        x = 90:0.1:91
        ylims!(vax, 1e-4, 100)
        ylims!(yax, 1e-4, 100)
        vax.yscale = log10
        plot = scatter!(vax, x, x->rand()*10.0^rand(-2:2), color=color)
        props = [
            :leftspinevisible    true
            :yticksvisible       true
            :yticklabelsvisible  true
            :ytickcolor          color
            :yticklabelcolor     color
            :leftspinecolor      color
            :ylabel              L"Deposition Pressure (Torr)$$"
            :ylabelcolor         color
        ]
        setproperty!.(yax, props[:,1], props[:,2])
    end
    let color = :tomato, yaxind = 3
        vax = vaxs[yaxind]
        yax = yaxs[yaxind]
        x = 84:90
        y = @. 780 + 10*sin(x-2)
        low_eb = high_eb = fill(2, length(x))
        plot = errorbars!(vax, x, y, low_eb, high_eb)
        plot.whiskerwidth=10
        plot = scatter!(vax, x, y)
        plot.marker = :rect
        plot.markersize = 15
        plot.color = :tomato

        ylims!(vax, 765, 795)
        ylims!(yax, 765, 795)

        props = [
            :yaxisposition       :right
            :rightspinevisible   true
            :yticksvisible       true
            :yticklabelsvisible  true
            :ytickcolor          color
            :yticklabelcolor     color
            :rightspinecolor     color
            :ylabel              L"Annealing Temperature $(^{\circ}$C)"
            :ylabelcolor         color
        ]
        setproperty!.(yax, props[:,1], props[:,2])
    end
    let color = :dodgerblue, yaxind = 4
        vax = vaxs[yaxind]
        yax = yaxs[yaxind]
        x = 84:90
        y = @. 0.6*(x-82) + 0.2*sin(x)
        plot = lines!(vax, x, y, color=color)
        plot = scatter!(vax, x, y, marker=:circle, markersize=16, color=:dodgerblue)
        ylims!(vax, 0, 6)
        ylims!(yax, 0, 6)

        props = [
            :yaxisposition       :right
            :rightspinevisible   true
            :yticksvisible       true
            :yticklabelsvisible  true
            :ytickcolor          color
            :yticklabelcolor     color
            :rightspinecolor     color
            :ylabel              L"$\Delta T_C$ $(^{\circ}$K)"
            :ylabelcolor         color
        ]
        setproperty!.(yax, props[:,1], props[:,2])

        colsize!(fig.layout, yaxind-1, Auto(0))
    end

    let ax = vaxs[vaxind]
        props = [
            # :leftspinevisible    true
            # :rightspinevisible   true
            :bottomspinevisible  true
            :xticksvisible       true
            :xticklabelsvisible  true
            :xlabel              L"Transition Temperature $(^{\circ}$K)"
        ]
        setproperty!.(ax, props[:,1], props[:,2])
    end

    for ax in vaxs
        xlims!(ax, 96, 82)
        ax.xgridvisible = false
        ax.ygridvisible = false
    end
    fig
end





function learn_spine_1()
    fig = Figure(); ax = Axis(fig[1,1])
    x = range(0, 10, length=100)
    l = lines!(ax, x, sin, label="sin", color=:tomato)
    xlims!(ax, -10, 10)
    ax.xticks = (-5:1:10, string.(-5:1:10))
    
    fig
end









## https://github.com/MakieOrg/Makie.jl/issues/206
"""
```
function multiaxes(n::Int=3, fig::Figure=Figure();
        ylabels=["Axis \$i" for i in 1:6],
        positions=[:left, :right, :right, :left, :right, :left],
        colors=Makie.current_default_theme().palette.color.val,
        ytickpositions=[:right, :left, :left, :right, :left, :right])
```

Generates `n` axes for the same figure `f` with defined `ylabels`
Axes `positions` are either `:left` or `:right`
Axes `colors` are supplied as a list of valid colors e.g. `[:blue, :red]`
Positions of y ticks are defined int `ytickpositions` vector

Returns a vector of `n+m` generated axes 
    Axes `1` to `n` for plotting the graphs, these axes are x-linked together
    Axes `n+1` to `n+m` for scale bars reference

Axis 1 is the master axis which will be used for xlabels and zooming options


# Examples :
## Generate a new empty figure with 6 axes
```
axes = multiaxes(6); fig = axes[1].parent 
```
Axis 6 / Axis 4 / Axis 1 [] Axis 2 / Axis 3 / Axis 5

## Generate a 3 axis figure with some plots :
```
fig = Figure()
axes = multiaxes(3, fig)
lines!(axes[1], 0..10, cos, color = axes[1].ylabelcolor)
lines!(axes[2], 0..10, sin, color = axes[2].ylabelcolor)
lines!(axes[3], 0..10, x->2sin(2x), color = axes[3].ylabelcolor)
fig = axes[1].parent 
```
 Axis 1 (-1,1) [ ] Axis 2 (-1,1) / Axis 3 (-2,2)
"""
function multiaxes(n::Int=3, fig::Figure=Figure();
    ylabels=["Axis $i" for i in 1:6],
    positions=[:left, :right, :right, :left, :right, :left],
    colors=Makie.current_default_theme().palette.color.val,
    ytickpositions=[:right, :left, :left, :right, :left, :right],
    xlabel ="x")


    @assert all(x -> x ≥ n,
        length.([ylabels, positions, colors, ytickpositions])) "arguments lengths should at least match n"

    ax, ax2 = [], []

    # Central position of main axis where all plots are displayed
    centraln = sum(p == :left for p in positions[1:n])

    # Current position of left and right axes
    left, right = centraln .+ (1, -1)


    for i in 1:n
        # Update position for axis i
        if positions[i] == :left
            left -= 1
            pos = left
        else
            right += 1
            pos = right
        end

        c = colors[i]

        a = Axis(fig[1, centraln], yaxisposition=positions[i],
            ylabel=ylabels[i], xlabel=xlabel,
            yticklabelcolor=c, ytickcolor=c, ylabelcolor=c)

        if i > 1 # Hide x labels for other axes
            a.xticklabelsvisible = false
            a.xlabelvisible = false
        end

        ca = a
        if pos != centraln
            hidedecorations!(a)
            hidespines!(a)

            a2 = Axis(fig[1, pos], yaxisposition=positions[i],
                ylabel=ylabels[i],
                yticklabelcolor=c, ytickcolor=c, ylabelcolor=c)
            
            hidexdecorations!(a2)

            colsize!(fig.layout, pos, Auto(0))
            ca = a2

            linkyaxes!(a, a2)
            push!(ax2, a2)
        end

        if positions[i] == :left
            ca.leftspinecolor = c
            ca.rightspinevisible = false
            ca.ytickalign = ytickpositions[i] == :left ? 0 : 1
        else
            ca.rightspinecolor = c
            ca.leftspinevisible = false
            ca.ytickalign = ytickpositions[i] == :right ? 0 : 1
        end

        push!(ax, a)
    end

    linkxaxes!(ax...)

    return append!(ax, ax2)
end

"""
    run_multiaxes()

Run the multiaxes() function.
https://github.com/MakieOrg/Makie.jl/issues/206
"""
function run_multiaxes()
    fig = Figure(colorsgroundcolor=:white, resolution=(600, 500))

    ax = multiaxes(3, fig,
        ylabels=[L"Deposition Pressure (Torr)$$",
            L"Annealing Temperature $(^{\circ}$C)",
            L"$\Delta T_C$ $(^{\circ}$K)"],
        xlabel=L"Transition Temperature $(^{\circ}$K)",
        colors=[:green, :red, :blue],
        ytickpositions=[:left, :left, :left]
    )
    x = 90:0.1:91
    s1 = scatter!(ax[1], x, x -> rand() * 10.0^rand(-2:2),
                marker=:utriangle, markersize=16, color=ax[1].ylabelcolor)
    ax[1].yscale = log10
    ax[1].yminorticksvisible = true
    ax[1].yminorticks = [x*10^y for x in 1.0:9.0, y in -4.0:1][:]
    ylims!(ax[1],1e-4, 100)

    x = 84:90

    y = @. 780 + 10sin(x-2)
    low_eb = high_eb = fill(2, length(x))
    errorbars!(ax[2], x, y, low_eb, high_eb, whiskerwidth=10, color=:black, linewidth=1)
    s2 = scatter!(ax[2], x, y, marker=:rect, markersize=16, color=ax[2].ylabelcolor)
    ylims!(ax[2], 765,795)

    y = @. 0.6(x-82) + 0.2sin(x)
    lines!(ax[3], x, y, color=ax[3].ylabelcolor)
    s3 = scatter!(ax[3], x, y, marker=:circle, markersize=16, color=ax[3].ylabelcolor)
    ylims!(ax[3], 0, 6)

    for i in 1:3
        xlims!(ax[i], 93, 82)
        ax[i].xgridvisible = false
        ax[i].ygridvisible = false
    end

    axislegend(ax[1], [s1,s2, s3], [L"$$As Grown",L"$$Annealed",L"\Delta T_C"])

    Label(fig[0, :], text=L"Characteristics of Samples Grown Under Different Conditions$$")
    fig
end



# Deprecated below



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
#learn_plotting_arrows_2()



#sec_animated_surface_wireframe()
#sec_arrows_3d()
#sec_axis_surface()
#sec_merged_color_mesh()
#sec_shading()
#sec_volume()

#test_rect()
#test_mesh()






end