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

# https://dash-julia.plotly.com/getting-started
using Dash, DashHtmlComponents, DashCoreComponents
using DataFrames, CSV, HTTP
using PlotlyJS #, RDatasets


# https://dash-julia.plotly.com/getting-started

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

function dash_plotly()
    #iris = dataset("datasets", "iris")
    url = "https://raw.githubusercontent.com/vincentarelbundock/Rdatasets/master/csv/datasets/iris.csv"
    body = HTTP.get(url).body
    @info typeof(body)
    csv = CSV.File(body)
    @info typeof(csv)
    iris = DataFrame(csv)
    #@show iris
    pl = Plot(
        iris, x=Symbol("Sepal.Length"), y=Symbol("Sepal.Width"), mode="markers",
        marker_size=8, group=:Species
    )

    app = dash(external_stylesheets = ["https://codepen.io/chriddyp/pen/bWLwgP.css"])

    app.layout = html_div() do
        html_h4("Iris Sepal Length vs Sepal Width"),
        dcc_graph(
            id = "example-graph-3",
            figure = pl,
        )
    end

    run_server(app, "0.0.0.0", debug=true)
end

function dash_markdown()
    app = dash(external_stylesheets = ["https://codepen.io/chriddyp/pen/bWLwgP.css"])
    
    markdown_text = """
    ### Dash and Markdown

    Dash apps can be written in Markdown.
    Dash uses the [CommonMark](http://commonmark.org/)
    specification of Markdown.
    Check out their [60 Second Markdown Tutorial](http://commonmark.org/help/)
    if this is your first introduction to Markdown!

    """

    app.layout = html_div() do
        dcc_markdown(markdown_text)
    end

    run_server(app, "0.0.0.0", debug=true)
end

function dash_core()
    app = dash(external_stylesheets = ["https://codepen.io/chriddyp/pen/bWLwgP.css"])

    dropdown_options = [
        Dict("label" => "New York City", "value" => "NYC"),
        Dict("label" => "Montreal", "value" => "MTL"),
        Dict("label" => "San Francisco", "value" => "SF"),
    ]
    app.layout = html_div(style = Dict("columnCount" => 2)) do
        html_label("Dropdown"),
        dcc_dropdown(options = dropdown_options, value = "MTL"),
        html_label("Multi-Select Dropdown"),
        dcc_dropdown(
            options = dropdown_options,
            value = ["MTL", "SF"],
            multi = true,
        ),
        html_label("Radio Items"),
        dcc_radioitems(options = dropdown_options, value = "MTL"),
        html_label("Checkboxes"),
        dcc_checklist(options = dropdown_options, value = ["MTL", "SF"]),
        html_label("Text Input"),
        dcc_input(value = "MTL", type = "text"),
        html_label("Slider"),
        dcc_slider(
            min = 0,
            max = 9,
            marks = Dict([i => (i == 1 ? "Label $(i)" : "$(i)") for i = 1:6]),
            value = 5,
        )
    end
    
    run_server(app, "0.0.0.0", debug = true)
end


# https://dash-julia.plotly.com/getting-started
#hello_dash()
#dash_table()
dash_plotly() # RDatasets does not work
#dash_markdown()
#dash_core()
