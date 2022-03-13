using ImageFiltering
using Random
import PyPlot as plt

include("Learn.jl")
using .Learn

# Performance
# https://discourse.julialang.org/t/performance-of-offsetarrays/5769/5

# https://juliaimages.org/ImageFiltering.jl/stable/function_reference/
function learn_one_dimensional_illustration()
    f = Int64[0,0,0,1,0,0,0]
    w = centered([1,2,3])

    # See the end of One-dimensional illustration
    #   If `w`` is symmetric, then convolution and correlation give the same outcome.
    correlation = imfilter(f, w, Fill(0,w))
    convolution = imfilter(f, reflect(w), Fill(0,w))
    @test correlation == [0, 0, 3, 2, 1, 0, 0]
    @test convolution == [0, 0, 1, 2, 3, 0, 0]
    nothing
end

function learn_smooth()
    Random.seed!(123)

    x = range(0, stop=4π, length=80)

    y_theory = sin.(x) # theoretical values
    # measured values, that is noisy
    y_raw    = @. sin(x) + 0.8*(rand()-0.5) # shift [0,1) to [-0.5,0.5)

    fig,ax = plt.subplots()
    ax.plot(x,y_theory)
    ax.plot(x,y_raw, marker="o", markersize=2, linestyle="")

    # Kernel
    w = centered(ones(Float64, 5)./5)
    showrepl(w)

    imfilter(y_raw)

end

learn_one_dimensional_illustration()
learn_smooth()

nothing