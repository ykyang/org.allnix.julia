#
# Learn Matplotlib through PyPlot
#
module MyPyPlot

using PyCall
using Random
using Distributions
import PyPlot as plt
using TerminalPager


const mpl = plt.matplotlib

using Test



#const plt = PyPlot

# Turn on/off GUI
pygui(true)
pygui(false) # Turn off the pop-up window
# pygui(:qt5) # good, default
# pygui(:wx) # crashes
# pygui(:gtk3)

# close("all") # close all PyPlot figures


"""
    savefig(filename)
    savefig(filename, fig::plt.Figure)

Save PyPlot figure to a file.

# Examples
```julia-repl
julia> savefig("oo_style")
"output/oo_style.png"
```
"""
function savefig(filename)
    format = "png"

    if !isdir("output")
        mkdir("output")
    end

    filepath = joinpath("output", "$filename.$format")
    plt.savefig(filepath, format=format, dpi=144)

    return filepath
end

function savefig(filename, fig::plt.Figure)
    plt.figure(fig)

    filepath = savefig(filename)

    return filepath
end

function meshgrid(x, y)
    X = x'               .* ones(length(y))
    Y = ones(length(x))' .* y

    return X, Y
end


# https://matplotlib.org/stable/tutorials/introductory/usage.html#the-object-oriented-interface-and-the-pyplot-interface
function learn_oo_style()
    x = range(0,stop=2,length=100)

    fig, ax = plt.subplots() # figure, axes

    ax.plot(x, x,    label="linear")
    ax.plot(x, x.^2, label="quadratic")
    ax.plot(x, x.^3, label="cubic")

    ax.set_xlabel("x label")
    ax.set_ylabel("y label")
    ax.set_title("Simple Plot")
    ax.legend()

    savefig("oo_style")
end
function learn_pyplot_style()
    # TODO
end
function my_plotter(ax, x, y, param_dict)
    # TODO
end


# https://matplotlib.org/stable/tutorials/introductory/usage.html#a-simple-example
function learn_a_simple_example()
    fig, ax = plt.subplots()
    ax.plot([1,2,3,4], [1,4,2,3])

    savefig("a_simple_example", fig)
end

# https://matplotlib.org/stable/tutorials/introductory/pyplot.html#intro-to-pyplot
function learn_intro_to_pyplot()
    fig,axs = plt.subplots(1,2)

    ax = axs[1]
    ax.plot([1,2,3,4]) # values for y
    ax.set_ylabel("some numbers")

    ax = axs[2]
    ax.plot([1,2,3,4], [1,2,3,4].^2) # values for y

    savefig("intro_to_pyplot", fig)
end
# https://matplotlib.org/stable/tutorials/introductory/pyplot.html#formatting-the-style-of-your-plot
function learn_formatting_the_style_of_your_plot()
    fig,ax = plt.subplots()
    ax.plot([1,2,3,4], [1,2,3,4].^2, "ro") # red circle
    ax.set_xlim(0,6)
    ax.set_ylim(0,20)

    plt.figure(fig)
    savefig("formatting_the_style_of_your_plot_1", fig)

    t = range(0,stop=5,step=0.2)
    fig,ax = plt.subplots()
    ax.plot(t,t,"r--", t,t.^2,"bs", t,t.^3, "g^")

    savefig("formatting_the_style_of_your_plot_2", fig)
end
# https://matplotlib.org/stable/tutorials/introductory/pyplot.html#plotting-with-keyword-strings
function learn_plotting_with_keyword_strings()
    data = Dict(
        "a" => range(1,stop=50,step=1),
        "c" => rand(1:50, 50),
        "d" => randn(50),
    )
    data["b"] = data["a"] + 10*randn(50)
    data["d"] = abs.(data["d"]) * 100

    fig,ax = plt.subplots()
    ax.scatter("a", "b", c="c", s="d", data=data)
    ax.set_xlabel("entry a")
    ax.set_ylabel("entry b")

    savefig("plotting_with_keyword_strings", fig)
