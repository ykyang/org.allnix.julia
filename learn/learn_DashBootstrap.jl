# https://dash-bootstrap-components.opensource.faculty.ai/docs/components/alert/

using Dash, DashHtmlComponents, DashCoreComponents, DashBootstrapComponents

"""

[Alert](https://dash-bootstrap-components.opensource.faculty.ai/docs/components/alert/)
"""
function hello_world()
    app = dash(external_stylesheets=[dbc_themes.BOOTSTRAP])

    app.layout = dbc_container(className = "p-5") do
        dbc_alert("Hello World!", color="success"),
        dbc_alert("Primary", color="primary"),
        # Link
        dbc_alert([
            "Link to ",
            html_a("Here", href="#", className="alert-link")
        ], color="primary"),
        dbc_alert([
            html_h4("Well done!"),
            html_p([
                "This is a success alert ",
                "and second message."
            ]),
            html_hr(),
            html_p(
                "Let's put some more text down here, but remove the bottom margin",
                className="mb-0"
            )
        ])

    end

    return app
    # run_server(
    #     app, "0.0.0.0", 
    #     8050, 
    #     debug=true, # enables hot reload and more
    # )
end

"""
[Alert Dismissing](https://dash-bootstrap-components.opensource.faculty.ai/docs/components/alert/)
"""
function alert_dismissing()
    #<link rel="stylesheet" href="https://stackpath.bootstrapcdn.com/bootstrap/4.5.2/css/bootstrap.min.css">
    #app = dash(external_stylesheets=["https://stackpath.bootstrapcdn.com/bootstrap/4.5.2/css/bootstrap.min.css"])
    #app = dash(external_stylesheets=[dbc_themes.MATERIA])
    #app = dash(external_stylesheets=[dbc_themes.MATERIA, "assets/my.css"])
    app = dash()

    #app = dash(external_stylesheets = ["https://codepen.io/chriddyp/pen/bWLwgP.css"])
    app.layout = dbc_container() do
        # class btn is making all text uppercase
        # class mbtn is defined in assets/my.css
        dbc_button(
            "Toggle alert with fade", 
            color="primary", className="mybtn"
        ),
        dbc_button(
            "Toggle alert without fade"
        ),
        html_hr(),
        dbc_alert(
            "Hello!  I am an alert", 
            id="alert-fade",
            dismissable=true,
            is_open=true,
        ),
        dbc_alert(
            "Hello! I am an alert that does not fade",
            id="alert-no-fade",
            dismissable=true,
            fade=false,
            is_open=true,
        )
    end

    return app
    
end

function badge_example(; app=nothing)
    if isnothing(app)
        app = dash()
    end
    app.layout = dbc_container() do
        # Simple example
        dbc_container([
            html_h3("Simple example"),
            dbc_button([
                "Notifications",
                dbc_badge("4", color="light", className="ml-1")
            ], 
            color="primary")
        ],
        className="p-3 my-2 border rounded"
        ),
        # Badge sizing
        dbc_container([
            html_h3("Badge sizing"),
            html_h1(["Example heading", dbc_badge("New", className="ml-1")]),
            html_h2(["Example heading", dbc_badge("New", className="ml-1")]),
            html_h3(["Example heading", dbc_badge("New", className="ml-1")]),
            html_h4(["Example heading", dbc_badge("New", className="ml-1")]),
            html_h5(["Example heading", dbc_badge("New", className="ml-1")]),
            html_h6(["Example heading", dbc_badge("New", className="ml-1")]),
        ],
        className="p-3 my-2 border rounded"
        ),
        # Contextual variations
        dbc_container([
            html_h3("Contextual variations"),
            dbc_badge("Primary", color="primary", className="mr-1"),
            dbc_badge("Secondary", color="secondary", className="mr-1"),
            dbc_badge("Success", color="success", className="mr-1"),
            dbc_badge("Warning", color="warning", className="mr-1"),
            dbc_badge("Danger", color="danger", className="mr-1"),
            dbc_badge("Info", color="info", className="mr-1"),
            dbc_badge("Light", color="light", className="mr-1"),
            dbc_badge("Dark", color="dark"),
        ],
        className="p-3 my-2 border rounded"
        ),
        # Pill badges
        dbc_container([
            html_h3("Pill badges"),
            dbc_badge("Primary", color="primary", className="mr-1", pill=true),
            dbc_badge("Secondary", color="secondary", className="mr-1", pill=true),
            dbc_badge("Success", color="success", className="mr-1", pill=true),
            dbc_badge("Warning", color="warning", className="mr-1", pill=true),
            dbc_badge("Danger", color="danger", className="mr-1", pill=true),
            dbc_badge("Info", color="info", className="mr-1", pill=true),
            dbc_badge("Light", color="light", className="mr-1", pill=true),
            dbc_badge("Dark", color="dark", pill=true),

        ],
        className="p-3 my-2 border rounded"
        ),
        # Links
        dbc_container([
            html_h3("Links"),
            dbc_badge("Primary", color="primary", className="mr-1", href="#"),
            dbc_badge("Secondary", color="secondary", className="mr-1", href="#"),
            dbc_badge("Success", color="success", className="mr-1", href="#"),
            dbc_badge("Warning", color="warning", className="mr-1", href="#"),
            dbc_badge("Danger", color="danger", className="mr-1", href="#"),
            dbc_badge("Info", color="info", className="mr-1", href="#"),
            dbc_badge("Light", color="light", className="mr-1", href="#"),
            dbc_badge("Dark", color="dark", href="#"),
            dcc_markdown("""
            ```julia
            dbc_badge("Primary", color="primary", className="mr-1", href="#"),
            dbc_badge("Secondary", color="secondary", className="mr-1", href="#"),
            dbc_badge("Success", color="success", className="mr-1", href="#"),
            dbc_badge("Warning", color="warning", className="mr-1", href="#"),
            dbc_badge("Danger", color="danger", className="mr-1", href="#"),
            dbc_badge("Info", color="info", className="mr-1", href="#"),
            dbc_badge("Light", color="light", className="mr-1", href="#"),
            dbc_badge("Dark", color="dark", href="#")
            ```
            """,
            className="p-2 my-2 border",
            highlight_config=Dict("theme"=>"light"))
        ],
        className="p-3 my-2 border rounded"
        )
    end

    return app
