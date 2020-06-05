import RDatasets # R datasets from GitHub
import DataFrames
import Plots

DF = DataFrames

# Get data from RDatasets on GitHub
D = RDatasets.dataset("datasets", "faithful")
@show DF.names(D)
@show DF.describe(D)

# what does ! mean
eruptions = D[!, :Eruptions]
waittime = D[!, :Waiting]