end
# https://matplotlib.org/stable/tutorials/introductory/pyplot.html#plotting-with-categorical-variables
function learn_plotting_with_categorical_variables()
    names = ["group_a", "group_b", "group_c"]
    values = [1, 10, 100]

    fig,axs = plt.subplots(1,3, figsize=(9,3))
    
    ax = axs[1]
    ax.bar(names, values)

    ax = axs[2]
    ax.scatter(names, values)

    ax = axs[3]
    ax.plot(names, values)

    fig.suptitle("Categorical Plotting")

    savefig("plotting_with_categorical_variables", fig)
end
# https://matplotlib.org/stable/tutorials/introductory/pyplot.html#controlling-line-properties
function learn_controlling_line_properties()
    x = [1,2,3,4]
    y = [1,2,3,4]

    fig,ax = plt.subplots()
    lines = ax.plot(x, y, "--", linewidth=2, x, y.+2, "-") # Get the line object
    
    # Set line property one at a time
    line = lines[1]
    line.set_antialiased(false)
    line = lines[2]
    line.set_linewidth(4)

    # Set multiple lines
    plt.setp(lines, color="r")

    savefig("controlling_line_properties_1", fig)

    fig,ax = plt.subplots()
    line = ax.plot(x, y, drawstyle="steps-pre") # https://matplotlib.org/stable/api/_as_gen/matplotlib.axes.Axes.plot.html

    savefig("controlling_line_properties_2", fig)
end
# My own stuff from https://matplotlib.org/stable/api/_as_gen/matplotlib.axes.Axes.step.html
function learn_axes_step()
    x = [1,2,3,4]
    y = [1,2,3,4]

    fig,axs = plt.subplots(1,3, figsize=(9,3))
    ax = axs[1]
    ax.step(x, y, where="pre")
    ax.set_title("pre")
    
    ax = axs[2]
    ax.step(x, y, where="mid")
    ax.set_title("mid")

    ax = axs[3]
    ax.step(x, y, where="post")
    ax.set_title("post")

    savefig("axes_step", fig)
end
# https://matplotlib.org/stable/tutorials/introductory/pyplot.html#working-with-multiple-figures-and-axes
function learn_working_with_multiple_figures_and_axes()
    function f(x)
        return exp(-x) * cos(2*pi*x)
    end
    t1 = range(0.0, stop=5.0, step=0.1)
    t2 = range(0.0, stop=5.0, step=0.02)

    fig,axs = plt.subplots(2,1)

    ax = axs[1]
    #ax.plot(t1, f.(t1), "bo", t2, f.(t2), "k")
    ax.plot(t1, f.(t1), "bo")
    ax.plot(t2, f.(t2), "k")

    ax = axs[2]
    ax.plot(t2, cos.(2*pi*t2), "r--")
        
    savefig("working_with_multiple_figures_and_axes", fig)
end
# https://matplotlib.org/stable/tutorials/introductory/pyplot.html#working-with-text
function learn_working_with_text()
    num_count = 10000 #100 # 10000
    bin_count = 50    #10  # 50

    mu = 100.0
    sigma = 15.0
    x = mu .+ sigma .* randn(num_count)
    
    fig,ax = plt.subplots()
    # https://matplotlib.org/stable/api/_as_gen/matplotlib.axes.Axes.hist.html?highlight=hist#matplotlib.axes.Axes.hist
    n,bins,patches = ax.hist(x, bin_count, density=true, color="g", alpha=0.75)

    ax.set_xlabel("Smarts")
    ax.set_ylabel("Probability")
    ax.set_title("Histogram of IQ")
    text = ax.text(60, 0.025, raw"$\mu=100,\ \sigma=15$") # set text
    @test text isa PyObject 
    plt.setp(text, color="red") 
    ax.set_xlim(40, 160)
    ax.set_ylim(0, 0.03)
    ax.grid(true)

    savefig("working_with_text", fig)
