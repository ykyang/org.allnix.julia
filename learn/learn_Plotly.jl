# Follows https://plotly.com/javascript/
# Use run_Plotly.jl to run.
# Use the command at the end to plot without Dash.

using Dash, DashHtmlComponents, DashCoreComponents, DashBootstrapComponents
using PlotlyJS, HTTP, CSV
using DataFrames
using Random

# Fundamentals                                                      Fundamentals
"""

https://plotly.com/javascript/configuration-options/
"""
function chapter_configuration_options(; app=nothing)
    if isnothing(app)
        app = dash(external_stylesheets=[dbc_themes.SPACELAB])
    end
    
   
    content = [
        # https://stackoverflow.com/questions/4086107/fixed-page-header-overlaps-in-page-anchors
        # Put this in my.css
        # html {
        # scroll-padding-top: 80px; /* height of sticky header */
        # }
        dbc_navbarsimple([
            # dbc_navitem(dbc_navlink("Scroll and zoom", href="#scroll-and-zoom",  external_link=true)),
            # dbc_navitem(dbc_navlink("Editable mode", href="#editable-mode", external_link=true)),
            # dbc_navitem(dbc_navlink("Making a static chart", href="#making-a-static-chart", external_link=true)),
            # dbc_navitem(dbc_navlink("Customize download plot options", href="#customize-download-plot-options", external_link=true)),
            # dbc_navitem(dbc_navlink("Force the modebar to always be visible", href="#customize-download-plot-options", external_link=true)),
            
            dbc_dropdownmenu([
                dbc_dropdownmenuitem("Scroll and zoom", href="#scroll-and-zoom", external_link=true),
                dbc_dropdownmenuitem("Editable mode", href="#editable-mode", external_link=true),
                dbc_dropdownmenuitem("Making a static chart", href="#making-a-static-chart", external_link=true),
                dbc_dropdownmenuitem("Customize download plot options", href="#customize-download-plot-options", external_link=true),
                dbc_dropdownmenuitem("Force the modebar to always be visible", href="#force-the-modebar-to-always-be-visible", external_link=true),
                dbc_dropdownmenuitem(
                    "Never display the modebar",
                    href="#never-display-the-modebar", external_link = true,
                ),
                dbc_dropdownmenuitem(
                    "Remove modebar buttons",
                    href="#remove-modebar-buttons", external_link=true,
                ),
            ], 
            in_navbar=true, 
            label="Section",
            caret = true),        
        ], 
        sticky="top", brand="Plotly", brand_href="https://plotly.com/javascript",
        expand=true,
        ),        

        dbc_container([html_h3("Scroll and zoom", id="scroll-and-zoom"),
            dbc_badge("Origin", color="info", href="https://plotly.com/javascript/configuration-options/#scroll-and-zoom"), 
            dbc_badge("Line: $(@__LINE__)", color="info", className="ml-1"),
            dcc_markdown("""
            Notice the scroll zoom is enabled by `scrollZoom` in
            `dcc_graph`.
            """),
            dcc_graph(
                figure = scroll_and_zoom(),
                config = Dict(:scrollZoom=>true)  
            ),
        ], className="p-3 my-2 border rounded"),

        dbc_container([html_h3("Editable Mode", id="editable-mode"),
            dbc_badge("Origin", color="info", href="https://plotly.com/javascript/configuration-options/#editable-mode"), 
            dbc_badge([html_i(className = "fa fa-car mr-1"), "Line: $(@__LINE__)"], color="info", className="ml-1"),
            
            dcc_graph(
                figure = editable_mode(),
                config = Dict(:scrollZoom=>true, :editable=>true)  
            ),
        ], className="p-3 my-2 border rounded"),

        dbc_container([html_h3("Making a Static Chart",  id="making-a-static-chart"),
            dbc_badge("Origin", color="info", href="https://plotly.com/javascript/configuration-options/#making-a-static-chart"),
            dbc_badge("Line: $(@__LINE__)", color="info", className="ml-1"),
            dcc_graph(
                figure = making_a_static_chart(),
                config = Dict(:staticPlot => true),
            ),
        ], className="p-3 my-2 border rounded",),

        dbc_container([html_h3("Customize Download Plot Options", id="customize-download-plot-options"),
            dbc_badge("Origin", color="info", href="https://plotly.com/javascript/configuration-options/#customize-download-plot-options"),
            dbc_badge("Line: $(@__LINE__)", color="info", className="ml-1"),
            dcc_graph(
                figure = customize_download_plot_options(),
                config = Dict(
                    :toImageButtonOptions => Dict(
                        :format => "svg",
                        :filename => "bubble_plot",
                        :width => 800,
                        :height => 600,
                        :scale => 1,
                    )
                ),
            )
        ], className="p-3 my-2 border rounded"),

        dbc_container([html_h3("Force the modebar to always be visible", id="force-the-modebar-to-always-be-visible"),
            dbc_badge("Origin", color="info", href="https://plotly.com/javascript/configuration-options/#force-the-modebar-to-always-be-visible"),
            dbc_badge("Line: $(@__LINE__)", color="info", className="ml-1"),
            dcc_markdown("""
            See `force_the_modebar_to_always_be_visible()` for adjusting title
            position and margin so modebar does not overlap with title.
            """),
            dcc_graph(
                figure = Plot(force_the_modebar_to_always_be_visible()...),
                config = Dict(
                    :displayModeBar => true,
                ),
            ),
        ], className="p-3 my-2 border rounded"),

        dbc_container([html_h3("Never display the modebar", id="never-display-the-modebar"),
            dbc_badge("Origin", color="info", href="https://plotly.com/javascript/configuration-options/#never-display-the-modebar"),
            dbc_badge("Line $(@__LINE__)", color="info", className="ml-1"),
            dcc_graph(
                figure = Plot(never_display_the_modebar()...),
                config = Dict(
                    :displayModeBar => false,
                ),
            ),
        ], className="p-3 my-2 border rounded"),

        dbc_container([html_h3("Remove modebar buttons", id="remove-modebar-buttons"),
            dbc_badge("Origin", color="info", href="https://plotly.com/javascript/configuration-options/#remove-modebar-buttons"),
            dbc_badge("Line $(@__LINE__)", color="info", className="ml-1"),
            dcc_graph(
                figure = Plot(remove_modebar_buttons()...),
                config = Dict(
                    :modeBarButtonsToRemove => ["toImage"],
                ),
            ),
        ], className="p-3 my-2 border rounded"),

        dbc_container([html_h3("Add buttons to modebar", id="add-buttons-to-modebar"),
            dbc_badge("Origin", color="info", href="https://plotly.com/javascript/configuration-options/#add-buttons-to-modebar"),
            dbc_badge("Line $(@__LINE__)", color="danger", className="ml-1"),
            dcc_graph(
                figure = Plot(add_buttons_to_modebar()...),
                config = add_buttons_to_modebar_config(),

            )
        ], className="p-3 my-2 border rounded"),
    ]

    app.layout = dbc_container(content)

    return app
end

function scroll_and_zoom()
    traces = [
        scatter(
            x = ["2020-10-04", "2021-11-04", "2023-12-04"],
            y = [90, 40, 60],
            type = "scatter",
        )
    ]

    layout = Layout(
        title="Scroll and Zoom",
        showlegend=false,
    )

    plt = Plot(traces, layout)

    return plt
end

function editable_mode()
    traces = [
        scatter(
            x = [0, 1, 2, 3, 4],
            y = [1, 5, 3, 7, 5],
            mode = "lines+markers",
        ),
        scatter(
            x = [1,2,3,4,5],
            y = [4,0,4,6,8],
            mode = "lines+markers"
        )
    ]

    layout = Layout(
        title="Click Here<br>to Edit Chart Title",
        showlegend=true,
    )

    plt = Plot(traces, layout)

    return plt
end

function making_a_static_chart()
    traces = [
        scatter(
            x = [0, 1, 2, 3, 4, 5, 6,],
            y = [1, 9, 4, 7, 5, 2, 4,],
            mode = "markers",
            marker = Dict(
                :size => [20, 40, 25, 10, 60, 90, 30,]
            ),
        )
    ]

    layout = Layout(
        title = "Static Chart",
        showlegent = false
    )

    plt = Plot(traces, layout)
    
    return plt
end

function customize_download_plot_options()
    traces = [
        scatter(
            x = [0, 1, 2, 3, 4, 5, 6,],
            y = [1, 9, 4, 7, 5, 2, 4,],
            mode = "markers",
            marker = Dict(
                :size => [20, 40, 25, 10, 60, 90, 30,]
            ),
        )
    ]

    layout = Layout(
        title = "Download as SVG",
        showlegend = false,
    )
    
    plt = Plot(traces, layout)

    return plt
end

function force_the_modebar_to_always_be_visible()
   traces = [
       bar(
           x = [90, 40, 60, 80, 75, 92, 87, 73],
           y = ["Marc", "Henrietta", "Jean", "Claude", "Jeffrey", "Jonathan", "Jennifer", "Zacharias"],
           orientation = "h",
       )
   ]

   layout = Layout(
       title = Dict(
           :text => "Always display the modebar",
           :y => 0.92,
       ),
       showlegend = false,
       margin = Dict(
           :l => 80, :t => 80,
       ),
   )

   #plt = Plot(traces, layout)
    return traces, layout
end

function never_display_the_modebar()
    traces = [
        bar(
            x = ["Zebras", "Linons", "Pelicans"],
            y = [90, 40, 60],
            name = "New York Zoo",
        ),
        bar(
            x = ["Zebras", "Linons", "Pelicans"],
            y = [10, 80, 45],
            name = "San Francisco Zoo",
        )
    ]

    layout = Layout(
        title = "Hide the Modebar",
        showlegend = true,
    )

    return traces, layout
end

function remove_modebar_buttons()
    traces = [
        bar(
            x = ["trees", "flowers", "hedges"],
            y = [90, 130, 40],
        ),
    ]

    layout = Layout(
        title = "Remove modebar buttons",
        showlegend = false,
    )

    return traces, layout
end

function add_buttons_to_modebar()
    traces = [
        scatter(
            mode = "lines",
            y = [2,1,2],
            line = Dict(
                :color => "green", :width => 3, :shape => "spline",
            )
        )
    ]

    layout = Layout(
        title = "add mode bar button with custom icon",
        modebardisplay = false,
    )

    return traces, layout
end

# TODO: Don't know how to implement callback
# TODO: Does not work now
function add_buttons_to_modebar_config()
    icon_1 = Dict(
        :width => 500,
        :height => 600,
        :path => "M224 512c35.32 0 63.97-28.65 63.97-64H160.03c0 35.35 28.65 64 63.97 64zm215.39-149.71c-19.32-20.76-55.47-51.99-55.47-154.29 0-77.7-54.48-139.9-127.94-155.16V32c0-17.67-14.32-32-31.98-32s-31.98 14.33-31.98 32v20.84C118.56 68.1 64.08 130.3 64.08 208c0 102.3-36.15 133.53-55.47 154.29-6 6.45-8.66 14.16-8.61 21.71.11 16.4 12.98 32 32.1 32h383.8c19.12 0 32-15.6 32.1-32 .05-7.55-2.61-15.27-8.61-21.71z"
    )
    config = Dict(
        :modeBarButtons => [
            ["autoScale2d"
            # Dict(
            #     :name => "color toggler",
            #     :icon => icon_1,
            #     :click => nothing,
            # ),
            ] 
        ],
        :modeBarButtonsToAdd => [
            
            #Dict(
            #    :name => "color toggler",
            #    :icon => icon_1,

            #), 
            # Dict(
            #     :name => "button-1",
            #     :icon => "Plotly.Icons.pencil",
            #     :direction => "up",
            # ),
        ],
        :modeBarButtonsToRemove => [
            "pan2d", "select2d", "lasso2d", "resetScale2d", "zoomOut2d",
        ]
    )

    return config
end

# Basic Charts                                                      Basic Charts 

"""

https://plotly.com/javascript/line-and-scatter/
"""
function chapter_scatter_plots(; app=nothing)
    if isnothing(app)
        app = dash(external_stylesheets=[dbc_themes.SPACELAB])
    end
    
    content = [
        # https://stackoverflow.com/questions/4086107/fixed-page-header-overlaps-in-page-anchors
        # Put this in my.css
        # html {
        # scroll-padding-top: 80px; /* height of sticky header */
        # }
        dbc_navbarsimple([
            dbc_dropdownmenu([
                dbc_dropdownmenuitem("Line and scatter plot", href="#line-and-scatter-plot", external_link=true),
                dbc_dropdownmenuitem("Data labels hover", href="#data-labels-hover", external_link=true),
                dbc_dropdownmenuitem("Data labels on the plot", href="#data-labels-on-the-plot", external_link=true),
                dbc_dropdownmenuitem("Scatter plot with a color dimension", href="#scatter-plot-with-a-color-dimension", external_link=true),
            ], in_navbar=true, label="Section", caret=true),
        ], sticky="top", expand=true, brand="Plotly", brand_href="https://plotly.com/javascript"),

        dbc_container([html_h3("Line and scatter plot", id="line-and-scatter-plot"),
            dbc_badge("Origin", color="info", href="https://plotly.com/javascript/line-and-scatter/#line-and-scatter-plot"), 
            dbc_badge("Line: $(@__LINE__)", color="info", className="ml-1"),
            dcc_graph(
                figure = Plot(line_and_scatter_plot()...),
                config = Dict(),
            )
        ], className="p-3 my-2 border rounded"),

        dbc_container([html_h3("Data labels hover", id="data-labels-hover"),
            dbc_badge("Origin", color="info", href="https://plotly.com/javascript/line-and-scatter/#data-labels-hover"), 
            dbc_badge("Line: $(@__LINE__)", color="info", className="ml-1"),
            dcc_graph(
                figure = Plot(data_labels_hover()...),
                config = Dict(),
            ),
        ], className="p-3 my-2 border rounded"),

        dbc_container([html_h3("Data labels on the plot", id="data-labels-on-the-plot"),
            dbc_badge("Origin", color="info", href="https://plotly.com/javascript/line-and-scatter/#data-labels-on-the-plot"), 
            dbc_badge("Line: $(@__LINE__)", color="info", className="ml-1"),
            dcc_graph(
                figure = Plot(data_labels_on_the_plot()...),
                config = Dict(),
            ),
        ], className="p-3 my-2 border rounded"),

        dbc_container([html_h3("Scatter plot with a color dimension", id="scatter-plot-with-a-color-dimension"),
            dbc_badge("Origin", color="info", href="https://plotly.com/javascript/line-and-scatter/#scatter-plot-with-a-color-dimension"), 
            dbc_badge("Line: $(@__LINE__)", color="info", className="ml-1"),
            dcc_graph(
                figure = Plot(scatter_plot_with_a_color_dimension()...),
                config = Dict(),
            ),

        ], className="p-3 my-2 border rounded"),

    ] # content

    app.layout = dbc_container(content)

    return app
end

function line_and_scatter_plot()
    traces = [
        scatter(
            x = [1, 2, 3, 4],
            y = [10, 15, 13, 17],
            mode = "markers",
            type = "scatter",
        ),
        scatter(
            x = [2, 3, 4, 5],
            y = [16, 5, 11, 9],
            mode = "lines",
            type = "scatter",
        ),
        scatter(
            x = [1, 2, 3, 4],
            y = [12, 9, 15, 12],
            mode = "lines+markers",
            type = "scatter",
        ),
    ]

    layout = Layout()

    return traces, layout
end

function data_labels_hover()
    traces = [
        scatter(
            x = [1, 2, 3, 4, 5],
            y = [1, 6, 3, 6, 1],
            mode = "markers",
            type = "scatter",
            name = "Team A",
            text = ["A-1", "A-2", "A-3", "A-4", "A-5"],
            marker = Dict(:size=> 12)
        ),
        scatter(
            x = [1.5, 2.5, 3.5, 4.5, 5.5],
            y = [4, 1, 7, 1, 4],
            mode = "markers",
            type = "scatter",
            name = "Team B",
            text = ["B-a", "B-b", "B-c", "B-d", "B-e"],
            marker = Dict(:size=>16)
        ),
    ]

    layout = Layout(
        xaxis = Dict(:range=>[0.75, 5.25]),
        yaxis = Dict(:range=>[0, 8]),
        title = "Data Labels Hover",
    )

    return traces, layout
end

