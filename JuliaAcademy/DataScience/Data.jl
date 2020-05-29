# https://github.com/JuliaAcademy/DataScience/blob/master/01.%20Data.ipynb
using BenchmarkTools
using DataFrames
using DelimitedFiles
using CSV
using XLSX

P = download("https://raw.githubusercontent.com/nassarhuda/easy_data/master/programming_languages.csv",
    "programminglanguages.csv")

# P: body, H: header
P,H = readdlm("programminglanguages.csv", ','; header=true)

# To write to a text file, you can:
writedlm("programminglanguages_dlm.txt", P, '-')