end
# https://matplotlib.org/stable/tutorials/introductory/pyplot.html#annotating-text
function learn_annotating_text()
    fig,ax = plt.subplots()

    t = range(0.0, stop=5.0, step=0.01)
    s = cos.(2*pi*t)
    line = plt.plot(t, s, linewidth=2)
    ax.set_ylim(-2,2)
    
    # Annotation
    ax.annotate("local max", xy=(2,1), xytext=(3,1.5),
        arrowprops=Dict(
            "facecolor"=>"black", "shrink"=>0.05,
            "width"=>1, "headwidth"=>8
        )
    )

    savefig("annotating_text", fig)
end
# https://matplotlib.org/stable/tutorials/introductory/pyplot.html#logarithmic-and-other-nonlinear-axes
function learn_logarithmic_and_other_nonlinear_axes()
    # Data
    Random.seed!(19680801)
    μ = 0.5
    σ = 0.4
    dist = Normal(μ, σ)
    y = rand(dist, 1000)
    #y = y[(0 .< y) & (y .< 1)]
    y = y[findall(y -> 0 < y < 1, y)]
    sort!(y)
    x = range(1,stop=length(y),step=1)

    # Plot
    fig,axs = plt.subplots(2,2)

    # linear
    ax = axs[1,1]
    ax.plot(x,y)
    ax.set_yscale("linear")
    ax.set_title("linear")
    ax.grid(true)

    # log
    ax = axs[1,2]
    ax.plot(x, y)
    ax.set_yscale("log")
    ax.set_title("log")
    ax.grid(true)

    # symmetric log
    ax = axs[2,1]
    ax.plot(x, y .- mean(y))
    ax.set_yscale("symlog", linthresh=0.01)
    ax.set_title("symlog")
    ax.grid(true)

    ax = axs[2,2]
    ax.plot(x, y)
    ax.set_yscale("logit")
    ax.set_title("logit")
    ax.grid(true)

    # Adjust layout
    fig.subplots_adjust(top=0.92, bottom=0.08, left=0.10, right=0.95,
        hspace=0.25, wspace=0.35
    )

    savefig("logarithmic_and_other_nonlinear_axes")
end


# https://matplotlib.org/stable/plot_types/arrays/pcolormesh.html#sphx-glr-plot-types-arrays-pcolormesh-py
function learn_pcolormesh()
    # plt.matplotlib.style.available
    # plt.matplotlib.style.use("_mpl-gallery-nogrid")
    plt.matplotlib.style.use("default")


    x = [-3, -2, -1.6, -1.2, -.8, -.5, -.2, .1, .3, .5, .8, 1.1, 1.5, 1.9, 2.3, 3]
    y = range(-3,stop=3,length=128)

    # X, Y = np.meshgrid(x, np.linspace(-3, 3, 128)) # Python
    X = x' .* ones(length(y))
    Y = ones(length(x))' .* y
    Z = @. (1 - X/2 + X^5 + Y^3) * exp(-X^2 - Y^2)

    fig,ax = plt.subplots()

    ax.pcolormesh(X,Y,Z, vmin=-0.5, vmax=1.0)

    savefig("pcolormesh", fig)
end


# https://matplotlib.org/stable/gallery/images_contours_and_fields/pcolormesh_levels.html#basic-pcolormesh
function learn_basic_pcolormesh()
    Random.seed!(19680801)
    
    Z = rand(6,10)
    x = range(-0.5, stop=10, step=1) # Edge of blocks in x-direction
    y = range(4.5, stop=11, step=1)
    
    @test length(x) == 11
    @test length(y) == 7
    @test length(Z) == (length(x)-1) * (length(y)-1)

    fig,ax = plt.subplots()
    ax.pcolormesh(x,y,Z)

    savefig("basic_pcolormesh", fig)
end
# https://matplotlib.org/stable/gallery/images_contours_and_fields/pcolormesh_levels.html#non-rectilinear-pcolormesh
function learn_non_rectilinear_pcolormesh()
    Random.seed!(19680801)
    
    Z = rand(6,10)
    x = range(-0.5, stop=10, step=1) # Edge of blocks in x-direction
    y = range(4.5, stop=11, step=1)

    X, Y = meshgrid(x,y)
    @. X = X + 0.2*Y
    @. Y = Y + 0.3*X

    fig,ax = plt.subplots()
    ax.pcolormesh(X,Y,Z)

    savefig("non_rectilinear_pcolormesh", fig)
