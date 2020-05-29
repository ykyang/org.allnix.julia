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
end
addpackage() # Do this only once
