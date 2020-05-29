# https://github.com/JuliaAcademy/DataScience/blob/master/01.%20Data.ipynb
using BenchmarkTools
using DataFrames
using DelimitedFiles
using CSV
using XLSX

P = download("https://raw.githubusercontent.com/nassarhuda/easy_data/master/programming_languages.csv",
    "programminglanguages.csv")