end
# https://matplotlib.org/stable/gallery/images_contours_and_fields/pcolormesh_levels.html#centered-coordinates
function learn_centered_coordinates()
    Random.seed!(19680801)
    
    Z = rand(6,10)
    x = 0:9
    y = 0:5
    X,Y = meshgrid(x,y)

    fig,axs = plt.subplots(2,1, sharex=true, sharey=true)

    ax = axs[1]
    ax.pcolormesh(X,Y,Z, shading="auto", vmin=minimum(Z), vmax=maximum(Z))
    ax.set_title("shading=\"auto\"")


    ax = axs[2]
    ax.pcolormesh(X,Y,Z[1:end-1,1:end-1], shading="flat", vmin=minimum(Z), vmax=maximum(Z))
    # ax.pcolormesh(X,Y,Z, shading="flat") # ERROR
    ax.set_title("shading=\"flat\"")

    # fig.subplots_adjust(top=0.92, bottom=0.08, left=0.10, right=0.95,
    #     hspace=0.25, wspace=0.35
    # )
    fig.subplots_adjust(hspace=0.25)

    savefig("centered_coordinates", fig)

end
# https://matplotlib.org/stable/gallery/images_contours_and_fields/pcolormesh_levels.html#making-levels-using-norms
function learn_making_levels_using_norms()
    dx = 0.05
    dy = 0.05
    x = range(1, stop=5, step=dx)
    y = range(1, stop=5, step=dy)
    X,Y = meshgrid(x,y)
    Z = @. sin(X)^10 + cos(10 + Y*X) * cos(X)

    Z = Z[1:end-1,1:end-1]
    levels = plt.matplotlib.ticker.MaxNLocator(nbins=15).tick_values(minimum(Z), maximum(Z))
    
    cmap = plt.matplotlib.cm.get_cmap("PiYG")
    norm = plt.matplotlib.colors.BoundaryNorm(levels, ncolors=cmap.N, clip=true)

    fig,axs = plt.subplots(2,1)

    ax = axs[1]
    im = ax.pcolormesh(X,Y,Z, cmap=cmap, norm=norm) # QuadMesh
    fig.colorbar(im, ax=ax)
    ax.set_title("pcolormesh with levels")

    
    ax = axs[2]
    cf = ax.contourf(
        X[1:end-1,1:end-1].+dx/2,
        Y[1:end-1,1:end-1].+dy/2,
        Z, levels=levels, cmap=cmap
    )
    fig.colorbar(cf, ax=ax)
    ax.set_title("contourf with levels")

    fig.tight_layout()

    savefig("making_levels_using_norms", fig)
end


# https://matplotlib.org/stable/tutorials/intermediate/color_cycle.html#styling-with-cycler
function learn_styling_with_cycler()
    x = range(0, stop=2*π, length=50) #  np.linspace(0, 2 * np.pi, 50)
    x_offsets = range(0, stop=2*π, length=5)[1:end-1] # np.linspace(0, 2 * np.pi, 4, endpoint=False)
    ys = [@. sin(x + phi) for phi in x_offsets]
    
    # Cycler
    rgby_cycler = (
        plt.matplotlib.cycler(color=["r", "g", "b", "y"]) + 
        plt.matplotlib.cycler(linestyle=["-", "--", ":", "-."])
    )
    cmyk_cycler = (
        plt.matplotlib.cycler(color=["c", "m", "y", "k"]) +
        plt.matplotlib.cycler(lw=[1,2,3,4])
    )
    # Global default
    plt.rc("lines", linewidth=4)
    plt.rc("axes", prop_cycle=rgby_cycler)

    fig,axs = plt.subplots(2,1)
    ax = axs[1]
    ax.set_title("Set default color cycle to rgby")
    objs = [ax.plot(x,y) for y in ys]
    #@show typeof(objs)    # vector of vector of matplotlib.lines.Line2D
    #@show typeof(objs[1]) # first line, vector of matplotlib.lines.Line2D
    #@show pytypeof(objs[1][1]) # matplotlib.lines.Line2D
    
    # for y in ys
    #     ax.plot(x,y)
    # end

    ax = axs[2]
    ax.set_title("Set axes color cycle to cmyk")
    ax.set_prop_cycle(cmyk_cycler)
    objs = [ax.plot(x,y) for y in ys]

    fig.tight_layout()

    savefig("styling_with_cycler", fig)
