# Follows https://plotly.com/javascript/

using Dash, DashHtmlComponents, DashCoreComponents, DashBootstrapComponents
using PlotlyJS, HTTP, CSV
using DataFrames

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
    content = reverse(content)

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