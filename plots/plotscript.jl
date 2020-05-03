# julia --project=. plotscript.jl
#
# This will take a long time to start so won't
# recommend doing this.
using Plots
gr

x = 1:10
y = rand(10)
p = plot(x,y)
gui()
display(p)
println("Hello World!")
readline()
