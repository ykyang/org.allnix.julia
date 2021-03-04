using DataFrames
using UrlDownload
using CSV, HTTP

function learn_download()
    url = "https://raw.githubusercontent.com/Arkoniak/UrlDownload.jl/master/data/ext.csv"
    #csv = urldownload(url) # does not work, complain DataFrame(CSV.File{false}) not exist.
    csv = CSV.File(HTTP.get(url).body)
    df = DataFrame(csv)

    return df
end

df = learn_download()
