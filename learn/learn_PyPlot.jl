using PyCall
#pygui(:qt5) # good, default
# pygui(:wx) # crashes
# pygui(:gtk3)
using Random
import PyPlot as plt
#const plt = PyPlot

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

#learn_basic_usage()
#learn_intro_to_pyplot_1()
#learn_intro_to_pyplot_2()
#learn_intro_to_pyplot_3()
#learn_intro_to_pyplot_4()
learn_intro_to_pyplot_5()

nothing