end

function layout_row_with_columns_1(;app=nothing)
    if isnothing(app)
        app = dash()
    end

    app.layout = html_div() do
        dbc_row(dbc_col(html_div("A single column", style=Dict("backgroundColor"=>"#32a852")))),
        dbc_row([
            dbc_col("One of three columns"),
            dbc_col("One of three columns"),
            dbc_col("One of three columns"),
        ])
    end

    return app
end

function layout_row_with_columns_2(;app=nothing)
    if isnothing(app)
        app = dash()
    end
    
    bg_style = Dict("backgroundColor"=>"#a3ffdd")

    app.layout = html_div() do
        dbc_row(dbc_col("A single, half-width column", width=6, style=bg_style)),
        dbc_row(dbc_col("An automatically sized column", width="auto")),
        dbc_row([
            dbc_col("One of three columns", width=3),
            dbc_col("One of three columns"),
            dbc_col("One of three columns", width=3),
        ])
    end

    return app
end

function layout_specify_order_and_offset(;app=nothing)
    if isnothing(app)
        app = dash()
    end

    bg_style = Dict("backgroundColor"=>"#a3ffdd")

    app.layout = dbc_container(style=Dict("backgroundColor"=>"orange")) do
        dbc_row(
            dbc_col(
                "A single, half-width column",
                width = Dict("size"=>6, "offset"=>3),
                style = bg_style,
            )
        ),
        dbc_row([
            dbc_col(
                "The last of three columns",
                width = Dict("size"=>3, "order"=>"last", "offset"=>1),
                style = bg_style,
            ),
            dbc_col(
                "The first of three columns",
                width = Dict("size"=>3, "order"=>1, "offset"=>2),
                style = bg_style,
            ),
            dbc_col(
                "The second of three columns",
                width = Dict("size"=>3, "order"=>12),
                style = bg_style,
            ),
        ])
    end 

    return app
end

function layout_specify_width_for_different_screen_sizes(;app=nothing)
    if isnothing(app)
        app = dash()
    end

    bg_style = Dict("backgroundColor"=>"#a3ffdd")

    app.layout = dbc_container(style=Dict("backgroundColor"=>"orange")) do
        dbc_row([
            dbc_col("One of three columns", md=4, style=bg_style),
            dbc_col("One of three columns", md=4, style=bg_style),
            dbc_col("One of three columns", md=4, style=bg_style),
        ]),
        dbc_row([
            dbc_col("One of four columns", width=6, lg=3, style=bg_style),
            dbc_col("One of four columns", width=6, lg=3, style=bg_style),
            dbc_col("One of four columns", width=6, lg=3, style=bg_style),
            dbc_col("One of four columns", width=6, lg=3, style=bg_style),
        ])
    end

    return app
end