function data_labels_on_the_plot()
    traces = [
        scatter(
            x = [1, 2, 3, 4, 5],
            y = [1, 6, 3, 6, 1],
            mode = "markers+text",
            type = "scatter",
            name = "Team A",
            text = ["A-1", "A-2", "A-3", "A-4", "A-5"],
            textposition = "top center",
            textfont = Dict(:family=>"Raleway, sans-serif"),
            marker = Dict(:size=> 12)
        ),
        scatter(
            x = [1.5, 2.5, 3.5, 4.5, 5.5],
            y = [4, 1, 7, 1, 4],
            mode = "markers+text",
            type = "scatter",
            name = "Team B",
            text = ["B-1", "B-2", "B-3", "B-4", "B-5"],
            textposition = "top center",
            textfont = Dict(:family=>"Times New Roman"),
            marker = Dict(:size=>16)
        ),
    ]

    layout = Layout(
        xaxis = Dict(:range=>[0.75, 5.25]),
        yaxis = Dict(:range=>[0, 8]),
        title = "Data Labels on the Plot",
        legend = Dict(
            :y => 0.5,
            :yref => "paper", # ???
            :font => Dict(
                :family => "Arial, sans-serif",
                :size => 20,
                :color => "grey",
            ),
        ),
    )

    return traces, layout
end

function scatter_plot_with_a_color_dimension()
    traces = [
        scatter(
            y = [5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5],
            mode = "markers",
            type = "scatter",
            
            
            textfont = Dict(:family => "Raleway, sans-serif"),
            marker = Dict(
                :size => 40,
                :color => [0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29, 30, 31, 32, 33, 34, 35, 36, 37, 38, 39],
            )
        ),
    ]

    layout = Layout(
        title = "Scatter Plot with a Color Dimension",
    )

    return traces, layout
end

"""

https://plotly.com/javascript/line-charts/
"""
function chapter_line_charts(; app = nothing)
    if isnothing(app)
        app = dash(external_stylesheets=[dbc_themes.SPACELAB])
    end

    content = [
        # https://stackoverflow.com/questions/4086107/fixed-page-header-overlaps-in-page-anchors
        # Put this in my.css
        # html {
        # scroll-padding-top: 80px; /* height of sticky header */
        # }
        dbc_navbarsimple([
            dbc_dropdownmenu([
                dbc_dropdownmenuitem("Basic line plot", href="#basic-line-plot", external_link=true),
                dbc_dropdownmenuitem("Line and scatter plot", href="#line-and-scatter-plot", external_link=true),
                dbc_dropdownmenuitem("Adding names to line and scatter plot", href="#adding-names-to-line-and-scatter-plot", external_link=true),
                dbc_dropdownmenuitem("Line and scatter styling", href="#line-and-scatter-styling", external_link=true),
                dbc_dropdownmenuitem("Styling line plot", href="#styling-line-plot", external_link=true),
                dbc_dropdownmenuitem("Colored and styled scatter plot", href="#colored-and-styled-scatter-plot", external_link=true),
                dbc_dropdownmenuitem("Line shape options for interpolation", href="#line-shape-options-for-interpolation", external_link=true),
                dbc_dropdownmenuitem("Graph and axes titles", href="#graph-and-axes-titles", external_link=true),
                dbc_dropdownmenuitem("Line dash", href="#line-dash", external_link=true),
                dbc_dropdownmenuitem("Connect gaps between data", href="#connect-gaps-between-data", external_link=true),
                dbc_dropdownmenuitem("Labelling lines with annotations", href="#labelling-lines-with-annotations", external_link=true),
                # dbc_dropdownmenuitem("", href="", external_link=true),
            ],
            in_navbar=true, label="Section", caret=true, direction="left"),
        ], 
        sticky="top", expand=true, brand="Allnix", brand_href="https://github.com/ykyang",
        ),

        dbc_container([html_h3("Basic line plot", id="basic-line-plot"),
            dbc_badge("Origin", color="info", href="https://plotly.com/javascript/line-charts/#basic-line-plot"),
            dbc_badge("Line: $(@__LINE__)", color="info", className="ml-1"),
            dcc_graph(
                figure = Plot(basic_line_plot()...),
                config = Dict(),
            ),
        ], className="p-3 my-2 border rounded",),

        dbc_container([html_h3("Line and scatter plot", id="line-and-scatter-plot"),
            dbc_badge("Origin", color="info", href="https://plotly.com/javascript/line-charts/#line-and-scatter-plot"),
            dbc_badge("Line: $(@__LINE__)", color="info", className="ml-1"),
            dcc_graph(
                figure = Plot(line_and_scatter_plot()...), # func defined above
                config = Dict(),
            ),
        ], className="p-3 my-2 border rounded",),

        dbc_container([html_h3("Adding names to line and scatter plot", id="adding-names-to-line-and-scatter-plot"),
            dbc_badge("Origin", color="info", href="https://plotly.com/javascript/line-charts/#adding-names-to-line-and-scatter-plot"),
            dbc_badge("Line: $(@__LINE__)", color="info", className="ml-1"),
            dcc_graph(
                figure = Plot(adding_names_to_line_and_scatter_plot()...),
                config = Dict(),
            ),
        ], className="p-3 my-2 border rounded"),

        dbc_container([html_h3("Line and scatter styling", id="line-and-scatter-styling"),
            dbc_badge("Origin", color="info", href="https://plotly.com/javascript/line-charts/#line-and-scatter-styling"),
            dbc_badge("Line: $(@__LINE__)", color="info", className="ml-1"),
            dcc_graph(
                figure = Plot(line_and_scatter_styling()...),
                config = Dict(),
            ),
        ], className="p-3 my-2 border rounded"),

        # skip Styling line plot
        dbc_container([html_h3("SKIP: Styling line plot", id="styling-line-plot"),
            dbc_badge("Origin", color="info", href="https://plotly.com/javascript/line-charts/#styling-line-plot"),
            dbc_badge("Line: $(@__LINE__)", color="info", className="ml-1"),
        ], className="p-3 my-2 border rounded"),

        dbc_container([html_h3("Colored and styled scatter plot", id="colored-and-styled-scatter-plot"),
            dbc_badge("Origin", color="info", href="https://plotly.com/javascript/line-charts/#colored-and-styled-scatter-plot"),
            dbc_badge("Line: $(@__LINE__)", color="info", className="ml-1"),
            dcc_graph(
                figure = Plot(colored_and_styled_scatter_plot()...),
                config = Dict(),
            ),
        ], className="p-3 my-2 border rounded"),

        dbc_container([html_h3("Line shape options for interpolation", id="line-shape-options-for-interpolation"),
            dbc_badge("Origin", color="info", href="https://plotly.com/javascript/line-charts/#line-shape-options-for-interpolation"),
            dbc_badge("Line: $(@__LINE__)", color="info", className="ml-1"),
            dcc_graph(
                figure = Plot(line_shape_options_for_interplation()...),
                config = Dict(),
            ),

        ], className="p-3 my-2 border rounded"),

        dbc_container([html_h3("Graph and axes titles", id="graph-and-axes-titles"),
            dbc_badge("Origin", color="info", href="https://plotly.com/javascript/line-charts/#graph-and-axes-titles"),
            dbc_badge("Line: $(@__LINE__)", color="info", className="ml-1"),
            dcc_graph(
                figure = Plot(graph_and_axes_titles()...),
                config = Dict(),
            ),
        ], className="p-3 my-2 border rounded"),

        dbc_container([html_h3("Line dash", id="line-dash"),
            dbc_badge("Origin", color="info", href="https://plotly.com/javascript/line-charts/#line-dash"),
            dbc_badge("Line: $(@__LINE__)", color="info", className="ml-1"),
            dcc_graph(
                figure = Plot(line_dash()...),
                config = Dict(),
            ),
        ], className="p-3 my-2 border rounded"),

        dbc_container([html_h3("Connect gaps between data", id="connect-gaps-between-data"),
            dbc_badge("Origin", color="info", href="https://plotly.com/javascript/line-charts/#connect-gaps-between-data"),
            dbc_badge("Line: $(@__LINE__)", color="info", className="ml-1"),
            dcc_graph(
                figure = Plot(connect_gaps_between_data()...),
                config = Dict(),
            ),
        ], className="p-3 my-2 border rounded"),

        dbc_container([html_h3("Labelling lines with annotations", id="labelling-lines-with-annotations"),
            dbc_badge("Origin", color="info", href="https://plotly.com/javascript/line-charts/#labelling-lines-with-annotations"),
            dbc_badge("Line: $(@__LINE__)", color="info", className="ml-1"),
            dcc_graph(
                figure = Plot(labelling_lines_with_annotations()...),
                config = Dict(),
            ),
        ], className="p-3 my-2 border rounded")

    ]

    app.layout = dbc_container(content)

    return app
end

function basic_line_plot()
    traces = [
        scatter(
            x = [1,2,3,4],
            y = [10, 15, 13, 17],
        ),
        scatter(
            x = [1,2,3,4],
            y = [16, 5, 11, 9],
        ),
    ]

    layout = Layout()

    return traces, layout
end

function adding_names_to_line_and_scatter_plot()
    traces = [
        scatter(
            x = [1,2,3,4],
            y = [10, 15, 13, 17],
            mode = "markers",
            name = "Scatter", 
        ),
        scatter(
            x = [2, 3, 4, 5],
            y = [16, 5, 11, 9],
            mode = "lines",
            name = "Lines",
        ),
        scatter(
            x = [1, 2, 3, 4],
            y = [12, 9, 15, 12],
            mode = "lines+markers",
            name = "Scatter + Lines",
        ),
    ]

    layout = Layout(
        title = "Adding Names to Line and Scatter Plot",
    )

    return traces, layout
end

function line_and_scatter_styling()
    traces = [
        scatter(
            x = [1,2,3,4],
            y = [10, 15, 13, 17],
            name = "Red Dot",
            mode = "markers",
            marker = Dict(
                :color => "rgb(219,64,82)",
                :size => 12,
            ),
        ),
        scatter(
            x = [2,3,4,5],
            y = [16,5,11,9],
            name = "Blue Line",
            mode = "lines",
            line = Dict(
                :color => "rgb(55,128,191)",
                :width => 3,
            ),
        ),
        scatter(
            x = [1,2,3,4],
            y = [12,9,15,12],
            name = "Purple",
            mode = "lines+markers",
            marker = Dict(
                :color => "rgb(128,0,128)",
                :size => 8,
            ),
            line = Dict(
                :color => "rgb(128,0,128)",
                :width => 1,
            ),
        ),
    ]

    layout = Layout(
        title = "Line and Scatter Styling",
        showlegend = true,
    )

    return traces, layout
end

function colored_and_styled_scatter_plot()
    traces = [
        scatter(
            x = [52698, 43117],
            y = [53, 31],
            mode = "markers",
            name = "North America",
            text = ["United States", "Canada"],
            marker = Dict(
                :color => "rgb(164, 194, 244)",
                :size => 12,
                :line => Dict( # Marker outline
                    :color => "black", # use black so we can see
                    :width => 0.5,
                ),
            ),
        ),
        scatter(
            x = [39317, 37236, 35650, 30066, 29570, 27159, 23557, 21046, 18007],
            y = [33, 20, 13, 19, 27, 19, 49, 44, 38],
            mode = "markers",
            name = "Europe",
            text = ["Germany", "Britain", "France", "Spain", "Italy", "Czech", "Greece", "Poland"],
            marker = Dict(
                :color => "rgb(255, 217, 102)",
                :size => 12,
            ),
        ),
        scatter(
            x = [42952, 37037, 33106, 17478, 9813, 5253, 4692, 3899],
            y = [23, 42, 54, 89, 14, 99, 93, 70],
            mode = "markers",
            name = "Asia/Pacific",
            text = ["Australia", "Japan", "South Korea", "Malaysia", "China", "Indonesia", "Philippines", "India"],
            marker = Dict(
                :color => "rgb(234, 153, 153)",
                :size => 12,
            ),   
        ),
        scatter(
            x = [19097, 18601, 15595, 13546, 12026, 7434, 5419],
            y = [43, 47, 56, 80, 86, 93, 80],
            mode = "markers",
            name = "Latin America",
            text = ["Chile", "Argentina", "Mexico", "Venezuela", "Columbia", "El Salvador", "Bolivia"],
            marker = Dict(
                :color => "rgb(142, 124, 195)",
                :size => 12,
            ),
        ),
    ]

    layout = Layout()

    return traces, layout
end

function line_shape_options_for_interplation()
    traces = [
        scatter( # 1
            x = [1, 2, 3, 4, 5],
            y = [1, 3, 2, 3, 1],
            mode = "lines+markers",
            name = "linear",
            line = Dict(
                :shape => "linear",
            ),
        ),
        scatter( # 2
            x = [1, 2, 3, 4, 5],
            y = [6, 8, 7, 8, 6],
            mode = "lines+markers",
            name = "spline",
            line = Dict(
                # tweak line smoothness with "smoothing"
                :shape => "spline",
            ),
        ),
        scatter( # 3
            x = [1, 2, 3, 4, 5],
            y = [11, 13, 12, 13, 11],
            mode = "lines+markers",
            name = "vhv",
            line = Dict(
                :shape => "vhv",
            ),
        ),
        scatter( # 4
            x = [1, 2, 3, 4, 5],
            y = [16, 18, 17, 18, 16],
            mode = "lines+markers",
            name = "hvh", 
            line = Dict(
                :shape => "hvh",
            ),
        ),
        scatter( # 5
            x = [1, 2, 3, 4, 5],
            y = [21, 23, 22, 23, 21],
            mode = "lines+markers",
            name = "vh", 
            line = Dict(
                :shape => "vh",
            ),
        ),
        scatter( # 6
            x = [1, 2, 3, 4, 5],
            y = [26, 28, 27, 28, 26],
            mode = "lines+markers",
            name = "hv",
            line = Dict(
                :shape => "hv",
            ),
        ),
    ]

    layout = Layout(
        legend = Dict(
            :y => 0.5,
            :traceorder => "reversed",
            :font => Dict(
                :size => 16,
            ),
        ),
    )

    return traces, layout
end

function graph_and_axes_titles()
    traces = [
        scatter(
            x = [1, 2, 3, 4],
            y = [10, 15, 13, 17],
            mode = "markers",
            name = "Scatter",
        ),
        scatter(
            x = [1, 2, 3, 4],
            y = [16, 5, 11, 9],
            mode = "lines",
            name = "Lines",
        ),
        scatter(
            x = [1, 2, 3, 4],
            y = [12, 9, 15, 12],
            mode = "lines+markers",
            name = "Scatter and Lines",
        ),
    ]

    layout = Layout(
        title = "Title of the Graph",
        xaxis = Dict(
            :title => "x-axis title"
        ),
        yaxis = Dict(
            :title => "y-axis title"
        )
    )

    return traces, layout
end

function line_dash()
    x = [1, 2, 3, 4, 5]
    y = [1, 3, 2, 3, 1]
    traces = [
        scatter(
            x = x,
            y = y,
            mode = "lines",
            name = "Solid",
            line = Dict(
                :dash => "solid",
                :width => 4,
            )
        ),
        scatter(
            x = x,
            y = y .+ 5,
            mode = "lines",
            name = "dashdot",
            line = Dict(
                :dash => "dashdot",
                :width => 4,
            ),
        ),
        scatter( # 3
            x = x,
            y = y .+ 10,
            mode = "lines",
            name = "Solid",
            line = Dict(
                :dash => "solid",
                :width => 4,
            )
        ),
        scatter( # 4
            x = x,
            y = y .+ 15,
            mode = "lines",
            name = "Dot",
            line = Dict(
                :dash => "dot",
                :width => 4,
            )
        ),
    ]

    layout = Layout(
        title = "Line Dash",
        xaxis = Dict(
            :range => [0.75, 5.25],
            :autorange => false,
        ),
        yaxis = Dict(
            :range => [0, 18.5],
            :autorange => false,
        ),
        legend = Dict(
            :y => 0.5,
            :traceorder => "reversed",
            :font => Dict(
                :size => 16,
            ),
        )
    )

    return traces, layout
end

function connect_gaps_between_data()
    x = [1:8...]
    traces = [
        scatter(
            x = x,
            y = [10, 15, nothing,17, 14, 12,10, nothing],
            mode = "lines+markers",
            connectgaps = true,
        ),
        scatter(
            x = x,
            y = [16, nothing, 13, 10, 8, nothing, 11, 12],
            mode = "lines",
            connectgaps = true,
        )
    ]

    layout = Layout(
        title = "Connect the Gaps Between Data",
        showlegend = false,
    )

    return traces, layout
end

