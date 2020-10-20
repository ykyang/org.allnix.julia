# https://raw.githubusercontent.com/sswatson/cheatsheets/master/plotsjl-cheatsheet.pdf

using Logging
logger = SimpleLogger(stdout, Logging.Info)
global_logger(logger)

using Plots
plotly()

using Polynomials

pt = plot(title="Learn how to plot", size=(600,600))
f = Polynomial([0,0,1])
plot!(pt, f, -2, 2)

gui(pt)



nothing
