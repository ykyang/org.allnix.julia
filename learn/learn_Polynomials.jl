# Learn Polynomials

using Logging
logger = SimpleLogger(stdout, Logging.Info)
global_logger(logger)

import Polynomials
Poly = Polynomials


poly = Poly.Polynomial([1, 0, 3, 4])
using Plots
plotly()
xs = range(0, 10, length=10)
ys = @. exp(-xs)
f = Poly.fit(xs,ys) # degree = length(xs) - 1
f2 = Poly.fit(xs,ys, 2) # 2
f3 = Poly.fit(xs,ys, 1)

#pt = scatter(xs, ys, markerstrokewidth=0, label="Data")
pt = plot(xs, ys, seriestype=:scatter, markerstrokewidth=0)

plot!(pt, f, extrema(xs)..., label="Fit")
plot!(pt, f2, extrema(xs)..., label="Quadratic Fit")
plot!(pt, f3, extrema(xs)..., label="Linear Fit")

gui(pt)
nothing
