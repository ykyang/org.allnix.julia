using DataFrames
#using UrlDownload
using CSV, HTTP

function learn_download()
    url = "https://raw.githubusercontent.com/Arkoniak/UrlDownload.jl/master/data/ext.csv"
    #csv = urldownload(url) # does not work, complain DataFrame(CSV.File{false}) not exist.
    csv = CSV.File(HTTP.get(url).body)
    df = DataFrame(csv)

    return df
end

function construct_by_push_row()
    df = DataFrame(
            [String, Float64, String],
            ["name", "score", "note"]
    )
    #df[!, "name"] = ["Liam", "Sohpie"]

    push!(df, ["Liam", 8.0, "4.17 below the mean"])
    push!(df, ["Sophie", 8.0, "4.17 below the mean"])
    push!(df, ["Jacob", 12.0, "0.17 below the mean"])

    return df
end

function construct_by_constructor()
    df = DataFrame([
        "name"  => ["Liam", "Sophie", "Jacob"],
        "score" => [8.0, 8.0, 12.0],
        "note"  => ["4.17 below the mean", "4.17 below the mean", "0.17 below the mean"]
    ])

    return df
end
"""

https://stackoverflow.com/questions/51240161/how-to-insert-a-column-in-a-julia-dataframe-at-specific-position-without-referr
"""
function add_a_column()
    df = DataFrame([
        "name"  => ["Liam", "Sophie", "Jacob"],
        "score" => [8.0, 8.0, 12.0],
        
    ])

    insertcols!(
        df, 
        3, 
        "note" => ["4.17 below the mean", "4.17 below the mean", "0.17 below the mean"],
        makeunique = true
    )

    return df
end

function get_a_column()
    df = construct_by_constructor()
    col = df[!,"name"]

    return col
end

#df = learn_download()
#df = construct_by_push_row()
#df = construct_by_constructor()
#df = add_a_column()
col = get_a_column()
