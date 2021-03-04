# Use version 1.5.3 and run in command line
# julia --project=@. learn_Dash.jl
# this will enable hot loading, meaning the server refresh the page if learn_Dash.jl
# was updated.
# 
# Run in interactive mode is fine by
# include("learn_Dash.jl")
# but needs to shutdown and restart the server every time the file updated.

# https://dash-julia.plotly.com
# add Dash DashCoreComponents DashHtmlComponents DashTable
using Dash, DashHtmlComponents, DashCoreComponents

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
                layout = (title = "Dash Data Visualization", barmode="group")
            )
        )
        
        return (h1, d, dcc)
        #return (d, dcc)
    end

    run_server(app, "0.0.0.0", debug=true)
end

hello_dash()
