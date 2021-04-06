# Follows https://plotly.com/javascript/

using Dash, DashHtmlComponents, DashCoreComponents, DashBootstrapComponents
using PlotlyJS, HTTP, CSV

# https://plotly.com/javascript/configuration-options/
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