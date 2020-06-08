# Run this file to add packages to Project.toml

using Pkg

"""
    addpackage()

Install required packages
"""
function addpackage()
    Pkg.add("BenchmarkTools") # adds DataFrames and DelimitedFiles
    Pkg.add("CSV")
    Pkg.add("XLSX")
    Pkg.add("JLD")
    Pkg.add("NPZ")
    Pkg.add("RData")
    Pkg.add("MAT")
    Pkg.add("Images")
    Pkg.add("ImageMagick")
    Pkg.add("DataFrames")
    # Statistics
    Pkg.add("Statistics")
    Pkg.add("StatsBase")
    Pkg.add("RDatasets")
    Pkg.add("Plots")
    Pkg.add("Plotly")
    Pkg.add("StatsPlots")
    Pkg.add("KernelDensity")
    Pkg.add("Distributions")
    Pkg.add("HypothesisTests")
    Pkg.add("PyCall")
    Pkg.add("MLBase")
    # Dimensionality Reduction
    Pkg.add("UMAP")
    Pkg.add("Makie")
    Pkg.add("VegaDatasets")
    Pkg.add("MultivariateStats")
    Pkg.add("ScikitLearn")
    Pkg.add("Distances")
end
addpackage() # Do this only once