end
# https://matplotlib.org/stable/tutorials/intermediate/color_cycle.html#cycling-through-multiple-properties
function learn_cycling_through_multiple_properties()
    
    # Add
    cc = (
        plt.matplotlib.cycler(color=split("rgb","")) # list('rgb')
        +
        plt.matplotlib.cycler(linestyle=["-", "--", "-."])
    )
    @test length(cc) == 3
    for d in cc
        #println(d)
        # Dict{Any, Any}("linestyle" => "-", "color" => "r")
        # Dict{Any, Any}("linestyle" => "--", "color" => "g")
        # Dict{Any, Any}("linestyle" => "-.", "color" => "b")
        @test d isa Dict
    end

    # Multiple
    cc = (
        plt.matplotlib.cycler(color=split("rgb","")) # list('rgb')
        *
        plt.matplotlib.cycler(linestyle=["-", "--", "-."])
    )
    @test length(cc) == 9
    for d in cc
        #println(d)
        # Dict{Any, Any}("linestyle" => "-", "color" => "r")
        # Dict{Any, Any}("linestyle" => "--", "color" => "r")
        # Dict{Any, Any}("linestyle" => "-.", "color" => "r")
        # Dict{Any, Any}("linestyle" => "-", "color" => "g")
        # Dict{Any, Any}("linestyle" => "--", "color" => "g")
        # Dict{Any, Any}("linestyle" => "-.", "color" => "g")
        # Dict{Any, Any}("linestyle" => "-", "color" => "b")
        # Dict{Any, Any}("linestyle" => "--", "color" => "b")
        # Dict{Any, Any}("linestyle" => "-.", "color" => "b")
        @test d isa Dict
    end
end
# https://matplotlib.org/stable/tutorials/colors/colorbar_only.html#basic-continuous-colorbar
function learn_basic_continuous_colorbar()
    fig,ax = plt.subplots(figsize=(6,1))
    fig.subplots_adjust(bottom=0.5)
    
    cmap = plt.matplotlib.cm.cool
    norm = plt.matplotlib.colors.Normalize(vmin=5, vmax=10)

    bar = fig.colorbar(plt.matplotlib.cm.ScalarMappable(norm=norm, cmap=cmap),
                cax=ax, orientation="horizontal", label="Some Units")
    # @show bar
    # @show pytypeof(bar)
    savefig("basic_continuous_colorbar", fig)
end
# My own stuff
function learn_get_all_colormaps()
    @show plt.matplotlib.colormaps()
end
# https://matplotlib.org/stable/tutorials/colors/colorbar_only.html#extended-colorbar-with-continuous-colorscale
function learn_extended_colorbar_with_continuous_colorscale()
    fig,ax = plt.subplots(figsize=(6,1))
    fig.subplots_adjust(bottom=0.5)

    cmap = mpl.cm.get_cmap("viridis")
    bounds = [-1, 2, 5, 7, 12, 15]
    norm = mpl.colors.BoundaryNorm(bounds, cmap.N, extend="both")
    mappable = mpl.cm.ScalarMappable(norm=norm, cmap=cmap)
    fig.colorbar(
        mappable, cax=ax, orientation="horizontal",
        label="Discrete intervals with extend='both'"
    )

    savefig("extended_colorbar_with_continuous_colorscale", fig)
