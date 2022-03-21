using ImageFiltering
using Random
using Test
import PyPlot as plt

include("Learn.jl")
using .Learn

"""

Pad both ends of an array to have smoothed end values that are close to the
original end values.
"""
function pad_data(y, win_len)
    return [2*y[1] .- reverse(y[1:win_len],1); y[:]; 2*y[end].-reverse(y[end-win_len:end],1)]
end

"""

Un-pad array after convolution.  The returned array is of the same size as
the original array.  Expect `win_len` to be odd.
"""
function unpad_data(y, win_len)
    pad = win_len + convert(Int64, (win_len-1)/2)
    return y[1+pad:end-pad-1]
end

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

    x = range(π/2, stop=4π-π/2, length=100)

    y_theory = sin.(x) # theoretical values
    # measured values, that is noisy
    y_raw    = @. sin(x) + 0.2*(rand()-0.5) # shift [0,1) to [-0.5,0.5)

    fig,ax = plt.subplots()
    ax.plot(x,y_theory,label="Theory")
    ax.plot(x,y_raw,label="Raw", marker="o", markersize=2, linestyle="")

    # Kernel
    len = 11
    w = centered(ones(Float64,len)./len)
    #showrepl(w)

    #y_flt = imfilter(y_raw, w, Fill(y_raw[1])) # DSP uses this
    #y_flt = imfilter(y_raw, w, "reflect")
    #y_flt = imfilter(y_raw, w, "circular")
    #y_flt = imfilter(y_raw, w, "symmetric")
    #y_flt = imfilter(y_raw, w, "replicate")
    #y_flt = imfilter(pad_data(y_raw,len), w, "replicate")
    y_flt = imfilter(pad_data(y_raw,len), w, "symmetric")
    #@show length(y_flt)
    #y_flt = unpad_data(y_flt,len)
    #@show length(y_flt)
    ax.plot(x,y_flt[1+len:end-len-1], label="Filtered")
    ax.legend()
end

learn_one_dimensional_illustration()
learn_smooth()

nothing