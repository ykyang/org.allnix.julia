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
import JSON3

# https://dash-julia.plotly.com/getting-started

"""
    dataset(dir, name)

Replace the dataset function from RDatasets.  It stopped working.
"""
function dataset(dir, name)
    url = "https://raw.githubusercontent.com/vincentarelbundock/Rdatasets/master/csv/$(dir)/$(name).csv"
    body = HTTP.get(url).body
    csv = CSV.File(body)
    df = DataFrame(csv)
end

function urldownload(url)
    body = HTTP.get(url).body
    csv = CSV.File(body)
    df = DataFrame(csv)
end

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



"""
    dash_plotly()

Demonstrate simple Plotly plot in Dash.  Use `Layout` to specify figure size.
Use my own `dataset` function to retrieve iris data from R.

[More About Visualization](https://dash-julia.plotly.com/getting-started)
"""
function dash_plotly()
    iris = dataset("datasets", "iris")
    layout = Layout(title="Iris", width=800, height=600)
    
    plt = Plot(
        iris, layout, 
        x=Symbol("Sepal.Length"), y=Symbol("Sepal.Width"), mode="markers",
        marker_size=8, group=:Species, 
    )
    @info typeof(plt)
    @info typeof(plt.layout)
    app = dash(external_stylesheets = ["https://codepen.io/chriddyp/pen/bWLwgP.css"])

    app.layout = html_div() do
        html_h4("Iris Sepal Length vs Sepal Width"),
        dcc_graph(
            id = "example-graph-3",
            figure = plt,
        )
    end

    run_server(app, "0.0.0.0", debug=true)

    return plt
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

"""
    dash_basic_callback()


[Basic Dash Callback](https://dash-julia.plotly.com/basic-callbacks)
"""
function dash_basic_callback()
    app = dash(external_stylesheets = ["https://codepen.io/chriddyp/pen/bWLwgP.css"])

    app.layout = html_div() do
        dcc_input(id = "input-3", value = "initial value",
            type = "text",
        ),
        html_div(id="output-1")
    end
    
    callback!(
        app, 
        Output("output-1", "children"), 
        Input("input-3", "value")) do input_value
        "You have entered $(input_value)"
    end
    
    run_server(app, "0.0.0.0", debug = true)
end

"""

[Dash App Layout With Figure and Slider](https://dash-julia.plotly.com/basic-callbacks)
"""
function dash_layout_figure_slider()
    df1 = DataFrame(urldownload("https://raw.githubusercontent.com/plotly/datasets/master/gapminderDataFiveYear.csv"))
    years = unique(df1[!, :year])
    @show years
    app = dash(external_stylesheets = ["https://codepen.io/chriddyp/pen/bWLwgP.css"])
    app.layout = html_div() do
        dcc_graph(id = "graph-1"),
        dcc_slider(
            id = "year-slider-1",
            min = minimum(years),
            max = maximum(years),
            marks = Dict([Symbol(v) => Symbol(v) for v in years]),
            value = minimum(years),
            step = nothing,
        )
    end

    callback!(
        app,
        Output("graph-1", "figure"),    # figure is an attribute of graph-1 
        Input("year-slider-1", "value") # value is an attribut of year-slider-1
        ) do selected_year
        pt = Plot(
            df1[df1.year .== selected_year, :],
            Layout(
                xaxis_type = "log",
                xaxis_title = "GDP Per Capita",
                yaxis_title = "Life Expectancy",
                legend_x = 0,
                legend_y = 1,
                hovermode = "closest",
                transition_duration = 500
            ),
            x = :gdpPercap,
            y = :lifeExp,
            text = :country,
            group = :continent,
            mode = "markers",
            marker_size = 15,
            marker_line_color = "white"
        )

        return pt
    end

    
    run_server(app, "0.0.0.0", debug=true)
end

