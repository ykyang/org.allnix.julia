# Follows https://plotly.com/javascript/

using Dash, DashHtmlComponents, DashCoreComponents, DashBootstrapComponents
using PlotlyJS, HTTP, CSV

"""

https://plotly.com/javascript/configuration-options/
"""
function configuration_options(; app=nothing)
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

"""

https://plotly.com/javascript/line-and-scatter/
"""
function scatter_plots(; app=nothing)
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
function line_charts(; app = nothing)
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

        dbc_container([html_h3("Graph and axes titles", id="graph_and_axes_titles"),
            dbc_badge("Origin", color="info", href="https://plotly.com/javascript/line-charts/#graph-and-axes-titles"),
            dbc_badge("Line: $(@__LINE__)", color="info", className="ml-1"),
            dcc_graph(
                figure = Plot(graph_and_axes_titles()...),
                config = Dict(),
            ),
        ], className="p-3 my-2 border rounded"),

        dbc_container([html_h3("Line dash", id="line_dash"),
            dbc_badge("Origin", color="info", href="https://plotly.com/javascript/line-charts/#line-dash"),
            dbc_badge("Line: $(@__LINE__)", color="info", className="ml-1"),
            dcc_graph(
                figure = Plot(line_dash()...),
                config = Dict(),
            ),
        ], className="p-3 my-2 border rounded"),

        dbc_container([html_h3("Connect gaps between data", id="connect_gaps_between_data"),
            dbc_badge("Origin", color="info", href="https://plotly.com/javascript/line-charts/#connect-gaps-between-data"),
            dbc_badge("Line: $(@__LINE__)", color="info", className="ml-1"),
            dcc_graph(
                figure = Plot(connect_gaps_between_data()...),
                config = Dict(),
            ),
        ], className="p-3 my-2 border rounded"),

        dbc_container([html_h3("Labelling lines with annotations", id="labelling_lines_with_annotations"),
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
            
        ),
        annotations = [],
    )

    #@show layout["annotations"]


    return traces, layout
end