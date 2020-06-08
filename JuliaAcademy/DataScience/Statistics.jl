import RDatasets # R datasets from GitHub
import DataFrames
import Plots
import StatsPlots
import KernelDensity
import LinearAlgebra
import HypothesisTests
import PyCall
import MLBase

Plots.plotly()

DF = DataFrames

# Get data from RDatasets on GitHub
D = RDatasets.dataset("datasets", "faithful")
@show DF.names(D)
@show DF.describe(D)

# what does ! mean
eruptions = D[!, :Eruptions]
eruptions = D[:, :Eruptions] # same as above?
waittime = D[!, :Waiting]
pt = Plots.scatter(eruptions, label="Eruptions")
Plots.scatter!(pt, waittime, label="Wait time")
Plots.gui()


pt = StatsPlots.boxplot(["Eruption Length"], eruptions, legend=true,
    size=(200,400), whisker_width=1, ylabel="Time")
Plots.gui(pt)

pt = StatsPlots.histogram(eruptions, label="Eruptions")
Plots.gui(pt)


# Kernel density estimates
p = KernelDensity.kde(eruptions)
pt = StatsPlots.histogram(eruptions, label="Eruptions")
Plots.plot!(pt, p.x, p.density .* length(eruptions), linewidth=3, color=2,
    label="KDE Fit")
Plots.gui(pt)

A = [1 6; 2 5; 3 4]
p = KernelDensity.kde(A)
pt = Plots.plot(A[:,1], A[:,2])
Plots.plot!(pt, p.x, p.density , linewidth=3, color=2,
    label="KDE Fit")
Plots.gui(pt)

# Skip
