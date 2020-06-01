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
end
addpackage() # Do this only once
