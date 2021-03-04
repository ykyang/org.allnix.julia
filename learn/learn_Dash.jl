# Use version 1.5.3 and run in command line
#
#   julia --project=@. learn_Dash.jl
#
# this will enable hot reloading, meaning the server refresh the page when
# learn_Dash.jl is updated.
# 
# Run in interactive mode is fine by
#
#   include("learn_Dash.jl")
#
# but needs to shutdown and restart the server every time the file updated.


# https://dash-julia.plotly.com
# add Dash DashCoreComponents DashHtmlComponents DashTable

using Dash, DashHtmlComponents, DashCoreComponents
using DataFrames, CSV, HTTP

function hello_dash()
    app = dash(external_stylesheets = ["https://codepen.io/chriddyp/pen/bWLwgP.css"])

    app.layout = html_div() do
        h1 = html_h1("Hello Dash",
            style = Dict("color" => "#7FDBFF", "textAlign" => "center")
        )
        d = html_div("Dash: A web application")
        dcc = dcc_graph(
            id = "example-graph-1",
            figure = (
                data = [
                    (
                        x = ["giraffes", "orangutans", "monkeys"], 
                        y = [20, 14, 23], type = "bar", name = "SF"
                    ),
                    (
                        x = ["giraffes", "orangutans", "monkeys"],
                        y = [12, 18, 29], type = "bar", name = "Montreal"
                    )
                ],
                layout = (
                    title = "Dash Data Visualization", barmode="group",
                    plot_bgcolor = "#111111",
                    paper_bgcolor = "#114411",
                    font = Dict("color" => "#7FDBFF")
                )
            )
        )
        
        # The original example uses comma to separate the 3 tags, and return
        # the value that way.

        return (h1, d, dcc)
    end

    run_server(app, "0.0.0.0", debug=true)
end

function generate_table(df, max_rows=10)
    t1 = html_table([
        html_thead(html_tr([html_th(col) for col in names(df)])),
        html_tbody([
            html_tr([html_td(df[r,c]) for c in names(df)]) for r = 1:min(nrow(df),max_rows)
        ])
    ])
end

function dash_table()
    url = "https://raw.githubusercontent.com/plotly/datasets/master/2011_us_ag_exports.csv"
    #csv = urldownload("https://raw.githubusercontent.com/plotly/datasets/master/2011_us_ag_exports.csv")
    csv = CSV.File(HTTP.get(url).body)
    @info typeof(csv)
    df = DataFrame(csv)

    #app = dash()
    app = dash(external_stylesheets = ["https://codepen.io/chriddyp/pen/bWLwgP.css"])

    app.layout = html_div() do
        html_h4("US Agriculture Exports (2011)"),
        generate_table(df, 10)
    end

    run_server(app, "0.0.0.0", debug=true)
end



#hello_dash()
dash_table()
