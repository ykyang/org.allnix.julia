module MyPythonPlot

using PythonCall
import PythonPlot
using Random
using Distributions

plt = PythonPlot.matplotlib.pyplot

function savefig(filename; fmt="png", force=true)
    filepath = joinpath("output", "$(filename).$(fmt)")
    
    if isfile(filepath) && force
        rm(filepath)
    end
    
    plt.savefig(filepath, format=fmt, dpi=144)
end

function savefig(filename, fig; fmt="png", force=true)
    plt.figure(fig)
    savefig(filename, fmt=fmt)
end

function subplots()
    return plt.subplots()
end

"""
    subplots(m,n; nargs...)

Wrap `axs` returned by `plt.subplot(...)` in `PyArray` to make the array
unit-offset.
"""
function subplots(m,n; nargs...)
    fig,axs = plt.subplots(m,n; nargs...)

    return fig, PyArray(axs)
end

# https://matplotlib.org/stable/tutorials/introductory/usage.html#a-simple-example
function learn_a_simple_example()
    #fig, ax = plt.subplots()
    fig, ax = subplots()
    ax.plot([1,2,3,4], [1,4,2,3])

    savefig("a_simple_example", fig)
end


# https://matplotlib.org/stable/tutorials/introductory/pyplot.html#intro-to-pyplot
function learn_intro_to_pyplot()
    #fig,axs = plt.subplots(1,2)
    fig,axs = subplots(1,2)
    # @show pytype(axs) # <py class 'numpy.ndarray'>
    #axs = PyArray(axs)
    ax = axs[1]
    ax.plot([1,2,3,4]) # values for y
    ax.set_ylabel("some numbers")

    ax = axs[2]
    ax.plot([1,2,3,4], [1,2,3,4].^2) # values for y

    savefig("intro_to_pyplot", fig)
end

# https://matplotlib.org/stable/tutorials/introductory/pyplot.html#plotting-with-categorical-variables
function learn_plotting_with_categorical_variables()
    names = ["group_a", "group_b", "group_c"]
    values = [1, 10, 100]

    #fig,axs = plt.subplots(1,3; figsize=(9,3)); axs = PyArray(axs)
    fig,axs = subplots(1,3; figsize=(9,3))
    
    ax = axs[1]
    ax.bar(names, values)

    ax = axs[2]
    ax.scatter(names, values)

    ax = axs[3]
    ax.plot(names, values)

    fig.suptitle("Categorical Plotting")

    savefig("plotting_with_categorical_variables", fig)
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
    #fig,axs = plt.subplots(2,2); axs = PyArray(axs)
    fig,axs = subplots(2,2)

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


#learn_a_simple_example()
end