function labelling_lines_with_annotations()
    xdata_list = [
        [2001, 2002, 2003, 2004, 2005, 2006, 2007, 2008, 2009, 2010, 2011, 2013],
        [2001, 2002, 2003, 2004, 2005, 2006, 2007, 2008, 2009, 2010, 2011, 2013],  
        [2001, 2002, 2003, 2004, 2005, 2006, 2007, 2008, 2009, 2010, 2011, 2013],
        [2001, 2002, 2003, 2004, 2005, 2006, 2007, 2008, 2009, 2010, 2011, 2013], 
    ]
    ydata_list = [
        [74, 82, 80, 74, 73, 72, 74, 70, 70, 66, 66, 69],
        [45, 42, 50, 46, 36, 36, 34, 35, 32, 31, 31, 28],
        [13, 14, 20, 24, 20, 24, 24, 40, 35, 41, 43, 50],
        [18, 21, 18, 21, 16, 14, 13, 18, 17, 16, 19, 23],
    ]
    
    colors = [
        "rgba(67, 67, 67,1 )", 
        "rgba(115, 115, 115, 1)", 
        "rgba(49, 130, 189, 1)",
        "rgba(189, 189, 189, 1)"
    ]

    labels = [
        "Television", "Newspaper", "Internet", "Radio"
    ]

    linesize_list = [2, 2, 4, 2]

    trace_count = min(length(xdata_list), length(ydata_list))

    
    traces = Vector{AbstractTrace}()
        
    

    

    # Construct traces of lines
    for ind in 1:trace_count
        xdata = xdata_list[ind]
        ydata = ydata_list[ind]
        trace = scatter(
            x = xdata,
            y = ydata,
            mode = "lines",
            line = Dict(
                :color => colors[ind],
                :width => linesize_list[ind]
            )
        )

        push!(traces, trace)
    end

    # Construct traces of end points
    for ind in 1:trace_count
        xdata = xdata_list[ind]
        ydata = ydata_list[ind]
        trace = scatter(
            x = [xdata[1], xdata[end]],
            y = [ydata[1], ydata[end]],
            mode = "markers",
            marker = Dict(
                :color => colors[ind],
                :size => 12,
            )
        )

        push!(traces, trace);
    end


    layout = Layout(
        showlegend = false,
        height = 600,
        width = 600,
        xaxis = Dict(
            :showline => true,
            :showgrid => false,
            :showticklabels => true,
            :linecolor => "rgb(204,204,204)",
            :linewidth => 2,
            :autotick => false, # print every x value
            :ticks => "outside",
            :tickcolor => "rgb(204,204,204)",
            :tickwidth => 2,
            :ticklen => 5,
            :tickfont => Dict(
                :family => "Arial",
                :size => 12,
                :color => "rgb(82, 82, 82)",
            ),
        ),
        yaxis = Dict(
            :showgrid => false,
            :zeroline => false,
            :showline => false,
            :showticklabels => false,
        ),
        autosize = false,
        margin = Dict(
            :autoexpand => false,
            :l => 100,
            :r => 20,
            :t => 100,
            :b => 60,
            
        ),
        annotations = [],
    )

    #@show layout["annotations"]

    annotations = layout["annotations"]

    # Top annotation
    item = Dict(
        :xref => "paper",
        :yref => "paper",
        :x => 0.5, :xanchor => "center",
        :y => 1.05, :yanchor => "bottom",
        
        :text => "Main Source for News",
        :font => Dict(
            :family => "Arial",
            :size => 30,
            :color => "rgb(37,37,37)",
        ),
        :showarrow => false,
    )
    push!(annotations, item)

    # Bottom annotation
    item = Dict(
        :xref => "paper",
        :yref => "paper",
        :x => 0.5,
        :y => -0.15,
        :text => "Source: Pew Research Center & Storytelling with data",
        :showarrow => false,
        :font => Dict(
            :family => "Arial",
            :size => 12,
            :color => "rgb(150,150,150)",
        ),
    )
    push!(annotations, item)

    
    # Left & Right annotations
    for ind in 1:trace_count
        xdata = xdata_list[ind]
        ydata = ydata_list[ind]
        # Left annotation
        item = Dict(
            :xref => "paper", # very important
            :x => 0.05,
            :y => ydata[1],
            :xanchor => "right",
            :yanchor => "middle",
            :text => "$(labels[ind]) $(ydata[1])%",
            :showarrow => false,
            :font => Dict(
                :family => "Arial",
                :size => 16,
                :color => "black",
            ),
        )
        push!(annotations, item)

        # Right annotation
        item = Dict(
            :xref => "paper",
            :x => 0.95,
            :y => ydata[end],
            :xanchor => "left",
            :yanchor => "middle",
            :text => "$(ydata[end])%",
            :font => Dict(
                :family => "Arial",
                :size => 16,
                :color => "black",
            ),
            :showarrow => false,

        )
        push!(annotations, item)
    end
    


    return traces, layout
end

"""

https://plotly.com/javascript/bar-charts/
"""
function chapter_bar_charts(; app=nothing)
    if isnothing(app)
        app = dash(external_stylesheets=[dbc_themes.SPACELAB])
    end

    # https://stackoverflow.com/questions/4086107/fixed-page-header-overlaps-in-page-anchors
    # Put this in my.css
    # html {
    # scroll-padding-top: 80px; /* height of sticky header */
    # }
    navbar = dbc_navbarsimple([
        dbc_dropdownmenu([
            dbc_dropdownmenuitem("Basic bar chart", href="#basic-bar-chart", external_link=true),
            dbc_dropdownmenuitem("Grouped bar chart", href="#grouped-bar-chart", external_link=true),
            dbc_dropdownmenuitem("Stacked bar chart", href="#stacked-bar-chart", external_link=true),
            dbc_dropdownmenuitem("Bar chart with hover text", href="#bar-chart-with-hover-text", external_link=true),
            dbc_dropdownmenuitem("Bar chart with direct labels", href="#bar-chart-with-direct-labels", external_link=true),
            dbc_dropdownmenuitem("Grouped bar chart with direct labels", href="#grouped-bar-chart-with-direct-labels", external_link=true),
            dbc_dropdownmenuitem("Bar chart with rotated labels", href="#bar-chart-with-rotated-labels", external_link=true),
            dbc_dropdownmenuitem("Customizing individual bar colors", href="#customizing-individual-bar-colors", external_link=true),
            dbc_dropdownmenuitem("Customizing individual bar widths", href="#customizing-individual-bar-widths", external_link=true),
            dbc_dropdownmenuitem("Customizing individual bar base", href="#customizing-individual-bar-base", external_link=true),
            dbc_dropdownmenuitem("Colored and styled bar chart", href="#colored-and-styled-bar-chart", external_link=true),
            dbc_dropdownmenuitem("Waterfall bar chart", href="#waterfall-bar-chart", external_link=true),
            dbc_dropdownmenuitem("Bar chart with relative barmode", href="#bar-chart-with-relative-barmode", external_link=true),
            # dbc_dropdownmenuitem("", href="", external_link=true),
        ],
        in_navbar=true, label="Section", caret=true, direction="left"),
    ], 
    sticky="top", expand=true, brand="Allnix", brand_href="https://github.com/ykyang",
    )

    content = [
        dbc_container([html_h3("Basic bar chart", id="basic-bar-chart"),
            dbc_badge("Origin", color="info", href="https://plotly.com/javascript/bar-charts/#basic-bar-chart"),
            dbc_badge("Line: $(@__LINE__)", color="info", className="ml-1"),
            dcc_graph(
                figure = Plot(basic_bar_chart()...),
                config = Dict(),
            ),
        ], className="p-3 my-2 border rounded",),

        dbc_container([html_h3("Grouped bar chart", id="grouped-bar-chart"),
            dbc_badge("Origin", color="info", href="https://plotly.com/javascript/bar-charts/#grouped-bar-chart"),
            dbc_badge("Line: $(@__LINE__)", color="info", className="ml-1"),
            dcc_graph(
                figure = Plot(grouped_bar_chart()...),
                config = Dict(),
            ),
        ], className="p-3 my-2 border rounded"),      
        
        dbc_container([html_h3("Stacked bar chart", id="stacked-bar-chart"),
            dbc_badge("Origin", color="info", href="https://plotly.com/javascript/bar-charts/#stacked-bar-chart"),
            dbc_badge("Line: $(@__LINE__)", color="info", className="ml-1"),
            dcc_graph(
                figure = Plot(stacked_bar_chart()...),
                config = Dict(),
            ),
        ], className="p-3 my-2 border rounded"),
        
        dbc_container([html_h3("Bar chart with hover text", id="bar-chart-with-hover-text"),
            dbc_badge("Origin", color="info", href="https://plotly.com/javascript/bar-charts/#bar-chart-with-hover-text"),
            dbc_badge("Line: $(@__LINE__)", color="info", className="ml-1"),
            dcc_graph(
                figure = Plot(bar_chart_with_hover_text()...),
                config = Dict(),
            ),
        ], className="p-3 my-2 border rounded"),
        
        dbc_container([html_h3("Bar chart with direct labels", id="bar-chart-with-direct-labels"),
            dbc_badge("Origin", color="info", href="https://plotly.com/javascript/bar-charts/#bar-chart-with-direct-labels"),
            dbc_badge("Line: $(@__LINE__)", color="info", className="ml-1"),
            dcc_graph(
                figure = Plot(bar_chart_with_direct_labels()...),
                config = Dict(),
            ),
        ], className="p-3 my-2 border rounded"),
        
        dbc_container([html_h3("Grouped bar chart with direct labels", id="grouped-bar-chart-with-direct-labels"),
            dbc_badge("Origin", color="info", href="https://plotly.com/javascript/bar-charts/#grouped-bar-chart-with-direct-labels"),
            dbc_badge("Line: $(@__LINE__)", color="info", className="ml-1"),
            dcc_graph(
                figure = Plot(grouped_bar_chart_with_direct_labels()...),
                config = Dict(),
            ),
        ], className="p-3 my-2 border rounded"),

        dbc_container([html_h3("Bar chart with rotated labels", id="bar-chart-with-rotated-labels"),
            dbc_badge("Origin", color="info", href="https://plotly.com/javascript/bar-charts/#bar-chart-with-rotated-labels"),
            dbc_badge("Line: $(@__LINE__)", color="info", className="ml-1"),
            dcc_graph(
                figure = Plot(bar_chart_with_rotated_labels()...),
                config = Dict(),
            ),
        ], className="p-3 my-2 border rounded"),

        dbc_container([html_h3("Customizing individual bar colors", id="customizing-individual-bar-colors"),
            dbc_badge("Origin", color="info", href="https://plotly.com/javascript/bar-charts/#customizing-individual-bar-colors"),
            dbc_badge("Line: $(@__LINE__)", color="info", className="ml-1"),
            dcc_graph(
                figure = Plot(customizing_individual_bar_colors()...),
                config = Dict(),
            ),
        ], className="p-3 my-2 border rounded"),

        dbc_container([html_h3("Customizing individual bar widths", id="customizing-individual-bar-widths"),
            dbc_badge("Origin", color="info", href="https://plotly.com/javascript/bar-charts/#customizing-individual-bar-widths"),
            dbc_badge("Line: $(@__LINE__)", color="info", className="ml-1"),
            dcc_graph(
                figure = Plot(customizing_individual_bar_widths()...),
                config = Dict(),
            ),
        ], className="p-3 my-2 border rounded"),

        dbc_container([html_h3("Customizing individual bar base", id="customizing-individual-bar-base"),
            dbc_badge("Origin", color="info", href="https://plotly.com/javascript/bar-charts/#customizing-individual-bar-base"),
            dbc_badge("Line: $(@__LINE__)", color="info", className="ml-1"),
            dcc_graph(
                figure = Plot(customizing_individual_bar_base()...),
                config = Dict(),
            ),
        ], className="p-3 my-2 border rounded"),

        dbc_container([html_h3("Colored and styled bar chart", id="colored-and-styled-bar-chart"),
            dbc_badge("Origin", color="info", href="https://plotly.com/javascript/bar-charts/#colored-and-styled-bar-chart"),
            dbc_badge("Line: $(@__LINE__)", color="info", className="ml-1"),
            dcc_graph(
                figure = Plot(colored_and_styled_bar_chart()...),
                config = Dict(),
            ),
        ], className="p-3 my-2 border rounded"),

        dbc_container([html_h3("Waterfall bar chart", id="waterfall-bar-chart"),
            dbc_badge("Origin", color="info", href="https://plotly.com/javascript/bar-charts/#waterfall-bar-chart"),
            dbc_badge("Line: $(@__LINE__)", color="info", className="ml-1"),
            dcc_graph(
                figure = Plot(waterfall_bar_chart()...),
                config = Dict(),
            ),
        ], className="p-3 my-2 border rounded"),

        dbc_container([html_h3("Bar chart with relative barmode", id="bar-chart-with-relative-barmode"),
            dbc_badge("Origin", color="info", href="https://plotly.com/javascript/bar-charts/#bar-chart-with-relative-barmode"),
            dbc_badge("Line: $(@__LINE__)", color="info", className="ml-1"),
            dcc_graph(
                figure = Plot(bar_chart_with_relative_barmode()...),
                config = Dict(),
            ),
        ], className="p-3 my-2 border rounded"),
    ]

    # during development, it is convenient to reverse
    # so the new one is at the top
    #content = reverse(content)

    pushfirst!(content, navbar)

    app.layout = dbc_container(content)

    return app
end

function basic_bar_chart()
    traces = [
        bar(
            x = ["giraffes", "orangutans", "monkeys"],
            y = [20, 14, 23],
        ),
    ]

    layout = Layout()

    return traces, layout
end

function grouped_bar_chart()
    traces = [
        bar(
            x = ["giraffes", "orangutans", "monkeys"],
            y = [20, 14, 23],
            name = "SF Zoo",
        ),
        bar(
            x = ["giraffes", "orangutans", "monkeys"],
            y = [12, 18, 29],
            name = "LA Zoo",
        ),
    ]

    layout = Layout(
        barmode = "group", # default mode
    )

    return traces, layout
end

function stacked_bar_chart()
    traces = [
        bar(        
            x = ["giraffes", "orangutans", "monkeys"],
            y = [20, 14, 23],
            name = "SF Zoo",
        ),
        bar(
            x = ["giraffes", "orangutans", "monkeys"],
            y = [12, 18, 29],
            name = "LA Zoo",
        ),
    ]
    layout = Layout(
        barmode = "stack",
    )

    return traces, layout
end

function bar_chart_with_hover_text()
    df = DataFrame([
        "name"  => ["Liam", "Sophie", "Jacob", "Mia", "William", "Olivia"],
        "score" => [8.0, 8.0, 12.0, 12.0, 13.0, 20.0],
        "note"  => [
            "4.17 below the mean", "4.17 below the mean", "0.17 below the mean",
            "0.17 below the mean", "0.83 above the mean", "7.83 above the mean"
        ]
    ])

    traces = [
        bar(
            x = df[!,"name"],
            y = df[!,"score"],
            text = df[!,"note"],
            marker = Dict(
                :color => "rgb(142,124,195)",
            ),
        )
    ]

    layout = Layout(
        title = "Number of Graphs Made this Week",
        font = Dict(
            :family => "Raleway, sans-serif",
        ),
        showlegend = false,
        xaxis = Dict(
            :tickangle => -45,
        ),
        yaxis = Dict(
            :zeroline => false,
            :gridwidth => 2,
        ),
        bargap = 0.05,
    )

    return traces, layout
end

function bar_chart_with_direct_labels()
    df = DataFrame(
        "name" => ["Product A", "Product B", "Product C"],
        "price" => Vector{Int64}([20, 14, 23])
    )

    traces = [
        bar(
            x = df[!,"name"],
            y = df[!,"price"],
            text = map(string, df[!,"price"]), # convert to String
            textposition = "auto",
            hoverinfo = "none",
            marker = Dict(
                :color => "rgb(158,202,225)",
                :opacity => 0.6,
                :line => Dict(
                    :color => "rgb(8,48,107)",
                    :width => 1.5,
                ),
            )
        )
    ]

    layout = Layout(
        title = "January 2013 Sales Report",
        barmode = "stack"
    )

    return traces, layout
end

function grouped_bar_chart_with_direct_labels()
    df = DataFrame(
        "name" => ["Product A", "Product B", "Product C"],
        "price1" => Vector{Int64}([20, 14, 23]),
        "price2" => Vector{Int64}([24, 16, 20]),
    )
    traces = [
        bar(
            x = df[!,"name"],
            y = df[!,"price1"],
            text = map(string, df[!,"price1"]),
            textposition = "auto",
            hoverinfo = "none",
            opacity = 0.5,
            name = "Team A",
            marker = Dict(
                :color => "rgb(158,202,225)",
                :line => Dict(
                    :color => "rgb(8,48,107)",
                    :width => 1.5,
                ),
            ),
        ),
        bar(
            x = df[!,"name"],
            y = df[!,"price2"],
            text = map(string, df[!,"price2"]),
            textposition = "auto",
            hoverinfo = "none",
            name = "Team B",
            marker = Dict(
                :color => "rgba(58,200,225,0.5)",
                :line => Dict(
                    :color => "rgb(8,48,107)",
                    :width => 1.5,
                ),
            ),
        ),
    ]
    layout = Layout(
        title = "January 2013 Sales Report"
    )

    return traces, layout
