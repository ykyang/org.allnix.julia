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
display(pt)

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
display(pt)
end

nothing #suppress printing of Main...