end
# https://matplotlib.org/stable/tutorials/colors/colorbar_only.html#discrete-intervals-colorbar
function learn_discrete_intervals_colorbar()
    fig,ax = plt.subplots(figsize=(6,1))

    cmap = mpl.colors.ListedColormap([
        (0,144,204,255)   ./ 255, # teal
        (161,161,255,255) ./ 255, # light purple
        (144,0,204,255)   ./ 255, # purple
        (255,161,255,255) ./ 255, # pink
    ])
    cmap = cmap.with_extremes(under="0.75", over="0.25")

    bounds = [1,2,4,7,8]
    norm = mpl.colors.BoundaryNorm(bounds, cmap.N)
    mappable = mpl.cm.ScalarMappable(norm=norm, cmap=cmap)
    fig.colorbar(
        mappable, cax=ax, orientation="horizontal",
        boundaries = [0, bounds..., 13],
        extend="both",
        ticks=bounds,
        spacing="proportional",
        label="Discrete intervals"
    )

    fig.tight_layout()

    savefig("discrete_intervals_colorbar", fig)
end
# https://matplotlib.org/stable/tutorials/colors/colorbar_only.html#colorbar-with-custom-extension-lengths
function learn_colorbar_with_custom_extension_lengths()
    fig,ax = plt.subplots(figsize=(6,1))
    
    cmap = mpl.colors.ListedColormap(["royalblue", "cyan", "yellow", "orange"])
    cmap = cmap.with_extremes(under="blue", over="red")

    bounds = [-1, -0.7, 0.3, 0.5, 1]
    norm = mpl.colors.BoundaryNorm(bounds, cmap.N)
    mappable = mpl.cm.ScalarMappable(norm, cmap)
    fig.colorbar(
        mappable, cax=ax, orientation="horizontal",
        boundaries=[-10, bounds..., 10],
        extend="both",
        extendfrac="auto",
        spacing="proportional",
        label="Custom extension lengths",
    )


    fig.tight_layout()
    savefig("colorbar_with_custom_extension_lengths", fig)
end
# https://matplotlib.org/stable/tutorials/colors/colormap-manipulation.html#getting-colormaps-and-accessing-their-values
function learn_getting_colormaps_and_accessing_their_values()
    cm = plt.matplotlib.cm
    
    viridis = cm.get_cmap("viridis", 8) # @doc plt.matplotlib.cm.get_cmap
    # viridis is a callable, and param is between 0 - 1
    # @show viridis(0.56) # (0.122312, 0.633153, 0.530398, 1.0)

    # ListedColormap
    # @show viridis.colors

    # Same results
    # @show viridis(range(0,stop=7)) # Python: range(8)
    # @show viridis(range(0,stop=1, length=8)) # Python: range(8)

    #pager(viridis(range(0,stop=1, length=12))) # Repeated colors
    

    # LinearSegmentedColormap
    copper = cm.get_cmap("copper", 8)
    #pager(copper(range(0,stop=7)))
end

function plot_examples(colormaps)
    Random.seed!(19680801)
    rng = Normal()
    data = rand(rng, 30, 30)    
    #pager(data)
    # 1 ax for each colormap
    n = length(colormaps)
    fig,axs = plt.subplots(1, n, figsize=(n*2+2,3), 
        constrained_layout=true, 
        squeeze=false)
    #plt.setp(fig, layout="constrained")
    #fig.layout = "constrained"
    #fig.constrained_layout = true
    #pager(@doc plt.subplots)
    for (ax,cmap) in zip(axs, colormaps)
        psm = ax.pcolormesh(data, cmap=cmap, rasterized=true, vmin=-4, vmax=4)
        fig.colorbar(psm, ax=ax)
    end

    return fig,axs
end

