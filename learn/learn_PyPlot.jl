# Learn PyPlot
module MyPyPlot

using PyCall
using Random
using Distributions
import PyPlot as plt

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
    plt.savefig(filepath, format=format)

    return filepath
end

function savefig(filename, fig::plt.Figure)
    plt.figure(fig)

    return savefig(filename)
end


# The object-oriented interface and the pyplot interface
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

learn_oo_style()

## https://matplotlib.org/stable/tutorials/introductory/usage.html
# learn_a_simple_example()
# learn_intro_to_pyplot()
# learn_formatting_the_style_of_your_plot()
# learn_plotting_with_keyword_strings()
# learn_plotting_with_categorical_variables()
# learn_controlling_line_properties()
# learn_axes_step()
# learn_working_with_multiple_figures_and_axes()
# learn_working_with_text()
# learn_annotating_text()
learn_logarithmic_and_other_nonlinear_axes()

## https://matplotlib.org/stable/tutorials/introductory/pyplot.html#
# Use OO interface instead of pyplot interface


#learn_basic_usage()
#learn_intro_to_pyplot_1()
#learn_intro_to_pyplot_2()
#learn_intro_to_pyplot_3()
#learn_intro_to_pyplot_4()
#learn_intro_to_pyplot_5()

end
nothing
