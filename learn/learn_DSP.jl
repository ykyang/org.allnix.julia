import DSP
import PlotlyJS

pjs = PlotlyJS

"""

[Smooth nosiy](http://www.simulkade.com/posts/2015-05-07-how-to-smoothen-noisy-data.html)
"""
function learn_smooth()

    x = range(0, stop=4π, length=200)
   
    y_real  = sin.(x)
    y_noisy = @. sin(x) + 0.3*(rand() - 0.5)  # rand -> 0 - 1

    # t1 = [
    #     "x" => x,
    #     "y" => y_real,
    #     "type" => "scatter"
    # ]
    t1 = pjs.scatter(x=x, y=y_real, mode="line")
    t2 = pjs.scatter(x = x, y = y_noisy, mode="line")
    data = [t1,t2]
    layout = pjs.Layout(title="Sine", showlegend=true)
    pt = pjs.plot(data, layout)
    # layout = Layout(title="Iris", width=800, height=600)
    # plot = Plot(iris, x=Symbol("Sepal.Length"), y=Symbol("Sepal.Width"), layout,
    #     mode="markers", marker_size=8,
    #     group=:Species
    # )

    display(pt)
    nothing
end

learn_smooth()