function learn_creating_listed_colormaps()
    cm = plt.matplotlib.cm
    ListedColormap = plt.matplotlib.colors.ListedColormap

    # one plot
    cmap = plt.matplotlib.colors.ListedColormap(["darkorange", "gold","lawngreen", "lightseagreen"])
    fig,_ = plot_examples([cmap])
    savefig("creating_listed_colormaps_1", fig)

    # Pink color
    viridis = cm.get_cmap("viridis", 256)
    pink = [248,24,148,256] ./ 256
    newcolors = viridis(range(0, stop=1, length=256))
    newcolors[1:50,:] .= pink'
    newcmp = plt.matplotlib.colors.ListedColormap(newcolors)
    fig,_ = plot_examples([viridis, newcmp])
    savefig("creating_listed_colormaps_2", fig)

    # Reduced viridis
    viridis_big = cm.get_cmap("viridis") # length?
    newcmp = ListedColormap(viridis_big(range(0.25, stop=0.75, length=128)))
    fig,_ = plot_examples([viridis, newcmp])
    savefig("creating_listed_colormaps_3", fig)
    
    # Concatenate colormaps
end


function plot_color_gradients(category, cmaps)
    # Create figure and adjust figure height to number of colormaps
    nrows = length(cmaps)
    figh = 0.35 + 0.15 + (nrows + (nrows-1)*0.1) * 0.22
    fig,axs = plt.subplots(nrows+1, figsize=(6.4, figh)) # +1 for the title
    fig.subplots_adjust(top=1-0.35/figh, bottom=0.15/figh, left=0.2, right=0.99)

    ax = axs[1]
    ax.set_title("$category colormaps", fontsize=14)

    gradient = range(0, stop=1, length=256)
    gradient = vcat(gradient',gradient')
    #@show gradient
    for (ax,name) in zip(axs,cmaps)
        ax.imshow(gradient, aspect="auto", cmap=plt.get_cmap(name))
        ax.text(-0.01,0.5, name, va="center", ha="right", fontsize=10,
        transform=ax.transAxes)
    end

    for ax in axs
        ax.set_axis_off()
    end

    return fig,axs
end

function learn_colormaps_sequential()
    # conda install colorspacious
    # cm = pyimport("matplotlib.cm") # module
    # cs = pyimport("colorspacious") # module

    fig,_ = plot_color_gradients(
        "Perceptually Uniform Sequential",
        ["viridis", "plasma", "inferno", "magma", "cividis"]
    )
    savefig("colormaps_sequential_1", fig)

    fig,_ = plot_color_gradients(
        "Sequential",
        [
            "Greys", "Purples", "Blues", "Greens", "Oranges", "Reds",
            "YlOrBr", "YlOrRd", "OrRd", "PuRd", "RdPu", "BuPu",
            "GnBu", "PuBu", "YlGnBu", "PuBuGn", "BuGn", "YlGn"
        ]
    )
    savefig("colormaps_sequential_1_1", fig)

    fig,_ = plot_color_gradients(
        "Sequential 2",
        [
            "binary", "gist_yarg", "gist_gray", "gray", "bone",
            "pink",
            "spring", "summer", "autumn", "winter",
            "cool", "Wistia", "hot", "afmhot", "gist_heat", "copper"
        ]
    )
    savefig("colormaps_sequential_2", fig)
end

function learn_colormaps_diverging()
    # fig,_ = plot_color_gradients(
    #     "Diverging",
        
    # )
end
function learn_colormaps_cyclic()
end
function learn_colormaps_qualitative()
end
function learn_colormaps_miscellaneous()
end