"""

[Dash App With Multiple Inputs](https://dash-julia.plotly.com/basic-callbacks)
"""
function dash_app_multiple_inputs()
    df = DataFrame(urldownload("https://raw.githubusercontent.com/plotly/datasets/master/country_indicators.csv"))
    #@show size(df)
    #@show names(df)
    dropmissing!(df)
    #display(df)

    # [!, ] returns a reference rather than a copy
    # https://stackoverflow.com/questions/60900001/what-is-the-meaning-of-the-exclamation-mark-in-indexing-a-julia-dataframe
    available_indicators = unique(df[!, "Indicator Name"])
    years = unique(df[!, "Year"])

    app = dash(external_stylesheets = ["https://codepen.io/chriddyp/pen/bWLwgP.css"])

    app.layout = html_div() do
        div_1 = html_div(
            children = [
                dcc_dropdown(
                    id = "xaxis-column",
                    options = [(label=i, value=i) for i in available_indicators],
                    value = available_indicators[3] #"Fertility rate, total (births per woman)"
                ),
                dcc_radioitems(
                    id = "xaxis-type",
                    options = [(label=v, value=v) for v in ["linear", "log"]],
                    value = "linear"
                )
            ],
            style = (width="48%", display="inline-block")
        )
        div_2 = html_div(
            children=[
                dcc_dropdown(
                    id = "yaxis-column",
                    options = [(label=v, value=v) for v in available_indicators],
                    value = available_indicators[4]
                ),
                dcc_radioitems(
                    id = "yaxis-type",
                    options = [(label = v, value = v) for v in ["linear", "log"]],
                    value = "linear",
                )
            ],
            style = (width="48%", display="inline-block", float = "right")

        )
        graph = dcc_graph(id = "indicator-graphic")
        slider = dcc_slider(
            id = "year-slider-2",
            min = minimum(years), max = maximum(years),
            marks = Dict([Symbol(v) => Symbol(v) for v in years]),
            value = minimum(years),
            step = nothing,
        )

        return div_1,div_2, graph, slider
    end

    callback!(
        app,
        Output("indicator-graphic", "figure"),
        Input("xaxis-column", "value"),
        Input("yaxis-column", "value"),
        Input("xaxis-type", "value"),
        Input("yaxis-type", "value"),
        Input("year-slider-2", "value"),
    ) do xaxis_column_name, yaxis_column_name, xaxis_type, yaxis_type, year_value
        dff = df[df.Year .== year_value, :]

        pt = Plot(
            dff[dff[!, Symbol("Indicator Name")] .== xaxis_column_name, :Value],
            dff[dff[!, Symbol("Indicator Name")] .== yaxis_column_name, :Value],
            Layout(
                xaxis_type = xaxis_type == "linear" ? "linear" : "log",
                xaxis_title = xaxis_column_name,
                yaxis_type = yaxis_type == "linear" ? "linear" : "log",
                yaxis_title = yaxis_column_name,
                hovermode = "closest",
            ),
            kind = "scatter",
            text = dff[
                dff[!, Symbol("Indicator Name")] .== yaxis_column_name,
                Symbol("Country Name")
            ],
            mode = "markers",
            marker_size = 15,
            marker_opacity = 0.5,
            marker_line_width = 1,
            marker_line_color = "white"
        )

        return pt
    end

    run_server(app, "0.0.0.0", debug=true)
end
"""

[Dash App With Multiple Outputs](https://dash-julia.plotly.com/basic-callbacks)
"""
function dash_app_multiple_outputs()
    app = dash(external_stylesheets = ["https://codepen.io/chriddyp/pen/bWLwgP.css"])

    app.layout = html_div() do
        dcc_input(id = "input-1", value = "1", type="text"),
        html_tr( 
            (html_td("x^2 ="), html_td(id="square"))
        ),
        html_tr(
            (html_td("x^3 ="), html_td(id="cube"))
        )
    end    

    callback!(
        app,
        Output("square", "children"),
        Output("cube", "children"),
        Input("input-1", "value")
    ) do x
        @show x
        try
            x = parse(Int64, x)
            return (x^2, x^3)
        catch e
            if isa(e, ArgumentError)
                return ("", "")        
            end

            # unknown error
            @error e
        end

        
    end

    run_server(app, "0.0.0.0", debug=true)
end