end

function bar_chart_with_rotated_labels()
    df = DataFrame(
        "x" => ["Jan", "Feb", "Mar", "Apr", "May", "Jun", "Jul", "Aug", "Sep", "Oct", "Nov", "Dec"],
        "y1" => Vector{Int64}([20, 14, 25, 16, 18, 22, 19, 15, 12, 16, 14, 17]),
        "y2" => Vector{Int64}([19, 14, 22, 14, 16, 19, 15, 14, 10, 12, 12, 16]),
    )
    traces = [
        bar(
            x = df[!,"x"],
            y = df[!,"y1"],
            name = "Primary",
            marker = Dict(
                :color => "rgb(49,130,189)",
                :opacity => 0.7,
            )
        ),
        bar(
            x = df[!,"x"],
            y = df[!,"y2"],
            name = "Secondary",
            marker = Dict(
                :color => "rgb(204,204,204)",
                :opacity => 0.5,
            )
        ),
    ]
    layout = Layout(
        title = "2013 Sales Report",
        xaxis = Dict(
            :tickangle => -45,
        ),
        barmode = "group",
    )

    return traces, layout
end

function customizing_individual_bar_colors()
    df = DataFrame(
        "x"  => ["Feature A", "Feature B", "Feature C", "Feature D", "Feature E"],
        "y" => Vector{Int64}([20, 14, 23, 25, 22]),
        "color" => [
            "rgba(204,204,204,1)", 
            "rgba(222,45,38,0.8)", 
            "rgba(204,204,204,1)", 
            "rgba(204,204,204,1)", 
            "rgba(204,204,204,1)", 
        ]
    )

    traces = [
        bar(
            x = df[!,"x"],
            y = df[!,"y"],
            marker = Dict(
                :color => df[!,"color"],
            ),
        )
    ]

    layout = Layout(
        title = "Least Used Feature",
    )

    return traces, layout
end

function customizing_individual_bar_widths()
    df = DataFrame(
        "x"  => Vector{Float64}([1, 2, 3, 5.5, 10]),
        "y" => Vector{Int64}([10, 8, 6, 4, 2]),
        "width" => Vector{Float64}([0.8, 0.8, 0.8, 3.5, 4])
    )

    traces = [
        bar(
            x = df[!,"x"],
            y = df[!,"y"],
            width = df[!,"width"],
        ),
    ]

    layout = Layout()

    return traces, layout
end

function customizing_individual_bar_base()
    traces = [
        bar(
            name = "expenses",
            x = ["2016", "2017", "2018"],
            y = [500, 600, 700],
            base = [-500, -600, -700],
            hovertemplate = "%{base}",
            marker = Dict(
                :color => "red",
            )
        ),
        bar(
            name = "revenue",
            x = ["2016", "2017", "2018"],
            y = [300, 400, 700],
            base = 0,
            marker = Dict(
                :color => "blue",
            ),

        ),
    ]
    layout = Layout()

    return traces, layout
end

function colored_and_styled_bar_chart()
    df = DataFrame(
        "year"  => Vector{Int32}([1995, 1996, 1997, 1998, 1999, 2000, 2001, 2002, 2003, 2004, 2005, 2006, 2007, 2008, 2009, 2010, 2011, 2012]),
        # not including China
        "world" => Vector{Int32}([219, 146, 112, 127, 124, 180, 236, 207, 236, 263, 350, 430, 474, 526, 488, 537, 500, 439]),
        "china" => Vector{Int32}([16, 13, 10, 11, 28, 37, 43, 55, 56, 88, 105, 156, 270, 299, 340, 403, 549, 499])
    )

    traces = [
        bar(
            name = "Rest of world",
            x = df[!,"year"],
            y = df[!,"world"],
            marker = Dict(
                :color => "rgb(55,83,109)",
            )
        ),
        bar(
            name = "China",
            x = df[!,"year"],
            y = df[!,"china"],
            marker = Dict(
                :color => "rgb(26,118,255)",
            )
        ),
    ]

    layout = Layout(
        title = "US Export of Plastic Scrap",
        barmode = "group",
        bargap = 0.15,      # distance between different groups
        bargroupgap = 0.10, # distance between bars within a group
        xaxis = Dict(
            :title => "Year",
            :titlefont => Dict(
                :size => 16,
                :color => "rgb(107,107,107)",
            ),
            :tickfont => Dict(
                :size => 14,
                :color => "rgb(107,107,107)",
            )
        ),
        yaxis = Dict(
            :title => "USD (millions)",
            :titlefont => Dict(
                :size => 16,
                :color => "rgb(107,107,107)",
            ),
            :tickfont => Dict(
                :size => 14,
                :color => "rgb(107,107,107)",
            )
        ),
        legend = Dict(
            :x => 0,
            :y => 1.0,
            :bgcolor     => "rgba(255,255,255,0)", # transparent
            :bordercolor => "rgba(255,255,255,0)", # transparent
        ),
    )

    return traces, layout
end

function waterfall_bar_chart()
    df = DataFrame(
        "x" => [
            "Product<br>Revenue", "Services<br>Revenue",
            "Total<br>Revenue", "Fixed<br>Costs",
            "Variable<br>Costs", "Total<br>Costs", "Total<br>Profit"
        ],
        "text" => ["\$430K", "\$260K", "\$690K", "\$-120K", "\$-200K", "\$-320K", "\$370K"],
        # for text position
        "y"  => Vector{Int64}([400, 660, 660, 590, 400, 400, 340]), 
        "base" => Vector{Int64}([0, 430, 0, 570, 370, 370, 0]),
        "revenue" => Vector{Int64}([430, 260, 690, 0, 0, 0, 0]),
        "cost" => Vector{Int64}([0, 0, 0, 120, 200, 320, 0]),
        "profit" => Vector{Int64}([0, 0, 0, 0, 0, 0, 370]),
        
    )
    #@show size(df)
    traces = [
        bar( # base
            x = df[!,"x"],
            y = df[!, "base"],
            marker = Dict(
                :color => "rgba(1,1,1,0.0)", # transparent for the base
            ),
        ),
        bar( # revenue
            x = df[!,"x"],
            y = df[!,"revenue"],
            marker = Dict(
                :color => "rgba(55,128,191,0.7)",
                :line => Dict(
                    :color => "rgba(55,128,191,1.0)",
                    #:width => 2,
                )
            )
        ),
        bar( # cost
            x = df[!,"x"],
            y = df[!,"cost"],
            marker = Dict(
                :color => "rgba(219,64,82,0.7)",
                :line => Dict(
                    :color => "rgba(219,64,82,1.0)",
                    #:width => 2,
                ),
            )
        ), 
        bar( # profit
            x = df[!,"x"],
            y = df[!,"profit"],
            marker = Dict(
                :color => "rgba(50,171,96,0.7)",
                :line => Dict(
                    :color => "rgba(50,171,96,0.7)",
                    #:width => 2,
                ),
            )
        ),
    ]
    layout = Layout(
        title = "Annual Profit 2015",
        barmode = "stack",
        width = 600,
        height = 600,
        paper_bgcolor = "rgba(245,246,249,1)",
        plot_bgcolor = "rgba(245,246,249,1)",
        showlegend = false,
        annotations = [],
    )

    height = size(df)[1]

    annotations = layout["annotations"]
    for ind = 1:height
        annotation = Dict(
            :x => df[!,"x"][ind],
            :y => df[!,"y"][ind],
            :text => df[!,"text"][ind],
            :showarrow => false,
            :font => Dict(
                :family => "Arial",
                :size => 14,
                :color => "rgba(245,246,249,1)",
            )
        )

        push!(annotations, annotation)
    end

    return traces, layout
end

function bar_chart_with_relative_barmode()
    df = DataFrame(
        "x"  => Vector{Int32}([1, 2, 3, 4]),
        "y1" => Vector{Float64}([1, 4, 9, 16]),
        "y2" => Vector{Float64}([6, -8, -4.5, 8]),
        "y3" => Vector{Float64}([-15, -3, 4.5, -8]),
        "y4" => Vector{Float64}([-1, 3, -3, -4]),
    )

    traces = [
        bar(
            name = "T-1",
            x = df[!,"x"],
            y = df[!,"y1"],
        ),
        bar(
            name = "T-2",
            x = df[!,"x"],
            y = df[!,"y2"],
        ),
        bar(
            name = "T-3",
            x = df[!,"x"],
            y = df[!,"y3"],
        ),
        bar(
            name = "T-4",
            x = df[!,"x"],
            y = df[!,"y4"],
        ),
    ]

    layout = Layout(
        xaxis = Dict(:title => "X axis"),
        yaxis = Dict(:title => "Y axis"),
        barmode = "relative",
    )

    return traces, layout
end

"""

https://plotly.com/javascript/pie-charts/
"""
function chapter_pie_charts(; app=nothing)
    if isnothing(app)
        app = dash(external_stylesheets=[dbc_themes.SPACELAB])
    end

    # https://stackoverflow.com/questions/4086107/fixed-page-header-overlaps-in-page-anchors
    # Put this in my.css
    # html {
    # scroll-padding-top: 80px; /* height of sticky header */
    # }
    navbar = dbc_navbarsimple([
        dbc_dropdownmenu([
            dbc_dropdownmenuitem("Basic pie chart", href="#basic-pie-chart", external_link=true),
            dbc_dropdownmenuitem("Pie chart subplots", href="#pie-chart-subplots", external_link=true),
            dbc_dropdownmenuitem("Donut chart", href="#donut-chart", external_link=true),
            dbc_dropdownmenuitem("Automatically adjust margins", href="#automatically-adjust-margins", external_link=true),
            dbc_dropdownmenuitem("Control text orientation inside pie chart sectors", href="#control-text-orientation-inside-pie-chart-sectors", external_link=true),
            
            # dbc_dropdownmenuitem("", href="", external_link=true),
        ],
        in_navbar=true, label="Section", caret=true, direction="left"),
    ], 
    sticky="top", expand=true, brand="Allnix", brand_href="https://github.com/ykyang",
    )

    content = [
        dbc_container([html_h3("Basic pie chart", id="basic-pie-chart"),
            dbc_badge("Origin", color="info", href="https://plotly.com/javascript/pie-charts/#basic-pie-chart"),
            dbc_badge("Line: $(@__LINE__)", color="info", className="ml-1"),
            dcc_graph(
                figure = Plot(basic_pie_chart()...),
                config = Dict(),
            ),
        ], className="p-3 my-2 border rounded",),

        dbc_container([html_h3("Pie chart subplots", id="pie-chart-subplots"),
            dbc_badge("Origin", color="info", href="https://plotly.com/javascript/pie-charts/#pie-chart-subplots"),
            dbc_badge("Line: $(@__LINE__)", color="info", className="ml-1"),
            dcc_graph(
                figure = Plot(pie_chart_subplots()...),
                config = Dict(),
            ),
        ], className="p-3 my-2 border rounded",),
        
        dbc_container([html_h3("Donut chart", id="donut-chart"),
            dbc_badge("Origin", color="info", href="https://plotly.com/javascript/pie-charts/#donut-chart"),
            dbc_badge("Line: $(@__LINE__)", color="info", className="ml-1"),
            dcc_graph(
                figure = Plot(donut_chart()...),
                config = Dict(),
            ),
        ], className="p-3 my-2 border rounded",),

        dbc_container([html_h3("Automatically adjust margins", id="automatically-adjust-margins"),
            dbc_badge("Origin", color="info", href="https://plotly.com/javascript/pie-charts/#automatically-adjust-margins"),
            dbc_badge("Line: $(@__LINE__)", color="info", className="ml-1"),
            dcc_graph(
                figure = Plot(automatically_adjust_margins()...),
                config = Dict(),
            ),
        ], className="p-3 my-2 border rounded",),

        dbc_container([html_h3("Control text orientation inside pie chart sectors", id="control-text-orientation-inside-pie-chart-sectors"),
            dbc_badge("Origin", color="info", href="https://plotly.com/javascript/pie-charts/#control-text-orientation-inside-pie-chart-sectors"),
            dbc_badge("Line: $(@__LINE__)", color="info", className="ml-1"),
            dcc_graph(
                figure = Plot(control_text_orientation_inside_pie_chart_sectors()...),
                config = Dict(),
            ),
        ], className="p-3 my-2 border rounded",),
    ]

    # during development, it is convenient to reverse
    # so the new one is at the top
    #content = reverse(content)

    pushfirst!(content, navbar)

    app.layout = dbc_container(content)

    return app
end

function basic_pie_chart()
    df = DataFrame(
        "value" => Vector{Int32}([19,26,55]),
        "label" => Vector{String}(["Residential", "Non-Residential", "Utility"]),
    )
    traces = [
        pie(
            values = df[!,"value"],
            labels = df[!,"label"],
        )
    ]
    layout = Layout()

    return traces, layout
end

function pie_chart_subplots()
    df = DataFrame(
        "T1" => Vector{Int32}([38, 27, 18, 10, 7]),
        "T2" => Vector{Int32}([28, 26, 21, 15, 10]),
        "T3" => Vector{Int32}([38, 19, 16, 14, 13]),
        "T4" => Vector{Int32}([31, 24, 19, 18, 8]),
        "C1" => ["rgb(56, 75, 126)", "rgb(18, 36, 37)", "rgb(34, 53, 101)", "rgb(36, 55, 57)", "rgb(6, 4, 4)"],
        "C2" => ["rgb(177, 127, 38)", "rgb(205, 152, 36)", "rgb(99, 79, 37)", "rgb(129, 180, 179)", "rgb(124, 103, 37)"],
        "C3" => ["rgb(33, 75, 99)", "rgb(79, 129, 102)", "rgb(151, 179, 100)", "rgb(175, 49, 35)", "rgb(36, 73, 147)"],
        "C4" => ["rgb(146, 123, 21)", "rgb(177, 180, 34)", "rgb(206, 206, 40)", "rgb(175, 51, 21)", "rgb(35, 36, 21)"],
        "label" => ["1st", "2nd", "3rd", "4th", "5th"],
    )

    traces = [
        pie(
            name = "Starry Night",
            values = df[!,"T1"],
            labels = df[!, "label"],
            marker = Dict(
                :colors => df[!,"C1"],
            ),
            domain = Dict(
                :row => 0, :column => 0,
            ),
            hoverinfo = "label+percent+name",
            textinfo = "none", # text in the pi
        ),
        pie(
            name = "Sunflowers",
            values = df[!,"T2"],
            labels = df[!, "label"],
            marker = Dict(
                :colors => df[!,"C2"],
            ),
            domain = Dict(
                :row => 1, :column => 0,
            ),
            hoverinfo = "label+percent+name",
            textinfo = "none", # text in the pi
        ),
        pie(
            name = "Sunflowers",
            values = df[!,"T3"],
            labels = df[!, "label"],
            marker = Dict(
                :colors => df[!,"C3"],
            ),
            domain = Dict(
                :row => 0, :column => 1,
            ),
            hoverinfo = "label+percent+name",
            textinfo = "none", # text in the pi
        ),
        pie(
            name = "Sunflowers",
            values = df[!,"T4"],
            labels = df[!, "label"],
            marker = Dict(
                :colors => df[!,"C4"],
            ),
            domain = Dict(
                :row => 1, :column => 1,
            ),
            hoverinfo = "label+percent+name",
            textinfo = "none", # text in the pi
        ),
    ]

    layout = Layout(
        height = 400,
        width = 500,
        grid = Dict(
            :rows => 2, :columns => 2,
        )
    )

    return traces, layout
end

function donut_chart()
    df = DataFrame(
        "nation" => Vector{String}(["US", "China", "European Union", "Russian Federation", "Brazil", "India", "Rest of World"]),
        "ghg" => Vector{Int32}([16, 15, 12, 6, 5, 4, 42]),
        "co2" => Vector{Int32}([27, 11, 25, 8, 1, 3, 25]),
    )

    traces = [
        pie(
            name = "GHG Emissions",
            labels = df[!,"nation"],
            values = df[!,"ghg"],
            hole = 0.4,  # This is what makes donut
            domain = Dict(:column => 0),
            hoverinfo = "label+percent+name",
        ),
        pie(
            name = "CO2 Emissions",
            labels = df[!,"nation"],
            values = df[!,"co2"],
            hole = 0.4,  # This is what makes donut
            domain = Dict(:column => 1),
            hoverinfo = "label+percent+name",
        ),
    ]

    layout = Layout(
        title = "Global Emissions 1990-2011",
        showlegend = false,
        height = 400,
        width = 600,
        grid = Dict(
            :rows => 1, :columns => 2,
        ),
        annotations = [
            Dict(
                :text => "GHG",
                :showarrow => false,
                :x => 0.185, :y => 0.5,
                :font => Dict(
                    :size => 20,
                )
            ), 
            Dict(
                :text => "CO2",
                :showarrow => false,
                :x => 0.81, :y => 0.5,
                :font => Dict(
                    :size => 20,
                )
            ),
        ]
    )

    return traces, layout