begin # Deprecated
    # Plot interface
    # Use OO interface instead

    # https://github.com/JuliaPy/PyPlot.jl
    function learn_basic_usage()
        # use x = linspace(0,2*pi,1000) in Julia 0.6
        x = range(0; stop=2*pi, length=1000)
        y = sin.(3 * x + 4 * cos.(2 * x))
        plt.plot(x, y, color="red", linewidth=2.0, linestyle="--")
        plt.title("A sinusoidally modulated sinusoid")
    end


    # https://matplotlib.org/stable/tutorials/introductory/pyplot.html
    function learn_intro_to_pyplot_1()
        plt.clf() # clear figure, cla(), close()
        # x data are [0, 1, 2, 3]
        plt.plot([1, 2, 3, 4])
        plt.ylabel("Some numbers")
        plt.show()

        # https://stackoverflow.com/questions/6916978/how-do-i-tell-matplotlib-to-create-a-second-new-plot-then-later-plot-on-the-o
    end
    function learn_intro_to_pyplot_2()
        plt.clf() # clear figure, cla(), close()
        plt.plot([1, 2, 3, 4], [1, 4, 9, 16]) # "b-"
        plt.show()
    end
    function learn_intro_to_pyplot_3()
        plt.clf() # clear figure, cla(), close()
        plt.plot([1, 2, 3, 4], [1, 4, 9, 16], "ro")
        plt.axis([0, 6, 0, 20])
        plt.show()
    end

    function learn_intro_to_pyplot_4()
        plt.clf() # clear figure, cla(), close()
        t = range(0, step=0.2, stop=5)
        @show t
        plt.plot(
            t, t, "r--", 
            t, t.^2, "bs",
            t, t.^3, "g^"
        )
        plt.show()
    end

    function learn_intro_to_pyplot_5()
        plt.clf() # clear figure, cla(), close()
        data = Dict(
            "a" => range(0,length=50),
            "c" => rand(0:50, 50),
            "d" => randn(50),
        )
        data["b"] = data["a"] + 10 * randn(50)
        data["d"] = abs.(data["d"]) .* 100

        plt.scatter("a", "b", c="c", s="d", data=data)
        plt.xlabel("entry a")
        plt.ylabel("entry b")
        plt.show()
    end

end

if false
    # # The object-oriented interface and the pyplot interface
    learn_oo_style()

    ## Usage Guide
    ## https://matplotlib.org/stable/tutorials/introductory/usage.html
    learn_a_simple_example()

    ## Pyplot tutorial 
    ## https://matplotlib.org/stable/tutorials/introductory/pyplot.html
    learn_intro_to_pyplot()
    learn_formatting_the_style_of_your_plot()
    learn_plotting_with_keyword_strings()
    learn_plotting_with_categorical_variables()
    learn_controlling_line_properties()
    learn_axes_step()
    learn_working_with_multiple_figures_and_axes()
    learn_working_with_text()
    learn_annotating_text()
    learn_logarithmic_and_other_nonlinear_axes()

    ## Plot types
    ## https://matplotlib.org/stable/plot_types/index.html
    learn_pcolormesh()

    ## Examples
    ## https://matplotlib.org/stable/gallery/index.html
    learn_basic_pcolormesh()
    learn_non_rectilinear_pcolormesh()
    learn_centered_coordinates()
    learn_making_levels_using_norms()


    ## Tutorials
    ## https://matplotlib.org/stable/tutorials/index.html
    # Styling with cycler
    learn_styling_with_cycler()
    learn_cycling_through_multiple_properties()
    # Customized Colorbars Tutorial
    learn_basic_continuous_colorbar()
    learn_get_all_colormaps()
    learn_extended_colorbar_with_continuous_colorscale()
    learn_discrete_intervals_colorbar()
    learn_colorbar_with_custom_extension_lengths()
    # Creating Colormaps in Matplotlib
    learn_getting_colormaps_and_accessing_their_values()
    learn_creating_listed_colormaps()
    # Choosing Colormaps in Matplotlib
    learn_colormaps_sequential()
    # TODO: Not complete
    learn_colormaps_diverging()
    learn_colormaps_cyclic()
    learn_colormaps_qualitative()
    learn_colormaps_miscellaneous()
    
end


learn_creating_listed_colormaps()


learn_colormaps_diverging()
learn_colormaps_cyclic()
learn_colormaps_qualitative()
learn_colormaps_miscellaneous()

end
nothing


## https://matplotlib.org/stable/tutorials/introductory/pyplot.html#
# Use OO interface instead of pyplot interface
#learn_basic_usage()
#learn_intro_to_pyplot_1()
#learn_intro_to_pyplot_2()
#learn_intro_to_pyplot_3()
#learn_intro_to_pyplot_4()
#learn_intro_to_pyplot_5()