function dash_app_chained_callbacks()
    app = dash(external_stylesheets = ["https://codepen.io/chriddyp/pen/bWLwgP.css"])

    all_options = Dict(
        "America" => ["New York City", "San Francisco", "Cincinnati"],
        "Canada"  => ["Montreal", "Toronto", "Ottawa"],
    )
    app.layout = html_div() do
        html_div(
            children = [
                dcc_radioitems(
                    id = "countries-radio",
                    options = [(label = x, value = x) for x in keys(all_options)],
                    value = "America", # keys(all_options)[1]
                ),
                html_hr(),
                dcc_radioitems(id = "cities-radio"),
                html_hr(),
                html_div(id = "display-selected-values"),
            ],
        )
    end

    callback!(
        app,
        Output("cities-radio", "options"),
        Input("countries-radio", "value")
    ) do selected_country
        cities = all_options[selected_country]
        Ans = [(label = x, value = x) for x in cities]

        return Ans
    end
    callback!(
        app,
        Output("cities-radio", "value"),
        Input("cities-radio", "options")
    ) do available_options
        #@show available_options
        #return available_options[1].value
        return available_options[1][:value]
    end

    callback!(
        app,
        Output("display-selected-values", "children"),
        Input("countries-radio", "value"),
        Input("cities-radio", "value"),
    ) do selected_country, selected_city
        if isnothing(selected_city)
            return "No city selected"
        else
            return "$(selected_city) is a city in $(selected_country)"
        end
    end

    run_server(app, "0.0.0.0", debug=true)
end

function dash_app_state()
    app = dash(external_stylesheets = ["https://codepen.io/chriddyp/pen/bWLwgP.css"])
    
    app.layout = html_div() do
        input_1 = dcc_input(id = "input-1-state", type = "text", value = "Montreal")
        input_2 = dcc_input(id = "input-2-state", type = "text", value = "Canada")
        button = html_button(id = "submit-button-state", children = "submit", n_clicks = 0)
        out   = html_div(id = "output-state")
        return input_1, input_2, button, out
    end

    callback!(
        app,
        Output("output-state", "children"),
        Input("submit-button-state", "n_clicks"),
        State("input-1-state", "value"),
        State("input-2-state", "value"),
    ) do clicks, input_1, input_2
        Ans = "The button has been clicked $(clicks) times, inputs are $(input_1) and $(input_2)"

        return Ans
    end

    run_server(app, "0.0.0.0", debug=true)
end