end

function automatically_adjust_margins()
    df = DataFrame(
        "money" => Vector{Int32}([2, 3, 4, 4]),
        "type"  => Vector{String}(["Wages", "Operating expenses", "Cost of sales", "Insurance"]),
    )

    traces = [
        pie(
            values = df[!,"money"],
            labels = df[!,"type"],
            textinfo = "label+percent",
            textposition = "outside",
            # What is the difference?
            # Auto scale after purposely setting bad margin (below).
            automargin = true, 
        ),
    ]

    layout = Layout(
        height = 400,
        width = 400,
        margin = Dict(
            :t => 0, :b => 0, :l => 0, :r => 0,
        ),
        showlegend = false,
    )

    return traces, layout
end

function control_text_orientation_inside_pie_chart_sectors()
    df = DataFrame(
        "money" => Vector{Int32}([2, 3, 4, 4]),
        "type"  => Vector{String}(["Wages", "Operating expenses", "Cost of sales", "Insurance"]),
    )

    traces = [
        pie(
            labels = df[!,"type"],
            values = df[!,"money"],
            textinfo = "label+percent",
            insidetextorientation = "radial",
        ),
    ]

    layout = Layout(
        height = 500,
        width = 500,
    )

    return traces, layout
end

"""

https://plotly.com/javascript/bubble-charts/
"""
function chapter_bubble_charts(; app=nothing)
    if isnothing(app)
        app = dash(external_stylesheets=[dbc_themes.SPACELAB])
    end

    # https://stackoverflow.com/questions/4086107/fixed-page-header-overlaps-in-page-anchors
    # Put this in my.css
    # html {
    # scroll-padding-top: 80px; /* height of sticky header */
    # }
    navbar = dbc_navbarsimple([
        dbc_dropdownmenu([
            dbc_dropdownmenuitem("Marker size on bubble charts", href="#marker-size-on-bubble-charts", external_link=true),
            dbc_dropdownmenuitem("Marker size and color on bubble charts", href="#marker-size-and-color-on-bubble-charts", external_link=true),
            dbc_dropdownmenuitem("Hover text on bubble charts", href="#hover-text-on-bubble-charts", external_link=true),
            dbc_dropdownmenuitem("Bubble size scaling on charts", href="#bubble-size-scaling-on-charts", external_link=true),
            dbc_dropdownmenuitem("Marker size color and symbol as an array", href="#marker-size-color-and-symbol-as-an-array", external_link=true),
            
            # dbc_dropdownmenuitem("", href="", external_link=true),
        ],
        in_navbar=true, label="Section", caret=true, direction="left"),
    ], 
    sticky="top", expand=true, brand="Allnix", brand_href="https://github.com/ykyang",
    )

    content = [
        dbc_container([html_h3("Marker size on bubble charts", id="marker-size-on-bubble-charts"),
            dbc_badge("Origin", color="info", href="https://plotly.com/javascript/bubble-charts/#marker-size-on-bubble-charts"),
            dbc_badge("Line: $(@__LINE__)", color="info", className="ml-1"),
            dcc_graph(
                figure = Plot(marker_size_on_bubble_charts()...),
                config = Dict(),
            ),
        ], className="p-3 my-2 border rounded",),

        dbc_container([html_h3("Marker size and color on bubble charts", id="marker-size-and-color-on-bubble-charts"),
            dbc_badge("Origin", color="info", href="https://plotly.com/javascript/bubble-charts/#marker-size-and-color-on-bubble-charts"),
            dbc_badge("Line: $(@__LINE__)", color="info", className="ml-1"),
            dcc_graph(
                figure = Plot(marker_size_and_color_on_bubble_charts()...),
                config = Dict(),
            ),
        ], className="p-3 my-2 border rounded",),

        dbc_container([html_h3("Hover text on bubble charts", id="hover-text-on-bubble-charts"),
            dbc_badge("Origin", color="info", href="https://plotly.com/javascript/bubble-charts/#marker-size-and-color-on-bubble-charts"),
            dbc_badge("Line: $(@__LINE__)", color="info", className="ml-1"),
            dcc_graph(
                figure = Plot(hover_text_on_bubble_charts()...),
                config = Dict(),
            ),
        ], className="p-3 my-2 border rounded",),

        dbc_container([html_h3("Bubble size scaling on charts", id="bubble-size-scaling-on-charts"),
            dbc_badge("Origin", color="info", href="https://plotly.com/javascript/bubble-charts/#bubble-size-scaling-on-charts"),
            dbc_badge("Line: $(@__LINE__)", color="info", className="ml-1"),
            dcc_graph(
                figure = Plot(bubble_size_scaling_on_charts()...),
                config = Dict(),
            ),
        ], className="p-3 my-2 border rounded",),

        dbc_container([html_h3("Marker size, color and symbol as an array", id="marker-size-color-and-symbol-as-an-array"),
        dbc_badge("Origin", color="info", href="https://plotly.com/javascript/bubble-charts/#marker-size-color-and-symbol-as-an-array"),
        dbc_badge("Line: $(@__LINE__)", color="info", className="ml-1"),
        dcc_graph(
            figure = Plot(marker_size_color_and_symbol_as_an_array()...),
            config = Dict(),
        ),
    ], className="p-3 my-2 border rounded",),
    ]

    # during development, it is convenient to reverse
    # so the new one is at the top
    content = reverse(content)

    pushfirst!(content, navbar)

    app.layout = dbc_container(content)

    return app
end

function marker_size_on_bubble_charts()
    df = DataFrame(
        "x" => Vector{Int64}([1, 2, 3, 4]),
        "y" => Vector{Int64}([10, 11, 12, 13]),
        "size" => Vector{Int64}([40, 60, 80, 100]),
    )
    traces = [
        scatter(
            x = df[!,:x],
            y = df[!,:y],
            mode = "markers",
            marker = Dict(
                :size => df[!,:size],
            )
        )
    ]

    layout = Layout(
        title = "Marker Size",
        showlegend = false,
        # height = 600,
        # width = 600
    )

    return traces, layout
end

function marker_size_and_color_on_bubble_charts()
    df = DataFrame(
        "x" => Vector{Int64}([1, 2, 3, 4]),
        "y" => Vector{Int64}([10, 11, 12, 13]),
        "size" => Vector{Int64}([40, 60, 80, 100]),
        "opacity" => Vector{Float32}([1, 0.8, 0.6, 0.4]),
        "color" => Vector{String}([
            "rgb(93,164,214)", "rgb(255,144,14)", "rgb(44,160,101)", "rgb(255,65,54)"
        ]),
    )

    traces = [
        scatter(
            x = df[!,:x],
            y = df[!,:y],
            mode = "markers",
            marker = Dict(
                :size => df[!,:size],
                :opacity => df[!,:opacity],
                :color => df[!,:color],
            )
        ),
    ]

    layout = Layout(
        title = "Marker Size and Color",
        showlegend = false,
    )

    return traces, layout
end

function hover_text_on_bubble_charts()
    df = DataFrame(
        "x" => Vector{Int64}([1, 2, 3, 4]),
        "y" => Vector{Int64}([10, 11, 12, 13]),
        "size" => Vector{Int64}([40, 60, 80, 100]),
        "opacity" => Vector{Float32}([1, 0.8, 0.6, 0.4]),
        "text" => Vector{String}(["A", "B", "C", "D"]),
        "color" => Vector{String}([
            "rgb(93,164,214)", "rgb(255,144,14)", "rgb(44,160,101)", "rgb(255,65,54)"
        ]),
    )

    traces = [
        scatter(
            mode = "markers",
            x = df[!,:x],
            y = df[!,:y],
            #text = text_list,
            text =["$t<br>size: $s" for (t,s) in zip(df[!,:text], df[!,:size])], 
            marker = Dict(
                :size => df[!,:size],
                :color => df[!,:color],
            ),

        ),
    ]

    layout = Layout(
        title = "Bubble Chart Hover Text",
        showlegend = false,
    )

    return traces, layout
end

"""

Recommended 
```
sizeref = 2.0 * max_size / desired_max_size**2
```
"""
function bubble_size_scaling_on_charts()
    df = DataFrame(
        "x" => Vector{Int64}([1, 2, 3, 4]),
        "y" => Vector{Int64}([10, 11, 12, 13]),
        "size" => Vector{Int64}([40, 60, 80, 100]),
        "opacity" => Vector{Float32}([1, 0.8, 0.6, 0.4]),
        "text" => Vector{String}(["A", "B", "C", "D"]),
        "color" => Vector{String}([
            "rgb(93,164,214)", "rgb(255,144,14)", "rgb(44,160,101)", "rgb(255,65,54)"
        ]),
    )
    traces = Vector{AbstractTrace}()
    layout = Layout(
        title = "Bubble Chart Size Scaling",
        showlegend = true,
    )

    # Trace 1
    trace = scatter(
        name = "sizeref not set",
        x = df[!,:x],
        y = df[!,:y] .+ 0*4,
        text = ["$t<br>size: $s" for (t,s) in zip(df[!,:text], df[!,:size])],
        marker = Dict(
            :sizemode => "area",    
            :size => df[!,:size] .* 10,
        ),
        mode = "markers",
    )
    push!(traces, trace)

    # Trace 2
    trace = scatter(
        name = "sizeref = 2",
        x = df[!,:x],
        y = df[!,:y] .+ 1*4,
        text = ["$t<br>size: $s<br>sizeref: 2" for (t,s) in zip(df[!,:text],df[!,:size])],
        marker = Dict(
            :sizemode => "area",
            :size => df[!,:size] .* 10,
            :sizeref => 2, # bigger than 1 -> small
        ),
        mode = "markers",
    )
    push!(traces, trace)

    # Trace 3
    trace = scatter(
        name = "sizeref = 0.2",
        x = df[!,:x],
        y = df[!,:y] .+ 2*4,
        text = ["$t<br>size: $s<br>sizeref: 0.2" for (t,s) in zip(df[!,:text], df[!,:size])],
        marker = Dict(
            :sizemode => "area",
            :size => df[!,:size] .* 10,
            :sizeref => 0.2,
        ),
        mode = "markers",
    )
    push!(traces, trace)

    desired_max_size = 40
    sizeref = 2.0 * maximum(df[!,:size] .* 10) / desired_max_size^2
    # Trace 4
    trace = scatter(
        name = "2 * M / d**2",
        x = df[!,:x],
        y = df[!,:y] .+ 3*4,
        text = ["$t<br>size: $s<br>sizeref: $sizeref" for (t,s) in zip(df[!,:text], df[!,:size])],
        marker = Dict(
            :sizemode => "area",
            :size => df[!,:size] .* 10,
            :sizeref => sizeref,
        ),
        mode = "markers",
    )
    push!(traces, trace)

    return traces, layout
end

function marker_size_color_and_symbol_as_an_array()
    traces = Vector{AbstractTrace}([
        scatter(
            x = [1, 2, 3, 4],
            y = [10, 11, 12, 13],
            mode = "markers",
            marker = Dict(
                :size => [12, 22, 32, 42],
                :color => ["hsl(0,100,40)", "hsl(33,100,40)", "hsl(66,100,40)", "hsl(99,100,40)"],
                :opacity => [0.6, 0.7, 0.8, 0.9],
            ),
        ),
        scatter(
            x = [1, 2, 3, 4],
            y = [10, 11, 12, 13] .+ 1,
            mode = "markers",
            marker = Dict(
                :color => "rgb(31,119,180)",
                :size => 18,
                :symbol => ["circle", "square", "diamond", "cross"],
            ),
        ),
        scatter(
            x = [1, 2, 3, 4],
            y = [10, 11, 12, 13] .+ 2,
            mode = "markers",
            marker = Dict(
                :size => 18,
                :line => Dict(
                    :color => ["rgb(120,120,120)", "rgb(120,120,120)", "red", "rgb(120,120,120)"],
                    :width => [2, 2, 6, 2],
                )
            )
        ),
    ])

    layout = Layout(
        showlegend = false,
    )

    return traces, layout
end


function chapter_histograms(; app=nothing)
    if isnothing(app)
        app = dash(external_stylesheets=[dbc_themes.SPACELAB])
    end
    
    # https://stackoverflow.com/questions/4086107/fixed-page-header-overlaps-in-page-anchors
    # Put this in my.css
    # html {
    # scroll-padding-top: 80px; /* height of sticky header */
    # }
    navbar = dbc_navbarsimple([
        dbc_dropdownmenu([
            dbc_dropdownmenuitem("Basic histogram", href="#basic-histogram", external_link=true),
            dbc_dropdownmenuitem("Horizontal histogram", href="#horizontal-histogram", external_link=true),
        ], in_navbar=true, label="Section", caret=true, direction="left"),
    ],
    sticky="top", #expand=true,
    fluid=true,
    brand="Allnix", brand_href="https://github.com/ykyang",
    )

    # Bootstrap grid is 12 columns, therefore width=6
    content = [
        dbc_row([
            dbc_col(
                dbc_container([
                    html_h3("Basic histogram", id="basic-histogram"),
                    dbc_badge("Origin", color="info", href="https://plotly.com/javascript/histograms/#basic-histogram"),
                    dbc_badge("Line: $(@__LINE__)", color="info", className="ml-1"),
                    dcc_graph(
                        figure = Plot(simple_histogram()...),
                        config = Dict(),
                    )
                ], className="p-3 my-2 border rounded", ),
                width=6,
            ),
            dbc_col(
                dbc_container([
                    html_h3("Horizontal histogram", id="horizontal-histogram"),
                    dbc_badge("Origin", color="info", href="https://plotly.com/javascript/histograms/#basic-histogram"),
                    dbc_badge("Line: $(@__LINE__)", color="info", className="ml-1"),
                    dcc_graph(
                        figure = Plot(horizontal_histogram()...),
                        config = Dict(),
                    )
                ], className="p-3 my-2 border rounded", ),
                width=6
            ),
        ]),
        
    ]

    pushfirst!(content, navbar)
    app.layout = dbc_container(content, fluid=true)

    return app
end

function simple_histogram()
    x = rand(500)

    traces = AbstractTrace[
        histogram(
            x = x,
        ),
    ]

    layout = Layout()

    return traces, layout
end

function horizontal_histogram()
    y = rand(500)

    traces = AbstractTrace[
        histogram(
            y = y,
            marker = attr(color="pink"),
            
            
        )
    ]

    layout = Layout()

    return traces, layout
end

