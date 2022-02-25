import DSP
import PlotlyJS
using Random
import PyPlot as plt


pjs = PlotlyJS

"""

[Smooth nosiy](http://www.simulkade.com/posts/2015-05-07-how-to-smoothen-noisy-data.html)
"""
function learn_smooth(;method=1)

    x = range(0, stop=4π, length=80)
   
    y_real  = sin.(x)
    y_noisy = @. sin(x) + 0.8*(rand() - 0.5)  # rand -> 0 - 1
    @show size(y_noisy)
    # t1 = [
    #     "x" => x,
    #     "y" => y_real,
    #     "type" => "scatter"
    # ]
    t1 = pjs.scatter(x=x, y=y_real, name="Sine", mode="line")
    t2 = pjs.scatter(x = x, y = y_noisy, name="Noisy", mode="line")
    
    layout = pjs.Layout(title="Sine", showlegend=true)
    

    win_len = 8
    if iseven(win_len)
        win_len += 1
    end
    #@show y_real
    y = y_noisy
    #@show reverse(y[1:win_len],1)
    w = ones(win_len)
    #if method == 1
        y_new = [2*y[1] .- reverse(y[1:win_len],1); y[:]; 2*y[end].-reverse(y[end-win_len:end],1)]
        @show size(y_new)
        ind = floor(Int, 1.5*win_len)
        @show floor(Int, 1.5*win_len)
        y_smooth = DSP.conv(y_new, w/sum(w))
        @show size(y_smooth)
        @show size(y_smooth[1+ind:end-ind-1])
        y = y_smooth[1+ind:end-ind-1]
        t3 = pjs.scatter(x=x, y=y, name="Smooth 1", mode="markers")
    #elseif method == 2
        y_new = y_noisy   
        @show size(y_new)
        if iseven(win_len)
            ind = Int(win_len/2)
        else
            ind = Int((win_len-1) /2)
        end
        @show(ind)
        y_smooth = DSP.conv(y_new, w/sum(w)) # size = y_new + w -1, see conv source code
        @show size(y_smooth)
        y = y_smooth[win_len-(ind):end-ind]
        @show size(y)
        t4 = pjs.scatter(x=x, y=y, name="Smooth 2", mode="line")
    #end
    #y_new = y_noisy
    
    
    #@show w
    #@show w/sum(w)
    
    
    #@show size(y_new)
    # @show size(y_smooth)
    # @show size(y_smooth[1+ind:end-ind-1])
    #t3 = pjs.scatter(x=x, y=y, name="Smooth", mode="line")
    #t3 = pjs.scatter(x=x, y=y_smooth, name="Smooth", mode="line")
    data = [t1,t2,t3,t4]
    pt = pjs.plot(data, layout)
    

    display(pt)

    nothing
end

function learn_simple()
    Random.seed!(123)
    no_x = 100 # number of points

    x = range(0, stop=4π, length=no_x)

    y_perfect = sin.(x) # y from function
    # 0.1: scaling factor
    # rand()-0.5: positive and negative shift
    y_noise   = @. sin(x) + 0.2*(rand()-0.5) # 0 <= rand() < 1
    #@show y_noise

    win_len = 5 #9 # average window length, odd number please
    w = ones(win_len)
    padding = fld(win_len,2)

    y_smooth = DSP.conv(y_noise, w/sum(w))
    y_smooth = y_smooth[win_len-padding:end-padding]

    fig, ax = plt.subplots()
    ax.plot(x,y_perfect, )
    ax.plot(x,y_noise, marker="o", markersize=2, linestyle="")
    ax.plot(x,y_smooth)

    nothing
end
#learn_smooth(method=2)
learn_simple()

nothing