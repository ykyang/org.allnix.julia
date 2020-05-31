# https://github.com/JuliaAcademy/DataScience/blob/master/01.%20Data.ipynb
using BenchmarkTools
using DataFrames
import DataFrames
DF = DataFrames
using DelimitedFiles
using CSV
using XLSX

import JLD
import NPZ
import RData
import MAT

P = download("https://raw.githubusercontent.com/nassarhuda/easy_data/master/programming_languages.csv",
    "programminglanguages.csv")

# P: body, H: header
P,H = readdlm("programminglanguages.csv", ','; header=true)

# To write to a text file, you can:
writedlm("programminglanguages_dlm.txt", P, '-')

# CSV.jl
C = CSV.read("programminglanguages.csv")
show(C; allrows=true)
@show typeof(C)
describe(C)
# column names
names(C)
# column
C.year
C.language

# timing
#@btime P,H = readdlm("programminglanguages.csv", ','; header=true)
#@btime C = CSV.read("programminglanguages.csv")

# write CSV
df = DataFrame([P[:,1], P[:,2]],H[:])
CSV.write("programminglanguages_CSV.csv", df)
CSV.write("programminglanguages_CSV.csv", C)

# Excel file
# Excel file is super slow, convert to CSV
T = XLSX.readdata("data/zillow_data_download_april2020.xlsx",
    "Sale_counts_city", # sheet name
    "A1:F9" # cell range
    )
# Does not work
# G,L = XLSX.readdata("zillow_data_download_april2020.xlsx",
#     "Sale_counts_city")
    #"A1:ER28760")
G = CSV.read("zillow_data_download_april2020.csv")

# Build my own DataFrame
foodvec = ["apple", "cucumber", "tomato", "banana"]
calorievec = [105, 47, 22, 105]
pricevec = [0.85, 1.6, 0.8, 0.6]
df_calorie = DataFrame([foodvec, calorievec], ["Item", "Calorie"])
df_price = DataFrame(Item=foodvec, Price=pricevec)
# inner join
df = innerjoin(df_calorie, df_price, on="Item")
# Write to Excel file
rm("food.xlsx"; force=true) # remove old file
XLSX.writetable("food.xlsx", collect(eachcol(df)), names(df))

# Read other data format

# JLD
jld_data = JLD.load("data/mytempdata.jld")
JLD.save("mywrite.jld", "A", jld_data)
#jld2 = JLD.load("mywrite.jld")

# Numpy
npz_data = NPZ.npzread("data/mytempdata.npz")
NPZ.npzwrite("mywrite.npz", npz_data)

# R
r_data = RData.load("data/mytempdata.rda")


# Matlab
mat_data = MAT.matread("data/mytempdata.mat")
MAT.matwrite("mywrite.mat", mat_data)

# Time to process the data from Julia
function year_created(P, language::String)
    filter = P[:,2] .== language
    loc = findfirst(filter)
    #println("loc = $loc")
    return P[loc,1]
end
year_created(P, "Julia")