"""

https://plotly.com/javascript/contour-plots/
"""
function chapter_contour_plots(; app=nothing)
    if isnothing(app)
        app = dash(external_stylesheets=[dbc_themes.SPACELAB])
    end

    # https://stackoverflow.com/questions/4086107/fixed-page-header-overlaps-in-page-anchors
    # Put this in my.css
    # html {
    # scroll-padding-top: 80px; /* height of sticky header */
    # }
    navbar = dbc_navbarsimple([
        dbc_dropdownmenu([
            dbc_dropdownmenuitem("Simple contour plot", href="#simple-contour-plot", external_link=true),
            dbc_dropdownmenuitem("Simple contour plot 2", href="#simple-contour-plot2", external_link=true),
            dbc_dropdownmenuitem("Simple contour plot 3", href="#simple-contour-plot3", external_link=true),
            dbc_dropdownmenuitem("Basic contour plot", href="#basic-contour-plot", external_link=true),
            dbc_dropdownmenuitem("Basic contour plot 2", href="#basic-contour-plot2", external_link=true),
            dbc_dropdownmenuitem("Basic contour plot 3", href="#basic-contour-plot3", external_link=true),
            dbc_dropdownmenuitem("Setting x and y coordinates in a contour plot", href="#setting-x-and-y-coordinates-in-a-contour-plot", external_link=true),
            dbc_dropdownmenuitem("Colorscale for contour plot", href="#colorscale-for-contour-plot", external_link=true),
            dbc_dropdownmenuitem("Customizing size and range of a contour plot's contours", href="#customizing-size-and-range-of-a-contour-plots-contours", external_link=true),
            dbc_dropdownmenuitem("Customizing spacing between x and y ticks", href="#customizing-spacing-between-x-and-y-ticks", external_link=true),
            dbc_dropdownmenuitem("Connect the gaps between null values in the z matrix", href="#connect-the-gaps-between-null-values-in-the-z-matrix", external_link=true),
            dbc_dropdownmenuitem("Smoothing contour lines", href="#smoothing-contour-lines", external_link=true),
            dbc_dropdownmenuitem("Smooth contour coloring", href="#smooth-contour-coloring", external_link=true),
            dbc_dropdownmenuitem("Contour lines", href="#contour-lines", external_link=true),
            dbc_dropdownmenuitem("Contour line labels", href="#contour-line-labels", external_link=true),
            dbc_dropdownmenuitem("Custom colorscale for contour plot", href="#custom-colorscale-for-contour-plot", external_link=true),
            dbc_dropdownmenuitem("Styling color bar ticks for contour plots", href="#styling-color-bar-ticks-for-contour-plots", external_link=true),
            # dbc_dropdownmenuitem("", href="", external_link=true),
        ],
        in_navbar=true, label="Section", caret=true, direction="left"),
    ], 
    sticky="top", expand=true, brand="Allnix", brand_href="https://github.com/ykyang",
    )

    content = [
        dbc_container([html_h3("Simple contour plot", id="simple-contour-plot"),
            dbc_badge("Origin", color="info", href="https://plotly.com/javascript/contour-plots/#simple-contour-plot"),
            dbc_badge("Line: $(@__LINE__)", color="info", className="ml-1"),
            dcc_graph(
                figure = Plot(simple_contour_plot()...),
                config = Dict(),
            ),
        ], className="p-3 my-2 border rounded",),

        dbc_container([html_h3("Simple contour plot 2", id="simple-contour-plot2"),
            dbc_badge("Origin", color="info", href="https://plotly.com/javascript/contour-plots/#simple-contour-plot"),
            dbc_badge("Line: $(@__LINE__)", color="info", className="ml-1"),
            dcc_markdown("""
            Same as `simple_contour_plot()` but use different sizes for x and y
            to demonstrate how z-value is mapped onto the x-y grid.
            It is `z[j][i]`, where `i` is in x-direction and `j` is in y-direction.
            """),
            dcc_graph(
                figure = Plot(simple_contour_plot2()...),
                config = Dict(),
            ),
        ], className="p-3 my-2 border rounded",),

        dbc_container([html_h3("Simple contour plot 3", id="simple-contour-plot3"),
            dbc_badge("Origin", color="info", href="https://plotly.com/javascript/contour-plots/#simple-contour-plot"),
            dbc_badge("Line: $(@__LINE__)", color="info", className="ml-1"),
            dcc_markdown("""
            Same as `simple_contour_plot()` but use different sizes for x and y
            to demonstrate how z-value is mapped onto the x-y grid.
            It is `z[i,j]`, where `i` is in x-direction and `j` is in y-direction.
            """),
            dcc_graph(
                figure = Plot(simple_contour_plot3()...),
                config = Dict(),
            ),
        ], className="p-3 my-2 border rounded",),

        dbc_container([html_h3("Basic contour plot", id="basic-contour-plot"),
            dbc_badge("Origin", color="info", href="https://plotly.com/javascript/contour-plots/#basic-contour-plot"),
            dbc_badge("Line: $(@__LINE__)", color="info", className="ml-1"),
            dcc_markdown("""
            Original example uses the same length in x- and y-direction, makes it
            hard to understand the structure of `z` array of array.
            """),
            dcc_graph(
                figure = Plot(basic_contour_plot()...),
                config = Dict(),
            ),
        ], className="p-3 my-2 border rounded",),

        dbc_container([html_h3("Basic contour plot 2", id="basic-contour-plot2"),
            dbc_badge("Origin", color="info", href="https://plotly.com/javascript/contour-plots/#basic-contour-plot"),
            dbc_badge("Line: $(@__LINE__)", color="info", className="ml-1"),
            dcc_markdown("""
            The y-direction uses 50 points and the x-direction uses 100 points to
            demonstrate the structure of z array of array.

            The size of z array of array is `z[y_size][x_size]` where `y_size` is
            the number of points in the y-direction.
            """),
            dcc_graph(
                figure = Plot(basic_contour_plot2()...),
                config = Dict(),
            ),
        ], className="p-3 my-2 border rounded",),

        dbc_container([html_h3("Basic contour plot 3", id="basic-contour-plot3"),
            dbc_badge("Origin", color="info", href="https://plotly.com/javascript/contour-plots/#basic-contour-plot"),
            dbc_badge("Line: $(@__LINE__)", color="info", className="ml-1"),
            dcc_markdown("""
            Similar to the example before, but use two-dimensional array for z
            instead of array of array.

            The size of z array is `z[x_size,y_size]` where `x_size` is the 
            number of points in the x-direction.
            """),
            dcc_graph(
                figure = Plot(basic_contour_plot3()...),
                config = Dict(),
            ),
        ], className="p-3 my-2 border rounded",),

        dbc_container([html_h3("Setting x and y coordinates in a contour plot", id="setting-x-and-y-coordinates-in-a-contour-plot"),
            dbc_badge("Origin", color="info", href="https://plotly.com/javascript/contour-plots/#setting-x-and-y-coordinates-in-a-contour-plot"),
            dbc_badge("Line: $(@__LINE__)", color="info", className="ml-1"),
            dcc_graph(
                figure = Plot(setting_x_and_y_coordinates_in_a_contour_plot()...),
                config = Dict(),
            ),
        ], className="p-3 my-2 border rounded",),

        dbc_container([html_h3("Colorscale for contour plot", id="colorscale-for-contour-plot"),
            dbc_badge("Origin", color="info", href="https://plotly.com/javascript/contour-plots/#colorscale-for-contour-plot"),
            dbc_badge("Line: $(@__LINE__)", color="info", className="ml-1"),
            dcc_graph(
                figure = Plot(colorscale_for_contour_plot()...),
                config = Dict(),
            ),
        ], className="p-3 my-2 border rounded",),

        dbc_container([html_h3("Customizing size and range of a contour plot's contours", id="customizing-size-and-range-of-a-contour-plots-contours"),
            dbc_badge("Origin", color="info", href="https://plotly.com/javascript/contour-plots/#customizing-size-and-range-of-a-contour-plots-contours"),
            dbc_badge("Line: $(@__LINE__)", color="info", className="ml-1"),
            dcc_graph(
                figure = Plot(customizing_size_and_range_of_a_contour_plots_contours()...),
                config = Dict(),
            ),
        ], className="p-3 my-2 border rounded",),

        dbc_container([html_h3("Customizing spacing between x and y ticks", id="customizing-spacing-between-x-and-y-ticks"),
            dbc_badge("Origin", color="info", href="https://plotly.com/javascript/contour-plots/#customizing-spacing-between-x-and-y-ticks"),
            dbc_badge("Line: $(@__LINE__)", color="info", className="ml-1"),
            dcc_graph(
                figure = Plot(customizing_spacing_between_x_and_y_ticks()...),
                config = Dict(),
            ),
        ], className="p-3 my-2 border rounded",),
        
        dbc_container([html_h3("Connect the gaps between null values in the z matrix", id="connect-the-gaps-between-null-values-in-the-z-matrix"),
            dbc_badge("Origin", color="info", href="https://plotly.com/javascript/contour-plots/#connect-the-gaps-between-null-values-in-the-z-matrix"),
            dbc_badge("Line: $(@__LINE__)", color="info", className="ml-1"),
            dcc_graph(
                figure = Plot(connect_the_gaps_between_null_values_in_the_z_matrix()...),
                config = Dict(),
            ),
        ], className="p-3 my-2 border rounded",),

        dbc_container([html_h3("Smoothing contour lines", id="smoothing-contour-lines"),
            dbc_badge("Origin", color="info", href="https://plotly.com/javascript/contour-plots/#smoothing-contour-lines"),
            dbc_badge("Line: $(@__LINE__)", color="info", className="ml-1"),
            dcc_graph(
                figure = Plot(smoothing_contour_lines()...),
                config = Dict(),
            ),
        ], className="p-3 my-2 border rounded",),

        dbc_container([html_h3("Smooth contour coloring", id="smooth-contour-coloring"),
            dbc_badge("Origin", color="info", href="https://plotly.com/javascript/contour-plots/#smooth-contour-coloring"),
            dbc_badge("Line: $(@__LINE__)", color="info", className="ml-1"),
            dcc_graph(
                figure = Plot(smooth_contour_coloring()...),
                config = Dict(),
            ),
        ], className="p-3 my-2 border rounded",),

        dbc_container([html_h3("Contour lines", id="contour-lines"),
            dbc_badge("Origin", color="info", href="https://plotly.com/javascript/contour-plots/#contour-lines"),
            dbc_badge("Line: $(@__LINE__)", color="info", className="ml-1"),
            dcc_graph(
                figure = Plot(contour_lines()...),
                config = Dict(),
            ),
        ], className="p-3 my-2 border rounded",),

        dbc_container([html_h3("Contour line labels", id="contour-line-labels"),
            dbc_badge("Origin", color="info", href="https://plotly.com/javascript/contour-plots/#contour-line-labels"),
            dbc_badge("Line: $(@__LINE__)", color="info", className="ml-1"),
            dcc_graph(
                figure = Plot(contour_line_labels()...),
                config = Dict(),
            ),
        ], className="p-3 my-2 border rounded",),

        dbc_container([html_h3("Custom colorscale for contour plot", id="custom-colorscale-for-contour-plot"),
            dbc_badge("Origin", color="info", href="https://plotly.com/javascript/contour-plots/#custom-colorscale-for-contour-plot"),
            dbc_badge("Line: $(@__LINE__)", color="info", className="ml-1"),
            dcc_graph(
                figure = Plot(custom_colorscale_for_contour_plot()...),
                config = Dict(),
            ),
        ], className="p-3 my-2 border rounded",),

        dbc_container([html_h3("Styling color bar ticks for contour plots", id="styling-color-bar-ticks-for-contour-plots"),
            dbc_badge("Origin", color="info", href="https://plotly.com/javascript/contour-plots/#styling-color-bar-ticks-for-contour-plots"),
            dbc_badge("Line: $(@__LINE__)", color="info", className="ml-1"),
            dcc_graph(
                figure = Plot(styling_color_bar_ticks_for_contour_plots()...),
                config = Dict(),
            ),
        ], className="p-3 my-2 border rounded",),
    ]


    # during development, it is convenient to reverse
    # so the new one is at the top
    #content = reverse(content)

    pushfirst!(content, navbar)

    app.layout = dbc_container(content)

    return app
end

function simple_contour_plot()
    traces = Vector{AbstractTrace}()
    layout = Layout()

    size = 100
    x = zeros(Float64,size)
    y = zeros(Float64,size)
    z = Vector{Vector{Float64}}(undef, size) #zeros(Float64,size)
    # Number of points = (# of x) * (# of y)
    for i in 1:size
        x[i] = y[i] = -2 * pi + 4*pi*i/size
        z[i] = zeros(Float64,size)
    end
    for i in 1:size
        for j in 1:size
            r = x[i]^2 + y[j]^2
            z[i][j] = sin(x[i]) * cos(y[j]) * sin(r)/ log(r+1)
        end
    end

    push!(traces, contour(
        x = x,
        y = y,
        z = z,
    ))


    return traces, layout
end

function simple_contour_plot2()
    traces = Vector{AbstractTrace}()
    layout = Layout()

    # size = 100
    x_size = 100
    y_size = 50
    x = zeros(Float64,x_size)
    y = zeros(Float64,y_size)
    # [j][i], second dimension moves faster so it is in x-direction
    z = Vector{Vector{Float64}}(undef, y_size) #zeros(Float64,size)
    
    for i in 1:x_size
        x[i] = -2 * pi + 4*pi*i/x_size
        
    end
    for j in 1:y_size
        y[j] = -2 * pi + 4*pi*(2*j)/(2*y_size)
        z[j] = zeros(Float64, x_size)
    end

    for i in 1:x_size
        for j in 1:y_size
            r = x[i]^2 + y[j]^2
            #z[i][j] = sin(x[i]) * cos(y[j]) * sin(r)/ log(r+1)
            z[j][i] = sin(y[j]) * cos(x[i]) * sin(r)/ log(r+1)
        end
    end

    #@show x

    push!(traces, contour(
        x = x,
        y = y,
        z = z,
    ))


    return traces, layout
end

function simple_contour_plot3()
    traces = Vector{AbstractTrace}()
    layout = Layout()

    # size = 100
    x_size = 100
    y_size = 50
    x = zeros(Float64,x_size)
    y = zeros(Float64,y_size)
    #z = Vector{Vector{Float64}}(undef, x_size) #zeros(Float64,size)
    z = zeros(Float64, x_size, y_size)
    for i in 1:x_size
        x[i] = -2 * pi + 4*pi*i/x_size
    end
    for j in 1:y_size
        y[j] = -2 * pi + 4*pi*(j*2)/(y_size*2)
    end

    for j in 1:y_size
        for i in 1:x_size
            r = x[i]^2 + y[j]^2
            #z[i,j] = sin(x[i]) * cos(y[j]) * sin(r)/ log(r+1)
            z[i,j] = sin(y[j]) * cos(x[i]) * sin(r)/ log(r+1)
        end
    end

    push!(traces, contour(
        x = x,
        y = y,
        z = z,
    ))


    return traces, layout
end

function basic_contour_plot()
    traces = Vector{AbstractTrace}([
        contour(
            x = [2, 3, 4, 5, 6],
            y = [5, 6, 7, 8, 9],
            z = [[10, 10.625, 12.5, 15.625, 20],
            [5.625, 6.25, 8.125, 11.25, 15.625],
            [2.5, 3.125, 5.0, 8.125, 12.5],
            [0.625, 1.25, 3.125, 6.25, 10.625],
            [0, 0.625, 2.5, 5.625, 10]],
        )
    ])
    layout = Layout()

    return traces, layout
end

"""

Demonstrate the data mapping when using array of array. 
"""
function basic_contour_plot2()
    traces = Vector{AbstractTrace}([
        contour(
            x = [2, 3, 4, 5, 6],
            y = [5, 6, 7, 8],
            z = [            
                [10, 10.625, 12.5, 15.625, 20],      # y = 5, x = [2, 3, 4, 5, 6]
                [5.625, 6.25, 8.125, 11.25, 15.625], # y = 6, x = [2, 3, 4, 5, 6]
                [2.5, 3.125, 5.0, 8.125, 12.5],
                [0.625, 1.25, 3.125, 6.25, 10.625],
                #[0, 0.625, 2.5, 5.625, 10]
            ],
        )
    ])
    layout = Layout()

    return traces, layout
end

"""

Demonstrate the data mapping when using 2-dimensional array. 
"""
function basic_contour_plot3()
    # z = [
    #     10.0    10.625  12.5    15.625  20.0;
    #     5.625   6.25    8.125  11.25   15.625;
    #     2.5     3.125   5.0     8.125  12.5;
    #     0.625   1.25    3.125   6.25   10.625;
    # ]
    z = [
        # x,y=5     x,y=6     x,y=7     x,y=8 
        10.0        5.625     2.5       0.625
        10.625      6.25      3.125     1.25
        12.5        8.125     5.0       3.125
        15.625     11.25      8.125     6.25
        20.0       15.625    12.5      10.625
    ]
    traces = Vector{AbstractTrace}([
        contour(
            x = [2, 3, 4, 5, 6],
            y = [5, 6, 7, 8],
            z = z,
        )
    ])
    layout = Layout()

    return traces, layout
end

function setting_x_and_y_coordinates_in_a_contour_plot()
    traces = Vector{AbstractTrace}()
    layout = Layout(
        title = "Setting the X and Y Coordinates in a Contour Plot"
    )

    # Copied from web
    z_original = [ # this should be seen as 5 vertical arrays
        [10, 10.625, 12.5, 15.625, 20],
        [5.625, 6.25, 8.125, 11.25, 15.625],
        [2.5, 3.125, 5., 8.125, 12.5],
        [0.625, 1.25, 3.125, 6.25, 10.625], 
        [0, 0.625, 2.5, 5.625, 10]
    ]

    x = Vector{Float64}([-9, -6, -5 , -3, -1])
    y = Vector{Float64}([0, 1, 4, 5, 7])
    # z[1,:] = z_original[1]
    z = hcat(z_original...) #Array{Float64,2}(undef, 5, 5)
    #@show size(z) # size(z) = (5, 5)

    trace = contour(
        x = x,
        y = y,
        z = z,
    )
    push!(traces, trace)

    return traces, layout
end

