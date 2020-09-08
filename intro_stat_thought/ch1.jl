module ch1

import StatsBase; sb = StatsBase

# Page 4
count = 600_000
sample = [1:6...]

x = sb.sample(sample, count, replace=true)
P = sum(x.==3)/count

@show P

# Page 5
wins = zeros(Int32, 1, count)
wins .= 0
for ind = 1:length(wins)
    d = sb.sample(sample, 2)
    if sum(d) == 7 || sum(d) == 11
        wins[ind] = 1
    end
end
wins_count = sum(wins)

@show wins_count
@show wins_count/count

# Page 7
# PDF: Probability Density Function
using Plotly
y = [0,1]
p = [1,1]
line = scatter(x=y, y=p, mode="lines") # "lines+markers"
layout = Layout(
    title="PDF",
    # mirror for the bounding box
    xaxis=attr(title="y", linecolor="black", mirror=true),
    yaxis=attr(title="p(y)", range=[0,1.1], linecolor="black", mirror=true)
)
pt = plot([line], layout)
#display(pt)

# Page 10
import RDatasets; rdata = RDatasets
import CSV
import DataFrames; DF = DataFrames
import Distributions; Dist=Distributions
#using StringEncodings

if !isfile("discoveries.csv")
    download("https://raw.githubusercontent.com/vincentarelbundock/Rdatasets/master/csv/datasets/discoveries.csv",
    "discoveries.csv")
end
#med = rdata.dataset("datasets", "discoveries")
# frame = df.DataFrame()
#frame = CSV.read("discoveries.csv", df)
df = CSV.File(open(read, "discoveries.csv")) |> DF.DataFrame
@show names(df)
#@show frame

# Histogram
hist = histogram(x=df.value, histnorm="probability")
# Poisson distribution
d = Dist.Poisson(3.1)
x = range(0,12,length=13)
line = scatter(x=x,y=Dist.pdf.(d,x))
# Plot
layout = Layout(title="Discoveries")
pt = plot([hist, line], layout)
#display(pt)


# 1.3.1 The Binomial Distribution

# Page 14
# θ is a parameter
# Θ is set of θ
# Binomial

# Page 16
d = Dist.Binomial(3,0.1)
x = range(0,3,length=4)
scat = scatter(x=x,y=Dist.pdf.(d,x), mode="markers",
    #opacity=0.1
    marker=attr(size=15, opacity=1, color="transparent",
        line=attr(color="black", width=2)
    )
)
layout = Layout(title="N=3, p=0.1")
pt = plot([scat], layout)
#display(pt)
savefig(pt, "binomial.png", format="png")
savefig(pt, "binomial.html", format="html")

scat_list = Vector{AbstractTrace}()
d = Dist.Binomial(3,0.1)
x = range(0,3,length=4)
scat = scatter(x=x,y=Dist.pdf.(d,x), mode="markers",
    #opacity=0.1
    marker=attr(size=15, opacity=1, color="transparent",
        line=attr(color="black", width=2)
    )
)
push!(scat_list,scat)


d = Dist.Binomial(3,0.5)
scat = scatter(x=x,y=Dist.pdf.(d,x), mode="markers",
    xaxis="x2", yaxis="y2",
    #opacity=0.1
    marker=attr(size=15, opacity=1, color="transparent",
        line=attr(color="black", width=2)
    )
)
push!(scat_list, scat)
# show how to plot multiple traces in one subplot
line = scatter(x=x, y=Dist.pdf.(d,x), mode="lines",
    xaxis="x2", yaxis="y2",
    line=attr(color="black", width=2)
)
push!(scat_list, line)

d = Dist.Binomial(3,0.9)
scat = scatter(x=x,y=Dist.pdf.(d,x), mode="markers",
    xaxis="x3", yaxis="y3",
    #opacity=0.1
    marker=attr(size=15, opacity=1, color="transparent",
        line=attr(color="black", width=2)
    )
)
push!(scat_list, scat)

x = range(0,30,length=31)
d = Dist.Binomial(30,0.1)
scat = scatter(x=x,y=Dist.pdf.(d,x), mode="markers",
    xaxis="x4", yaxis="y4",
    #opacity=0.1
    marker=attr(size=10, opacity=1, color="transparent",
        line=attr(color="black", width=2)
    )
)
push!(scat_list, scat)

x = range(0,30,length=31)
d = Dist.Binomial(30,0.5)
scat = scatter(x=x,y=Dist.pdf.(d,x), mode="markers",
    xaxis="x5", yaxis="y5",
    #opacity=0.1
    marker=attr(size=10, opacity=1, color="transparent",
        line=attr(color="black", width=2)
    )
)
push!(scat_list, scat)

x = range(0,30,length=31)
d = Dist.Binomial(30,0.9)
scat = scatter(x=x,y=Dist.pdf.(d,x), mode="markers",
    xaxis="x6", yaxis="y6",
    #opacity=0.1
    marker=attr(size=10, opacity=1, color="transparent",
        line=attr(color="black", width=2)
    )
)
push!(scat_list, scat)

layout = Layout(title="N=3, p=0.1",
    grid=attr(rows=2, columns=3, pattern="independent")
    #yaxis2=attr(range=[0,0.4])
    )
pt = plot(scat_list, layout)
#display(pt)

# Example 1.3, page 15
# The hard way
# P[X=k | theta] = binomial(N,k) * theta^k * (1-theta)^(N-k)
# P[X >= 1] =
Ans = 0.0
theta = 2/9
N = 4
for ind = 1:N
    global Ans
    P = binomial(N,ind) * theta^ind * (1-theta)^(N-ind)
    Ans += P
end
println("Example 1.3, Ans = $Ans")

# The easy way
dist = Dist.Binomial(4,2/9)
Ans = 1 - Dist.cdf(dist,0)
println("Example 1.3, Ans = $Ans")

# 1.3.2 The Poisson Distribution
x = range(0,20,length=21)
d = Dist.Poisson(4.5)
scat = scatter(x=x,y=Dist.pdf.(d,x), mode="lines"
)
layout = Layout(title="lambda=3")
pt = plot(scat, layout)
display(pt)
end
nothing #suppress printing of Main...
