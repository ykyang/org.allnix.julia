using Plots
gr
x = 1:10
y = rand(10)
plot(x,y)

y = rand(10,2)
plot(x,y)

z = rand(10)
plot!(x,z)

p = plot(x,y)
z = rand(10)
plot!(p, x, z)

# NG
# plot!(p, linewidth = 10, label = ["L1", "L2"], title="Two Lines")

# -----------
# Attribute
# -----------
p = plot(x, y, linewidth = 5, label = ["L1" "L2"], title="Two Lines")
xlabel!(p, "X")
attribute!(p, linewidth = 1)

# plotattr()
# plotattr(:Axis)
# plotattr(:Subplot)
# plotattr(:Series)
# plotattr(:Plot)
# plotattr("linewidth")
# plotattr("seriestype")
plot(x,y, seriestype=:scatter)
scatter(x,y)

# --------
# Layout
# --------
y = rand(10,4)
plot(x,y, layout=(4,1))

p1 = plot(x,y)
p2 = scatter(x,y)
p3 = plot(x,y, xlabel = "Labelled", lw = 3, title = "Subtitle")
p4 = histogram(x, y)
plot(p1, p2, p3, p4, layout = (2,2), legend = false)

# -----------------------------------
# Plot Recipes and Recipe Libraries
# http://docs.juliaplots.org/latest/tutorial/#Plot-Recipes-and-Recipe-Libraries-1
# -----------------------------------
using StatsPlots
using DataFrames
df = DataFrame(a = 1:10, b = 10*rand(10), c = 10*rand(10))
@df df plot(:a, [:b :c])
@df df scatter(:a, :b, title = "DataFrame Scatter Plot!")

using Distributions
plot(Normal(3,5), lw = 3)

using RDatasets
iris = dataset("datasets", "iris")
@df iris marginalhist(:PetalLength, :PetalWidth)