function colorscale_for_contour_plot()
    traces = Vector{AbstractTrace}()
    layout = Layout(
        title = "Colorscale for Contour Plot"
    )

    # Copied from web
    z_original = [ # this should be seen as 5 vertical arrays
        [10, 10.625, 12.5, 15.625, 20],
        [5.625, 6.25, 8.125, 11.25, 15.625],
        [2.5, 3.125, 5., 8.125, 12.5],
        [0.625, 1.25, 3.125, 6.25, 10.625], 
        [0, 0.625, 2.5, 5.625, 10]
    ]

    x = Vector{Float64}([-9, -6, -5 , -3, -1])
    y = Vector{Float64}([0, 1, 4, 5, 7])
    # z[1,:] = z_original[1]
    z = hcat(z_original...) #Array{Float64,2}(undef, 5, 5)

    trace = contour(
        x = x, y = y, z = z,
        colorscale = "Jet",
    )
    push!(traces, trace)

    return traces, layout
end

function customizing_size_and_range_of_a_contour_plots_contours()
    traces = Vector{AbstractTrace}()
    layout = Layout(
        title = "Customizing Size and Range of Contours"
    )

    # Copied from web
    z_original = [ # this should be seen as 5 vertical arrays
        [10, 10.625, 12.5, 15.625, 20],
        [5.625, 6.25, 8.125, 11.25, 15.625],
        [2.5, 3.125, 5., 8.125, 12.5],
        [0.625, 1.25, 3.125, 6.25, 10.625], 
        [0, 0.625, 2.5, 5.625, 10]
    ]

    #x = Vector{Float64}([-9, -6, -5 , -3, -1])
    #y = Vector{Float64}([0, 1, 4, 5, 7])
    z = hcat(z_original...) #Array{Float64,2}(undef, 5, 5)

    push!(traces, contour(
        z = z,
        colorscale = "Jet",
        autocontour = false,
        contours = Dict(
            :start => 0,
            :end => 8,
            :size => 2,
        )
    ))

    return traces, layout
end

function customizing_spacing_between_x_and_y_ticks()
    traces = Vector{AbstractTrace}()
    layout = Layout(
        title = "Customizing Spacing Between X and Y Axis Ticks",
    )

    # Copied from web
    z_original = [ # this should be seen as 5 vertical arrays
        [10, 10.625, 12.5, 15.625, 20],
        [5.625, 6.25, 8.125, 11.25, 15.625],
        [2.5, 3.125, 5., 8.125, 12.5],
        [0.625, 1.25, 3.125, 6.25, 10.625], 
        [0, 0.625, 2.5, 5.625, 10]
    ]

    z = hcat(z_original...) #Array{Float64,2}(undef, 5, 5)

    push!(traces, contour(
        z = z, colorscale = "Jet",
        x0 =  5, dx = 10,
        y0 = 10, dy = 10,

    ))

    return traces, layout
end

function connect_the_gaps_between_null_values_in_the_z_matrix()
    z = [[missing, missing, missing, 12, 13, 14, 15, 16],
      [missing, 1, missing, 11, missing, missing, missing, 17],
      [missing, 2, 6, 7, missing, missing, missing, 18],
      [missing, 3, missing, 8, missing, missing, missing, 19],
      [5, 4, 10, 9, missing, missing, missing, 20],
      [missing, missing, missing, 27, missing, missing, missing, 21],
      [missing, missing, missing, 26, 25, 24, 23, 22]]

    traces = Vector{AbstractTrace}([
        contour(
            name = "Gaps",
            z = z,
            showscale = false,
            xaxis = "x1", yaxis = "y1",
        ),
        contour(
            name = "No gaps",
            connectgaps = true,    
            z = z,
            showscale = false,
            xaxis = "x2", yaxis = "y2",
        ),
        heatmap(
            naem = "Gaps",
            zsmooth = "best", # comment out to have blocks with constant value
            z = z,
            showscale = false,
            xaxis = "x3", yaxis = "y3",
        ),
        heatmap(
            name = "No gaps",
            connectgaps = true,
            zsmooth = "best",
            z = z,
            showscale = false,
            xaxis = "x4", yaxis = "y4",
        ),
    ])
    layout = Layout(
        
        title = "Connect the Gaps Between Null Values in the z Matrix",
        # Fine control of the placement of axes

        xaxis = Dict(:domain=>[0, 0.45], :anchor=>"y1"),
        yaxis = Dict(:domain=>[0.55, 1], :anchor=>"x1"),
        
        xaxis2 = Dict(:domain=>[0.55, 1], :anchor=>"y2"),
        yaxis2 = Dict(:domain=>[0.55, 1], :anchor=>"x2"),

        xaxis3 = Dict(:domain=>[0, 0.45], :anchor=>"y3"),
        yaxis3 = Dict(:domain=>[0, 0.45], :anchor=>"x3"),

        xaxis4 = Dict(:domain=>[0.55, 1], :anchor=>"y4"),
        yaxis4 = Dict(:domain=>[0, 0.45], :anchor=>"x4"),
    )



    return traces, layout
end

function smoothing_contour_lines()
    z = [
            [2, 4, 7, 12, 13, 14, 15, 16],
            [3, 1, 6, 11, 12, 13, 16, 17],
            [4, 2, 7, 7, 11, 14, 17, 18],
            [5, 3, 8, 8, 13, 15, 18, 19],
            [7, 4, 10, 9, 16, 18, 20, 19],
            [9, 10, 5, 27, 23, 21, 21, 21],
            [11, 14, 17, 26, 25, 24, 23, 22]
        ]

    traces = Vector{AbstractTrace}([
        contour(
            z = z,
            xaxis = "x1", yaxis = "y1",
            line = Dict(
                :smoothing => 0,
            ),
        ),
        contour(
            z = z,
            xaxis = "x2", yaxis = "y2",
            line = Dict(
                :smoothing => 0.85,
            ),
        ),
    ])

    layout = Layout(
        title = "Smoothing Contour Lines",
        xaxis  = Dict(
            :domain => [0, 0.45], :anchor => "y1",
        ),
        xaxis2 = Dict(
            :domain => [0.55, 1], :anchor => "y2",
        ),
        yaxis  = Dict(
            :domain => [0, 1], :anchor => "x1",
        ),
        yaxis2 = Dict(
            :domain => [0, 1], :anchor => "x2",
        ),
    )

    return traces, layout
end

function smooth_contour_coloring()
    z = [
            [10, 10.625, 12.5, 15.625, 20],
            [5.625, 6.25, 8.125, 11.25, 15.625],
            [2.5, 3.125, 5., 8.125, 12.5],
            [0.625, 1.25, 3.125, 6.25, 10.625],
            [0, 0.625, 2.5, 5.625, 10]
        ]

    traces = Vector{AbstractTrace}([
        contour(
            z = z,
            contours = Dict(
                :coloring => "heatmap",
            )
        )
    ])

    layout = Layout(
        title = "Smooth Contour Coloring",
    )

    return traces, layout
end

function contour_lines()
    z = [
        [10, 10.625, 12.5, 15.625, 20],
        [5.625, 6.25, 8.125, 11.25, 15.625],
        [2.5, 3.125, 5., 8.125, 12.5],
        [0.625, 1.25, 3.125, 6.25, 10.625],
        [0, 0.625, 2.5, 5.625, 10]
    ]

    traces = Vector{AbstractTrace}([
        contour(
            z = z,
            colorscale = "Jet",
            contours = Dict(
                :coloring => "lines",
            )
        ),
    ])
    layout = Layout(
        title = "Contour Lines",
    )

    return traces, layout
end

function contour_line_labels()
    z = [
        [10, 10.625, 12.5, 15.625, 20],
        [5.625, 6.25, 8.125, 11.25, 15.625],
        [2.5, 3.125, 5., 8.125, 12.5],
        [0.625, 1.25, 3.125, 6.25, 10.625],
        [0, 0.625, 2.5, 5.625, 10]
    ]

    traces = Vector{AbstractTrace}([
        contour(
            z = z,
            contours = Dict(
                :coloring => "heatmap",
                :showlabels => true,
                :labelfont => Dict(
                    :family => "Raleway",
                    :size => 12,
                    :color => "white",

                )
            )
        )
    ])
    layout = Layout(
        title = "Contour with Labels"
    )

    return traces, layout
end

function custom_colorscale_for_contour_plot()
    z = [
        [10, 10.625, 12.5, 15.625, 20],
        [5.625, 6.25, 8.125, 11.25, 15.625],
        [2.5, 3.125, 5., 8.125, 12.5],
        [0.625, 1.25, 3.125, 6.25, 10.625],
        [0, 0.625, 2.5, 5.625, 10]
    ]

    traces = Vector{AbstractTrace}([
        contour(
            z = z,
            colorscale = [
                [0, "rgb(166,206,227)"],
                [0.25, "rgb(31,120,180)"], 
                [0.45, "rgb(178,223,138)"], 
                [0.65, "rgb(51,160,44)"], 
                [0.85, "rgb(251,154,153)"], 
                [1, "rgb(227,26,28)"]
            ],
            colorbar = Dict(
                :title => "Color Bar Title",
                :titleside => "right",
                :titlefont => Dict(
                    :size => 14,
                    :family => "Arial, sans-serif",
                ),
                :thickness => 10,
                :thicknessmode => "pixels",
                :len => 0.5, # length of the color bar
                :lenmode => "fraction",
                :outlinewidth => 1,
            ),
        )
    ])
    layout = Layout(
        title = "Custom Contour Plot Colorscale & Colorbar Title"
    )

    return traces, layout
end

# color bar title is combined in the example above
# color bar size is combined in the example above

function styling_color_bar_ticks_for_contour_plots()
    z = [
        [10, 10.625, 12.5, 15.625, 20],
        [5.625, 6.25, 8.125, 11.25, 15.625],
        [2.5, 3.125, 5., 8.125, 12.5],
        [0.625, 1.25, 3.125, 6.25, 10.625],
        [0, 0.625, 2.5, 5.625, 10]
    ]

    traces = Vector{AbstractTrace}([
        contour(
            z = z,
            colorbar = Dict(
                :ticks     => "outside",
                :dtick     => 1, # distance tick or frequencey?
                :tickwidth => 2,
                :ticklen   => 10,
                :tickcolor => "grey",
                :showticklabels => true,
                :tickfont => Dict(
                    :size => 15,
                ),
                :xpad => 50,
            ),
        )
    ])
    layout = Layout(
        title = "Styling Color Bar Ticks for Contour Plots"
    )

    return traces, layout
end

"""

https://plotly.com/javascript/heatmaps/
"""
function chapter_heatmaps(; app=nothing)
    if isnothing(app)
        app = dash(external_stylesheets=[dbc_themes.SPACELAB])
    end

    # https://stackoverflow.com/questions/4086107/fixed-page-header-overlaps-in-page-anchors
    # Put this in my.css
    # html {
    # scroll-padding-top: 80px; /* height of sticky header */
    # }
    navbar = dbc_navbarsimple([
        dbc_dropdownmenu([
            dbc_dropdownmenuitem("Basic heatmap", href="#basic-heatmap", external_link=true),
            dbc_dropdownmenuitem("Heatmap with categorical axis labels", href="#heatmap-with-categorical-axis-labels", external_link=true),
            dbc_dropdownmenuitem("Annotated heatmap", href="#annotated-heatmap", external_link=true),
            dbc_dropdownmenuitem("Heatmap with unequal block sizes", href="#heatmap-with-unequal-block-sizes", external_link=true),
            # dbc_dropdownmenuitem("", href="", external_link=true),
        ],
        in_navbar=true, label="Section", caret=true, direction="left"),
    ], 
    sticky="top", 
    #expand=true, 
    fluid=true,
    brand="Allnix", brand_href="https://github.com/ykyang",
    )

    content = [
        dbc_container([html_h3("Basic heatmap", id="basic-heatmap"),
            dbc_badge("Origin", color="info", href="https://plotly.com/javascript/heatmaps/#basic-heatmap"),
            dbc_badge("Line: $(@__LINE__)", color="info", className="ml-1"),
            dcc_graph(
                figure = Plot(basic_heatmap()...),
                config = Dict(),
            ),
        ], className="p-3 my-2 border rounded", fluid=true),

        dbc_container([html_h3("Heatmap with categorical axis labels", id="heatmap-with-categorical-axis-labels"),
            dbc_badge("Origin", color="info", href="https://plotly.com/javascript/heatmaps/#heatmap-with-categorical-axis-labels"),
            dbc_badge("Line: $(@__LINE__)", color="info", className="ml-1"),
            dcc_graph(
                figure = Plot(heatmap_with_categorical_axis_labels()...),
                config = Dict(),
            ),
        ], className="p-3 my-2 border rounded",),

        dbc_container([html_h3("Annotated heatmap", id="annotated-heatmap"),
            dbc_badge("Origin", color="info", href="https://plotly.com/javascript/heatmaps/#annotated-heatmap"),
            dbc_badge("Line: $(@__LINE__)", color="info", className="ml-1"),
            dcc_graph(
                figure = Plot(annotated_heatmap()...),
                config = Dict(),
            ),
        ], className="p-3 my-2 border rounded",),

        dbc_container([html_h3("Heatmap with unequal block sizes", id="heatmap-with-unequal-block-sizes"),
            dbc_badge("Origin", color="info", href="https://plotly.com/javascript/heatmaps/#annotated-heatmap"),
            dbc_badge("Line: $(@__LINE__)", color="info", className="ml-1"),
            dcc_graph(
                figure = Plot(heatmap_with_unequal_block_sizes()...),
                config = Dict(),
            ),
        ], className="p-3 my-2 border rounded",),
    ]


    # during development, it is convenient to reverse
    # so the new one is at the top
    #content = reverse(content)

    pushfirst!(content, navbar)

    app.layout = dbc_container(
            content, 
            fluid=true,  # expand with window
            #fluid=false, # not expand with window
        )

    return app
end

function basic_heatmap()
    z =  [[1, 20, 30], [20, 1, 60], [30, 60, 1]]
    z = hcat(z...)

    traces = Vector{AbstractTrace}([
        heatmap(
            x = [0, 1, 3, 4], # boundary of grid in x-direction
            y = [0, 1, 3, 4],
            z = z,
            showscale = true,
            xgap = 3,
            ygap = 3,
        )
    ])
    layout = Layout(
        xaxis=Dict(
            :range=>[0, 4],
        ),
        yaxis=Dict(
            :range=>[0, 4],
            # https://stackoverflow.com/questions/31033791/plotly-same-scale-for-x-and-y-axis
            :scaleanchor=>"x", 
            :scaleratio=>1,
        ),
        width  = 500,
        height = 500,
    )

    return traces, layout
end

function heatmap_with_categorical_axis_labels()
    z = [[1, missing, 30, 50, 1], [20, 1, 60, 80, 30], [30, 60, 1, -10, 20]]
    z = hcat(z...)
    x = ["Monday", "Tuesday", "Wednesday", "Thursday", "Friday"]
    y = ["Morning", "Afternoon", "Evening"]

    traces = Vector{AbstractTrace}([
        heatmap(
            x = x, y = y, z = z,
            hoverongaps = false, # disable showing null value

        )
    ])
    layout = Layout()

    return traces, layout
end

function annotated_heatmap()
    x = ["A", "B", "C", "D", "E"]
    y = ["W", "X", "Y", "Z"]
    z = [
        [0.00, 0.00, 0.75, 0.75, 0.00],
        [0.00, 0.00, 0.75, 0.75, 0.00],
        [0.75, 0.75, 0.75, 0.75, 0.75],
        [0.00, 0.00, 0.00, 0.75, 0.00],
    ]

    colorscale = [
        [0, "#3D9970"],
        [1, "#001f3f"],
    ]

    traces = Vector{AbstractTrace}([
        heatmap(
            x = x, y = y, z = z,
            colorscale = colorscale,
            showscale = false,
        )
    ])
    layout = Layout(
        title = "Annotated Heatmap",
        xaxis = Dict(
            :ticks => "",
            :side => "top",
        ),
        yaxis = Dict(
            :ticks => "",
            :ticksuffix => " ", # extra space
            #:width => 700,
            #:height => 700,
        ),
        width = 600,
        height = 400,
        autosize = false,
        annotations = [],
    )

    annotations = layout["annotations"]
    #@show annotations
    for j in 1:length(y)
        for i in 1:length(x)
            v = z[j][i]
            if v != 0.0
                textcolor = "white"
            else
                textcolor = "black"
            end

            item = Dict(
                :xref => "x1",
                :yref => "y1",
                :x => x[i],
                :y => y[j],
                :text => v,
                :showarrow => false,
                :font => Dict(
                    :family => "Arial",
                    :size => 12,
                    :color => textcolor
                )
            )

            push!(annotations,item)
        end
    end

    return traces, layout
