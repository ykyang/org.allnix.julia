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

# Download from network
# pl: programming language
pl_csv_filename = download("https://raw.githubusercontent.com/nassarhuda/easy_data/master/programming_languages.csv",
     "programming_languages.csv")
# This style save to a tmp file
#filename = download("https://raw.githubusercontent.com/nassarhuda/easy_data/master/programming_languages.csv")

# Read into arrays
# Body, Header
pl_body, pl_header = readdlm(pl_csv_filename, ','; header=true)

# Write to a text file with "-" as delimiter
writedlm("programming_languages_dlm.txt", pl_body, "-")

# CSV.jl
pl_csv = CSV.read(pl_csv_filename) # => DataFrame
#show(pl_csv; allrows=true)
@show typeof(pl_csv)
@show describe(pl_csv)
# column names
@show names(pl_csv)
# column
pl_csv.year
pl_csv.language


# Timing
# comment out due to slow execution
#@btime P,H = readdlm("programminglanguages.csv", ','; header=true)
#@btime C = CSV.read("programminglanguages.csv")


# Write CSV from arrays
CSV.write("programming_languages_CSV.csv", pl_csv)


# Notice the dot (.) operator below
# Create DataFrame from arrays
P1 = pl_body[:,1] # => Vector{Any}
P1 = Int64.(P1)   # => Vector{Int64}
P2 = pl_body[:,2] # => Vector{Any}
P2 = String.(P2)  # => Vector{String}
H = pl_header[:]
pl_df = DataFrame([P1, P2], H)
P1 = undef
P2 = undef
H = undef


# Excel file
# Excel file is super slow, convert to CSV
city_xlsx = XLSX.readdata("data/zillow_data_download_april2020.xlsx",
    "Sale_counts_city", # sheet name
    "A1:F9" # cell range
    )

# Does not work
# G,L = XLSX.readdata("zillow_data_download_april2020.xlsx",
#     "Sale_counts_city")
    #"A1:ER28760")


# Much faster
city_csv = CSV.read("zillow_data_download_april2020.csv")


# Build DataFrame from arrays
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

# Julia
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
    println("Array version")
    filter = P[:,2] .== language
    ind = findfirst(filter)
    if isnothing(ind)
        throw(MissingException("Language not found: $language"))
    end
    #println("loc = $loc")
    return P[ind,1]
end
year_created(pl_body, "Julia")
#year_created(P, "not exist")

function year_created(df::DataFrame, language::String)
    println("DataFrame version")
    loc = findfirst(df.language .== language)

    if isnothing(loc)
        e = MissingException("Language not found: $language")
        throw(e)
    end

    return df.year[loc]
end
year_created(pl_df, "Julia")
#year_created(pl_df, "W#")


function count_by_year(df::DataFrame, year::Int64)
    found_vec = findall(df.year .== year) # => Array{Int64,1}
    yearcount = length(found_vec)

    return yearcount
end
count_by_year(pl_df, 2011)


# Dict with Any type
D = Dict([("A", 1), ("B", 2), (1,[1,2])])

# Dict with types
pl_dic = Dict{Integer, Vector{String}}()
# Populate pl_dic
for i = 1:nrow(pl_df)
    #size(pl_df,1)
    #nrow(pl_df)
    year,lang = pl_df[i,:]
    if haskey(pl_dic, year)
        vec = pl_dic[year]
        push!(vec, lang)
    else
        pl_dic[year] = [lang]
    end
end


# dropmissing
