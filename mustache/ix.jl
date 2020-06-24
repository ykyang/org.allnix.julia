using Mustache
using DataFrames
tpl = read("grid.tpl", String)
dic = Dict()
dic["offset"] = 1
dic["nx"] = 9
dic["ny"] = 80
dic["nz"] = 5
dic["dxv"] = [9.518768370414794 2.384362757059747 0.5972606471782251 0.14960822534723633 0.1 0.14960822534723633 0.5972606471782251 2.384362757059747 9.518768370414794]
dic["dyv"] = [40.0 60.0 100.0 100.0 100.0 100.0 100.0 100.0 100.0 100.0 100.0 100.0 100.0 100.0 100.0 100.0 100.0 100.0 100.0 100.0 100.0 100.0 10.0 10.0 10.0 10.0 10.0 10.0 10.0 40.0 60.0 100.0 100.0 100.0 100.0 100.0 100.0 100.0 100.0 100.0 100.0 100.0 100.0 100.0 100.0 100.0 100.0 100.0 100.0 100.0 100.0 10.0 10.0 10.0 10.0 10.0 10.0 10.0 40.0 60.0 100.0 100.0 100.0 100.0 100.0 100.0 100.0 100.0 100.0 100.0 100.0 100.0 100.0 100.0 100.0 100.0 100.0 100.0 100.0 100.0]
dic["dzv"] = string.([50, 50, 100, 50, 50])
dic["tops"] = 9640.0

#view = dic
vview = Dict()
vview["grid"] = dic

open("grid.ixf", "w") do io
    render(io, tpl, vview)
end

#tpl = "{{#:vec}}{{.}}{{^.[end]}}, {{/.[end]}}{{/:vec}}"
#Ans = render(tpl, vec = ["A1", "B2", "C3"])  # "A1, B2, C3"

I1 = [1, 1, 1]
I2 = [9, 9, 9]
J1 = [80, 22, 51]
df = DataFrame(I1 = Int64[], I2=Int64[])
push!(df, [1, 2])
df = DataFrame([Int64, Int64, Int64, Int64, Int64, Int64, String, String, Int64],
["I1", "I2", "J1", "J2", "K1", "K2", "Grid", "Property", "Expression"])
push!(df, [1, 9, 1, 80, 1, 5, "CoarseGrid", "SAT_TAB", 1])
push!(df, [1, 9, 1, 22, 1, 5, "CoarseGrid", "SAT_TAB", 2])

dic = Dict();
dic["rock_region"] = df
tpl = read("rock.tpl", String)
open("rock.ixf", "w") do io
    render(io, tpl, dic)
end