end

function heatmap_with_unequal_block_sizes()
    traces = Vector{AbstractTrace}([])
    axis = Dict( # for both x- and y-axis
        :range => [0, 1.6], # 1.6 cut off the spiral on the right
        :autorange => false,
        :showgrid => false,
        :zeroline => false,
        :linecolor => "black",
        :showticklabels => false,
        :ticks => "",
    )
    layout = Layout(
        title = "Heatmap with Unequal Block Sizes",
        margin = Dict(
            :t => 50, :r => 50, :b => 50, :l => 50,
        ),
        showlegend = false,
        width = 500,
        height = 500,
        xaxis = axis,
        yaxis = axis,
        autosize = false,
    )

    # use range(a,b,length=n) for linspace(a,b,n)

    # Build the spiral
    nspiral = 2 # number of spiral loops
    theta_list = range(-pi/13, 2*pi*nspiral, length=1000)
    #@show theta_list
    

    x_vec = Vector{Float64}()
    y_vec = Vector{Float64}()
    #yshift_vec = Vector{Float64}() 
    finalx_vec = Vector{Float64}()
    finaly_vec = Vector{Float64}()

    for theta in theta_list
        a = 1.120529
        b = 0.306349
        r = a*exp(-b*theta)
        x = r * cos(theta)
        y = r * sin(theta)

        push!(x_vec, x)
        push!(y_vec, y)
    end

    # use maximum for getMaxOfArray
    # use minimum for getMinOfArray

    yshift = 0.5 * (1.6 - (maximum(y_vec) - minimum(y_vec)))
    #yshift = (1.6 - (maximum(y_vec) - minimum(y_vec)))
    #@show yshift

    spiral_trace = scatter(
        x = map(x->(-x + x_vec[1]         ), x_vec),
        y = map(y->(+y - y_vec[1] + yshift), y_vec),
        line = Dict(
            #:color => "white",
            :width => 3,
        )
    )
    push!(traces, spiral_trace)

    # Build the heatmap
    phi = 0.5*(1.0 + sqrt(5))
    #@show phi
    xe = Vector{Float64}([ # x-edge
      0, 1, (1 + (1/phi^4)), (1 + (1/phi^3)), phi,
    ])
    #@show xe
    ye = Vector{Float64}([ # y-edge
        0, (1/phi^3), (1/phi^3)+(1/phi^4), 1/phi^2, 1,
    ])
    #@show ye.+yshift
    #ye = ye .+ yshift 
    z_vvec = [
        [13, 3, 3, 5],
        [13, 2, 1, 5],
        [13, 10, 11, 12],
        [13, 8, 8, 8]
    ]
    z_mat = hcat(z_vvec...)

    hm = heatmap(
        x = xe,
        y = ye .+ yshift,
        z = z_mat,
        colorscale = "Viridis",
    )
    push!(traces, hm)

    return traces, layout
end

# 3D Charts                                                            3D Charts

"""
    chapter_3d_scatter_plots(; app=nothing)

https://plotly.com/javascript/3d-scatter-plots/
"""
function chapter_3d_scatter_plots(; app=nothing)
    if isnothing(app)
        app = dash(external_stylesheets=[dbc_themes.SPACELAB])
    end

    # https://stackoverflow.com/questions/4086107/fixed-page-header-overlaps-in-page-anchors
    # Put this in my.css
    # html {
    # scroll-padding-top: 80px; /* height of sticky header */
    # }
    navbar = dbc_navbarsimple([
        dbc_dropdownmenu([
            dbc_dropdownmenuitem("3D scatter plot", href="#3d-scatter-plot", external_link=true),
            
            # dbc_dropdownmenuitem("", href="", external_link=true),
        ],
        in_navbar=true, label="Section", caret=true, direction="left"),
    ], 
    sticky="top", expand=true, brand="Allnix", brand_href="https://github.com/ykyang",
    )

    content = [
        dbc_container([html_h3("3D scatter plot", id="3d-scatter-plot"),
            dbc_badge("Origin", color="info", href="https://plotly.com/javascript/3d-scatter-plots/#3d-scatter-plot"),
            dbc_badge("Line: $(@__LINE__)", color="info", className="ml-1"),
            dcc_graph(
                figure = Plot(_3d_scatter_plot()...),
                config = Dict(),
            ),
        ], className="p-3 my-2 border rounded",),

        
    ]


    # during development, it is convenient to reverse
    # so the new one is at the top
    content = reverse(content)

    pushfirst!(content, navbar)

    app.layout = dbc_container(content)

    return app
end

function chapter_3d_scatter_plot()
    url = "https://raw.githubusercontent.com/plotly/datasets/master/3d-scatter.csv"
    body = HTTP.get(url).body
    csv = CSV.File(body)
    #@show csv
    df = DataFrame(csv)
    #@show df
    

    traces = Vector{AbstractTrace}([
        scatter3d(
            x = df[!,"x1"], y = df[!,"y1"], z = df[!,"z1"],
            mode = "markers",
            marker = Dict(
                :size => 12,
                :opacity => 1.0, #0.8,
                :line => Dict(
                    #:color => "rgba(217,217,217,0.14)",
                    :color => "rgba(217,217,217,1)",
                    :width => 0.5,
                ),
            ),
        ),
        scatter3d(
            x = df[!,"x2"], y = df[!,"y2"], z = df[!,"z2"],
            mode = "markers",
            marker = Dict(
                :color => "rgb(127,127,127)",
                :size => 12,
                :opacity => 1.0, #0.8,
                :symbol => "circle", # ???
                :line => Dict(
                    :color => "rgb(204,204,204)",
                    :width => 1,
                ),
            )
        )
    ])
    layout = Layout(
        margin = Dict(
            :l => 0, :r => 0, :b => 0, :t => 0,
        ),
        showlegend = false,
        width = 800,
        height = 600,

    )

    return traces, layout
end

function chapter_3d_surface_plots(; app=nothing)
    if isnothing(app)
        app = dash(external_stylesheets=[dbc_themes.SPACELAB])
    end

    # https://stackoverflow.com/questions/4086107/fixed-page-header-overlaps-in-page-anchors
    # Put this in my.css
    # html {
    # scroll-padding-top: 80px; /* height of sticky header */
    # }
    navbar = dbc_navbarsimple([
        dbc_dropdownmenu([
            dbc_dropdownmenuitem("Topographical 3D surface plot", href="#topographical-3d-surface-plot", external_link=true),
            dbc_dropdownmenuitem("Surface plot with contours", href="#surface-plot-with-contours", external_link=true),
            dbc_dropdownmenuitem("Multiple 3D surface plots", href="#multiple-3d-surface-plots", external_link=true),
            # dbc_dropdownmenuitem("", href="", external_link=true),
        ],
        in_navbar=true, label="Section", caret=true, direction="left"),
    ], 
    sticky="top", expand=true, brand="Allnix", brand_href="https://github.com/ykyang",
    )

    content = [
        dbc_container([html_h3("Topographical 3D surface plot", id="topographical-3d-surface-plot"),
            dbc_badge("Origin", color="info", href="https://plotly.com/javascript/3d-surface-plots/#topographical-3d-surface-plot"),
            dbc_badge("Line: $(@__LINE__)", color="info", className="ml-1"),
            dcc_graph(
                figure = Plot(topographical_3d_surface_plot()...),
                config = Dict(),
            ),
        ], className="p-3 my-2 border rounded",),

        dbc_container([html_h3("Surface plot with contours", id="surface-plot-with-contours"),
            dbc_badge("Origin", color="info", href="https://plotly.com/javascript/3d-surface-plots/#surface-plot-with-contours"),
            dbc_badge("Line: $(@__LINE__)", color="info", className="ml-1"),
            dcc_graph(
                figure = Plot(surface_plot_with_contours()...),
                config = Dict(),
            ),
        ], className="p-3 my-2 border rounded",),
        
        dbc_container([html_h3("Multiple 3D surface plots", id="multiple-3d-surface-plots"),
            dbc_badge("Origin", color="info", href="https://plotly.com/javascript/3d-surface-plots/#multiple-3d-surface-plots"),
            dbc_badge("Line: $(@__LINE__)", color="info", className="ml-1"),
            dcc_graph(
                figure = Plot(multiple_3d_surface_plots()...),
                config = Dict(),
            ),
        ], className="p-3 my-2 border rounded",),
    ]


    # during development, it is convenient to reverse
    # so the new one is at the top
    content = reverse(content)

    pushfirst!(content, navbar)

    app.layout = dbc_container(content)

    return app
end

function topographical_3d_surface_plot()
    url = "https://raw.githubusercontent.com/plotly/datasets/master/api_docs/mt_bruno_elevation.csv"
    body = HTTP.get(url).body
    csv = CSV.File(body)
    #@show csv
    df = DataFrame(csv)
    z = convert(Matrix{Float64}, df[!,2:25])
        

    traces = Vector{AbstractTrace}([
        surface(
            z = z
        )
    ])
    layout = Layout(
        title = "Mt Bruno Elevation",
        autosize = false,
        width = 500,
        height = 500,
        margin = Dict(
            :l => 65, :r => 50, :b => 65, :t => 90,
        ),
    )

    return traces, layout
end

function surface_plot_with_contours()
    url = "https://raw.githubusercontent.com/plotly/datasets/master/api_docs/mt_bruno_elevation.csv"
    body = HTTP.get(url).body
    csv = CSV.File(body)
    #@show csv
    df = DataFrame(csv)
    z = convert(Matrix{Float64}, df[!,2:25])
    
    traces = Vector{AbstractTrace}([
        surface(
            z = z,
            contours = Dict(
                :z => Dict(
                    :show => true,
                    :usecolormap => true,
                    :highlightcolor => "#42f462",
                    :project => Dict(:z => true), # contour lines at the ceiling and floor
                )
            ),
        )
    ])
    layout = Layout(
        title = "Mt Bruno Elevaion With Projected Contours",
        scene = Dict(
            :camera => Dict(
                :eye => Dict(:x => 1.87, :y => 0.88, :z => -0.64),
            ),
        ),
        autosize = false,
        width = 500, height = 500,
        margin = Dict(
            :l => 65, :r => 50, :b => 65, :t => 90,
        ),
    )

    return traces, layout
end

function multiple_3d_surface_plots()
    z = [
        [8.83,8.89,8.81,8.87,8.9,8.87],
        [8.89,8.94,8.85,8.94,8.96,8.92],
        [8.84,8.9,8.82,8.92,8.93,8.91],
        [8.79,8.85,8.79,8.9,8.94,8.92],
        [8.79,8.88,8.81,8.9,8.95,8.92],
        [8.8,8.82,8.78,8.91,8.94,8.92],
        [8.75,8.78,8.77,8.91,8.95,8.92],
        [8.8,8.8,8.77,8.91,8.95,8.94],
        [8.74,8.81,8.76,8.93,8.98,8.99],
        [8.89,8.99,8.92,9.1,9.13,9.11],
        [8.97,8.97,8.91,9.09,9.11,9.11],
        [9.04,9.08,9.05,9.25,9.28,9.27],
        [9,9.01,9,9.2,9.23,9.2],
        [8.99,8.99,8.98,9.18,9.2,9.19],
        [8.93,8.97,8.97,9.18,9.2,9.18]
    ]

    z1 = hcat(z...)

    traces = Vector{AbstractTrace}([
        surface( # 1
            z = z1,
        ),
        surface( # 2
            z = z1 .+ 1,
            showscale = false, # otherwise there will be overlapping of the same scale
            opacity = 0.8,
        ),
        surface( # 3
            z = z1 .- 1,
            showscale = false,
            opacity = 0.8,
        )

    ])
    layout = Layout()

    return traces, layout
end

"""

https://plotly.com/javascript/3d-mesh/
"""
function chapter_3d_mesh_plots(; 
    app=dash(external_stylesheets=[dbc_themes.SPACELAB])
    )
end

function simple_3d_mesh_plot()
    a = rand(50)
    b = rand(50)
    c = rand(50)

    traces = AbstractTrace[
        mesh3d(
            opacity = 0.8,
            color = "rgb(300,100,200)",
            x = a, y = b, z = c,
        ),
    ]

    layout = Layout()

    return traces, layout
end
#savefig(Plot(simple_3d_mesh_plot()...), "plot.html")

function _3d_mesh_plot_with_alphahull()
    a = rand(50)
    b = rand(50)
    c = rand(50)

    traces = AbstractTrace[
        mesh3d(
            alphahull = 0,
            opacity = 0.8,
            color = "rgb(200,100,300)",
            x = a, y = b, z = c,
        ),
    ]

    layout = Layout()

    return traces, layout
end
#savefig(Plot(_3d_mesh_plot_with_alphahull()...), "plot.html")

function _3d_mesh_tetrahedron()
end

function _3d_mesh_cube()
    intensity = [0, 0.14285714285714285, 0.2857142857142857, 0.42857142857142855, 0.5714285714285714, 0.7142857142857143, 0.8571428571428571, 1]
    intensity = range(0, 1, length=12)
    traces = AbstractTrace[
        mesh3d(
            x = [0, 0, 1, 1, 0, 0, 1, 1],
            y = [0, 1, 1, 0, 0, 1, 1, 0],
            z = [0, 0, 0, 0, 1, 1, 1, 1],
            i = [7, 0, 0, 0, 4, 4, 6, 6, 4, 0, 3, 2],
            j = [3, 4, 1, 2, 5, 6, 5, 2, 0, 1, 6, 3],
            k = [0, 7, 2, 3, 6, 7, 1, 1, 5, 5, 7, 6],
            intensity = intensity,
            intensitymode = "cell",
            colorscale = [
                [0, "rgb(255, 0, 255)"],
                [0.5, "rgb(0, 255, 0)"],
                [1, "rgb(0, 0, 255)"]
            ]
        )
    ]

    layout = Layout()

    return traces, layout
end

# Subplots                                                              Subplots
# TODO: chapter Dash driver
function simple_subplot()
    traces = AbstractTrace[
        scatter(
            x = [1,2,3],
            y = [4,5,6],
        ),
        scatter(
            x = [20, 30, 40],
            y = [50, 60, 70],
            xaxis = "x2",
            yaxis = "y2",
        ),
    ]
    layout = Layout(
        grid = attr(
            rows=1, columns=2, pattern="independent",
        )
    )

    return traces, layout
end

function subplots_with_shared_axes()
    traces = AbstractTrace[
        scatter(
            x = [1,2,3], y = [2,3,4],
        ),
        scatter(
            x = [20, 30, 40], y = [5, 5, 5],
            xaxis = "x2", yaxis = "y",
        ),
        scatter(
            x = [2, 3, 4], y = [600, 700, 800],
            xaxis = "x", yaxis = "y3",
        ),
        scatter(
            x = [4000, 5000, 6000], y = [7000, 8000, 9000],
            xaxis = "x4", yaxis = "y4",
        )
    ]
    layout = Layout(
        grid = attr(
            rows=2, columns=2,
            subplots=[["xy", "x2y"], ["xy3", "x4y4"]],
            roworder="bottom to top"
        )
    )

    return traces, layout
end

# x-axis are synchronized
function subplots_with_shared_axes2()
    traces = AbstractTrace[
        scatter(
            x = [1,2,3], y = [2,3,4],
            xaxis = "x", yaxis="y",
        ),
        # 2 traces in one plot
        scatter(
            x = [2, 3, 4], y = [5, 4, 2],
            xaxis = "x2", yaxis = "y2",
        ),
        scatter(
            x = [2, 3, 4], y = [5, 1, 3],
            xaxis = "x2", yaxis = "y2",
        ),
        scatter(
            x = [2, 3, 4], y = [600, 700, 800],
            xaxis = "x3", yaxis = "y3",
        ),
        scatter(
            x = [4, 5, 6], y = [7000, 8000, 9000],
            xaxis = "x4", yaxis = "y4",
        )
    ]
    layout = Layout(
        grid = attr(
            rows=2, columns=2,
            subplots=[["xy", "x2y2"], ["x3y3", "x4y4"]],
            #roworder="bottom to top"
            roworder="top to bottom"
        ),
        xaxis = attr(
            matches="x2"
        ),
        xaxis2 = attr(
            matches="x3"            
        ),
        xaxis3 = attr(
            matches="x4"            
        )
    )

    return traces, layout
end

# Use this to plot without Dash
#savefig(Plot(_3d_mesh_cube()...), "plot.html")
#display(plot(basic_heatmap()...))
#display(plot(simple_subplot()...))
#display(plot(subplots_with_shared_axes()...))
display(plot(subplots_with_shared_axes2()...))