"""
[Interactive Visualizations](https://dash-julia.plotly.com/interactive-graphing)
"""
function dash_intro_visual()
    df = DataFrame(
        x = [1,2,1,2],
        y = [1,2,3,4],
        customdata = [1,2,3,4],
        fruit = ["apple", "apple", "orange", "orange"],
    )

    app = dash(external_stylesheets = ["https://codepen.io/chriddyp/pen/bWLwgP.css"])
    app.layout = html_div() do
        fig = dcc_graph(id = "basic-interactions", figure = (
            data = [
                (
                    x = [1,2,3,4],
                    y = [4,1,3,5],
                    text = ["a", "b", "c", "d"],
                    customdata = ["c.a", "c.b", "c.c", "c.d"],
                    name = "Trace-1",
                    mode = "markers", 
                    marker = (size=12,)
                ),
                (
                    x = [1,2,3,4],
                    y = [9,4,1,4],
                    customdata = ["c.w", "c.x", "c.y", "c.z"],
                    name = "Trace-2", 
                    mode = "markers", 
                    marker = (size=12,)
                )
            ],
            layout = (clickmode = "event+select",)
        ))
        tag = html_div(
            children = [
                html_div(
                    children = [
                        dcc_markdown("
                        **Hover Data**

                        Mouse over values in the graph.
                        "),
                        html_pre(id = "hover-data"),
                    ],
                ),
                html_div(
                    children = [
                        dcc_markdown("
                        **Click Data**

                        Click on points in the graph.
                        "),
                        html_pre(id = "click-data"),
                    ],
                ),
                html_div(
                    children = [
                        dcc_markdown("
                        **Selection Data**

                        Choose the lasso or rectangle tool in the graph's menu
                        bar and then select points in the graph.

                        Note that if `layout.clickmode = 'event+select'`, selection data also
                        accumulates (or un-accumulates) selected data if you hold down the shift
                        button while clicking.
                        "),
                        html_pre(id = "selected-data"),
                    ],
                ),
                html_div(
                    children = [
                        dcc_markdown("
                        **Zoom and Relayout Data**

                        Click and drag on the graph to zoom or click on the zoom
                        buttons in the graph's menu bar.
                        Clicking on legend items will also fire
                        this event.
                        "),
                        html_pre(id = "relayout-data"),
                    ],
                    
                ),
            ]
        )

        return fig, tag
    end

    # Hover
    callback!(
        app,
        Output("hover-data", "children"),
        Input("basic-interactions", "hoverData"),
    ) do hover_data
        @show typeof(hover_data)
        @show hover_data
        
        return JSON3.write(hover_data)
    end
    
    # Click
    callback!(
        app,
        Output("click-data", "children"),
        Input("basic-interactions", "clickData"),
    ) do click_data
        @show click_data

        return JSON3.write(click_data)
    end

    # Select
    callback!(
        app,
        Output("selected-data", "children"),
        Input("basic-interactions", "selectedData"),
    ) do selected_data
        @show selected_data

        return JSON3.write(selected_data)
    end

    # Re-layout
    callback!(
        app,
        Output("relayout-data", "children"),
        Input("basic-interactions", "relayoutData"),
    ) do relayout_data
        @show relayout_data
        return JSON3.write(relayout_data)
    end

    #return df
    run_server(app, "0.0.0.0", debug=true)
end

"""
[Update Graphs on Hover](https://dash-julia.plotly.com/interactive-graphing)
"""
function dash_update_graphs_on_hover()
    df = DataFrame(urldownload("https://raw.githubusercontent.com/plotly/datasets/master/country_indicators.csv"))

    dropmissing!(df)
    #display(df)
    @show names(df)

    available_indicators = unique(df[:, "Indicator Name"])
    years = unique(df[!, "Year"])

    app = dash(external_stylesheets = ["https://codepen.io/chriddyp/pen/bWLwgP.css"])    
    app.layout = html_div() do
        tag_1 = html_div(
            children = [
                html_div( # x
                    children=[
                        dcc_dropdown( # x-column
                            id = "crossfilter-xaxis-column",
                            options = [(label = x, value = x) for x in available_indicators],
                            value = available_indicators[3],
                        ),
                        dcc_radioitems( # x-axis
                            id = "crossfilter-xaxis-type",
                            options = [(label = x, value = x) for x in ["linear", "log"]],
                            value = "linear",
                        )
                    ],
                    style = (width = "49%", display = "inline-block")
                ),
                html_div( # y
                    children = [
                        dcc_dropdown( # y-column
                            id = "crossfilter-yaxis-column",
                            options = [(label = x, value = x) for x in available_indicators],
                            value = available_indicators[4],
                        ),
                        dcc_radioitems( # y-axis
                            id = "crossfilter-yaxis-type",
                            options = [(label = x, value = x) for x in ["linear", "log"]],
                            value = "linear",
                        ),
                    ],
                    style = (
                        width = "49%",
                        float = "right",
                        display = "inline-block",
                    ),
                ),
            ],
            style = (
                borderBottom = "thin lightgrey solid",
                backgroundColor = "rgb(250,250,250)",
                padding = "10px 5px",
            ),
        )        
        tag_2 = html_div(
            children = [
                dcc_graph(id = "crossfilter-indicator-scatter"),
                dcc_slider(
                    id = "crossfilter-year-slider",
                    min = minimum(years),
                    max = maximum(years),
                    marks = Dict([Symbol(x) => Symbol(x) for x in years]),
                    value = minimum(years),
                    step = nothing,
                )
            ],
            style = (
                width = "49%",
                display = "inline-block",
            ),
        )
        tag_3 = html_div(
            children = [
                dcc_graph(id = "x-time-series"),
                dcc_graph(id = "y-time-series"),
            ],
            style = (
                width = "49%", display = "inline-block", 
            #    float="right"
            ),
        )

        return tag_1, tag_2, tag_3
    end

    callback!(
        app,
        Output("crossfilter-indicator-scatter", "figure"),
        Input("crossfilter-xaxis-column", "value"),
        Input("crossfilter-yaxis-column", "value"),
        Input("crossfilter-xaxis-type", "value"),
        Input("crossfilter-yaxis-type", "value"),
        Input("crossfilter-year-slider", "value"),
    ) do xaxis_column_name, yaxis_column_name, xaxis_type, yaxis_type, year_slider_value
        dff = df[df.Year .== year_slider_value, :] # filtered
        pt = Plot(
            dff[dff[!, Symbol("Indicator Name")] .== xaxis_column_name, :Value],
            dff[dff[!, Symbol("Indicator Name")] .== yaxis_column_name, :Value],
            Layout(
                xaxis_title = xaxis_column_name,
                xaxis_type = xaxis_type == "linear" ? "linear" : "log",
                yaxis_title = yaxis_column_name,
                yaxis_type = yaxis_type == "linear" ? "linear" : "log",
                hovermode = "closest",
                height = 450,
            ),
            kind = "scatter",
            text = dff[
                dff[!, Symbol("Indicator Name")] .== yaxis_column_name,
                Symbol("Country Name"),
            ],
            customdata = dff[
                dff[!, Symbol("Indicator Name")] .== yaxis_column_name,
                Symbol("Country Name"),
            ],
            mode = "markers",
            marker_size = 15,
            marker_opacity = 0.5,
            marker_line_width = 0.5, 
            marker_line_color = "white",
        )

        return pt
    end

    callback!(
        app,
        Output("x-time-series", "figure"),
        Input("crossfilter-indicator-scatter", "hoverData"),
        Input("crossfilter-xaxis-column", "value"),
        Input("crossfilter-xaxis-type", "value"),
    ) do hover_data, xaxis_column_name, axis_type
        @show hover_data
        country_name = isnothing(hover_data) ? "" : hover_data.points[1].customdata
        dff = df[df[:, Symbol("Country Name")] .== country_name, :]
        dff = dff[dff[:, Symbol("Indicator Name")] .== xaxis_column_name, :]
        title = "<b>$(country_name)</b><br>$(xaxis_column_name)"

        return create_time_series(dff, axis_type, title)
    end

    callback!(
        app,
        Output("y-time-series", "figure"),
        Input("crossfilter-indicator-scatter", "hoverData"),
        Input("crossfilter-yaxis-column", "value"),
        Input("crossfilter-yaxis-type", "value"),
    ) do hover_data, yaxis_column_name, axis_type
        @show hover_data
        country_name = isnothing(hover_data) ? "" : hover_data.points[1].customdata
        dff = df[df[:, Symbol("Country Name")] .== country_name, :]
        dff = dff[dff[:, Symbol("Indicator Name")] .== yaxis_column_name, :]
        #title = "<b>$(country_name)</b><br>$(yaxis_column_name)"

        return create_time_series(dff, axis_type, yaxis_column_name)
    end


    #return df
    run_server(app, "0.0.0.0", debug=true)
end

"""

Utility function for `dash_update_graphs_on_hover()`.
"""
function create_time_series(df, axis_type, title)
    pt = Plot(
        df[:, :Year],
        df[:, :Value],
        Layout(
            yaxis_type = axis_type == "linear" ? "linear" : "log",
            xaxis_showgrid = false,
            annotations = [attr(
                x = 0,
                y = 0.85,
                xanchor = "left",
                yanchor = "bottom",
                xref = "paper",
                yref = "paper",
                showarrow = false,
                align = "left",
                bgcolor = "rgba(255,255,255,0.5)",
                text = title,
            )],
            height = 225,
        ),
        mode = "lines+markers",
    )

    return pt
end


# https://dash-julia.plotly.com/getting-started
#hello_dash()
#dash_table()
#dash_plotly() # RDatasets does not work
#dash_markdown()
#dash_core()
#dash_basic_callback()
#dash_layout_figure_slider()
#Ans = dash_app_multiple_inputs()
#Ans = dash_app_multiple_outputs()
#Ans = dash_app_chained_callbacks()
#Ans = dash_app_state()
#Ans = dash_intro_visual()
Ans = dash_update_graphs_on_hover()