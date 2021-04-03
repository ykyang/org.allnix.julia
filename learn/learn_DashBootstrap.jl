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
            ),
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
            # Test code block with Markdown
            # Not highlighted for Julia yet
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

function button_example(; app=nothing)
    if isnothing(app)
        app = dash()
    end

    app.layout = dbc_container() do
        dbc_container([
            html_h3("Buttons"),
            dbc_button("Primary", color="primary", className="mr-1"),
            dbc_button("Secondary", color="secondary", className="mr-1"),
            dbc_button("Success", color="success", className="mr-1"),
            dbc_button("Warning", color="warning", className="mr-1"),
            dbc_button("Danger", color="danger", className="mr-1"),
            dbc_button("Info", color="info", className="mr-1"),
            dbc_button("Light", color="light", className="mr-1"),
            dbc_button("Dark", color="dark", className="mr-1"),
            dbc_button("Link", color="link"),
        ],
        className="p-3 my-2 border rounded"
        ),
        dbc_container([
            html_h3("Using buttons"),
            dbc_button("Click me", id="click-me", className="mr-2"),
            html_span(id="click-me-output", style=Dict("vertical-align"=>"middle"))
        ], className="p-3 my-2 border rounded"),
        # Outline buttons
        dbc_container([
            html_h3("Outline buttons"),
            dbc_button("Primary", color="primary", className="mr-1", outline=true),
            dbc_button("Secondary", color="secondary", className="mr-1", outline=true),
            dbc_button("Success", color="success", className="mr-1", outline=true),
            dbc_button("Warning", color="warning", className="mr-1", outline=true),
            dbc_button("Danger", color="danger", className="mr-1", outline=true),
            dbc_button("Info", color="info", className="mr-1", outline=true),
            dbc_button("Light", color="light", className="mr-1", outline=true),
            dbc_button("Dark", color="dark", className="mr-1", outline=true),
            dbc_button("Link", color="link", outline=true),
        ], className="p-3 my-2 border rounded"),
        # Button size
        dbc_container([
            html_h3("Button size"),
            dbc_button("Large button", size="lg", className="mr-1"),
            dbc_button("Regular button", className="mr-1"),
            dbc_button("Small button", size="sm"),
            html_hr(),
            # Block button
            dbc_button("Block button", block=true)
        ], className="p-3 my-2 border rounded"),
        # Active and disabled states
        dbc_container([
            html_h3("Active and disabled states"),
            dbc_button("Regular", color="primary", className="mr-1"),
            dbc_button("Active", color="primary", active=true, className="mr-1"),
            dbc_button("Disabled", color="primary", disabled=true),
        ], className="p-3 my-2 border rounded")
    end
    
    callback!( # Click me button
        app,
        Output("click-me-output", "children"),
        Input("click-me", "n_clicks")
    ) do n
        #@show n
        
        if isnothing(n)
            return "Not clicked"    
        else
            return "Clicked $n times"
        end
    end

    return app
end

function button_group_example(; app=nothing)
    if isnothing(app)
        app = dash()
    end

    app.layout = dbc_container() do
        dbc_container([
            html_h3("Simple example"),
            dbc_buttongroup([
                dbc_button("Left"), dbc_button("Middle"), dbc_button("Right"),
            ])
        ], className="p-3 my-2 border rounded"),
        dbc_container([
            html_h3("Size"),
            dbc_buttongroup([
                dbc_button("Left"), dbc_button("Middle"), dbc_button("Right"),
            ], size="lg", className="mr-1"),
            dbc_buttongroup([
                dbc_button("Left"), dbc_button("Middle"), dbc_button("Right"),
            ], size="md", className="mr-1"),
            dbc_buttongroup([
                dbc_button("Left"), dbc_button("Middle"), dbc_button("Right"),
            ], size="sm", className="mr-1"),
        ], className="p-3 my-2 border rounded"),
        dbc_container([
            html_h3("Dropdown"),
            dbc_dropdownmenu([
                dbc_dropdownmenuitem("Item 1"), dbc_dropdownmenuitem("Item 2"),
            ], label="Dropdown", group=false)
        ], className="p-3 my-2 border rounded"),
        dbc_container([
            html_h3("Simple example"),
            dbc_buttongroup([
                dbc_button("Top"), dbc_button("Middle"), dbc_button("Bottom"),
            ], vertical=true)
        ], className="p-3 my-2 border rounded")
    end

    return app
end

function card_example(; app=nothing)
    if isnothing(app)
        app = dash()
    end

    # Objects to be used later
    top_card = dbc_card([
        dbc_cardimg(src="assets/images/placeholder286x180.png", top=true),
        dbc_cardbody(
            html_p("This card has an image at the top", className="card-text")
        ),
    ])

    bottom_card = dbc_card([
        dbc_cardbody(
            html_p("This is the bottom image", className="card-text"),
        ),
        dbc_cardimg(src="assets/images/placeholder286x180.png", bottom=true)
    ])

    card_1 = dbc_card(
        dbc_cardbody([
            html_h5("Card title", className="card-title"),
            html_p("This card has some text content, but not much else"),
            dbc_button("Go", color="primary"),
        ])
    )
    card_2 = dbc_card(
        dbc_cardbody([
            html_h5("Card title", className="card-title"),
            html_p("""
            This card also has some text content and not much else, but
            it is twice as wide as the first card.
            """),
            dbc_button("Go", color="success")
        ])
    )

    card_content = [
        dbc_cardheader("Card header"),
        dbc_cardbody([
            html_h5("Card title", className="card-title"),
            html_p("""
            This is some card content that we will reuse."
            """,
            className="card-text")
        ])
    ]

    card_content_1 = card_content

    card_content_2 = [
        dbc_cardbody([
            dcc_markdown("""
            > A learning experience is one of those things that says,
            > 'you know that thing you just did?  Don't do that.'
            >
            > *Douglas Adams*
            """),
        ])
    ]

    card_content_3 = [
        dbc_cardimg(src="assets/images/placeholder286x180.png"),
        dbc_cardbody([
            dcc_markdown("""
            ##### Card with image
            This card has an image on top, and a button below."
            """, className="card-text"),
            dbc_button("Click", color="primary"),
        ]),
    ]

    app.layout = dbc_container() do
        dbc_container([ # Simple example
            html_h3("Simple example"),
            dbc_card([
                dbc_cardimg(src="/assets/images/placeholder286x180.png", top=true),
                dbc_cardbody([
                    html_h4("Card title", className="card-title"),
                    html_p([
                        "Some quick example text to build on the card title and ",
                        "make up the bulk of the card's content",
                    ], className="card-text"),
                    dbc_button("Go somewhere", color="primary"),
                ]),
            ], style=Dict("width"=>"18rem")),
        ], className="p-3 my-2 border rounded"),
        

        dbc_container([ # Content types
            html_h3("Content types"),
            html_p("Cards support a wide variety of content. Here are some of the building blocks you can use when creating your own cards."),

            html_h4("Body"),
            html_small("$(@__FILE__): $(@__LINE__)"),
            dbc_card(
                dbc_cardbody("This is within a card body"),
                className="mb-3",
            ),
            dbc_card("Card body with card directly", body=true, className="mb-3"),
            
            html_h4("Titles, text and links"),
            html_small("$(@__FILE__): $(@__LINE__)"),
            dbc_card(
                dbc_cardbody([
                    html_h4("Title", className="card-title"),
                    html_h5("Subtitle", className="card-subtitle"),
                    html_p([
                        "Some quick example text to build on the card title and make ",
                        "up the bulk of the card's content.",
                    ], className="card-text"),
                    dbc_cardlink("Card link", href="#"),
                    dbc_cardlink("Google", href="https://google.com"),
                ]), style=Dict("width"=>"18rem")
            ),

            html_h4("Images"),
            html_small("$(@__FILE__): $(@__LINE__)"),
            dbc_row([
                dbc_col(top_card, width="auto"), dbc_col(bottom_card, width="auto")
            ]),
        
            html_h4("List groups"),
            html_small("$(@__FILE__): $(@__LINE__)"),
            dbc_card(
                dbc_listgroup([
                    dbc_listgroupitem("Item 1"),
                    dbc_listgroupitem("Item 2"),
                    dbc_listgroupitem("Item 3"),
                    dbc_listgroupitem("Item 4"),
                ]),
                style=Dict("width"=>"18rem")
            ),

            html_h4("Header and footer"),
            html_small("$(@__FILE__): $(@__LINE__)"),
            dbc_card([
                dbc_cardheader("Header"),
                dbc_cardbody([
                    html_h4("Card title", className="card-title"),
                    html_p("This is some card text.", className="card-text"),
                ]),
                dbc_cardfooter("Footer"),
            ], style=Dict("width"=>"20rem")),
        ], className="p-3 my-2 border rounded"),


        dbc_container([ # Sizing
            html_h3("Sizing"),
            html_p("As mentioned previously, cards assume no specific width, so they will expand to the width of the parent element unless otherwise specified. You can change this behaviour as needed in one of three different ways."),

            html_h4("Using grid components"),
            html_small("$(@__FILE__): $(@__LINE__)"),
            dbc_row([
                dbc_col(card_1, width=4), dbc_col(card_2, width=8)
            ]),

            html_h4("Using Bootstrap utility classes"),
            html_small("$(@__FILE__): $(@__LINE__)"),
            dbc_card(
                dbc_cardbody([
                    html_h5("75% width card", className="card-title"),
                    dcc_markdown("""
                    This card uses the `w-75` class to set the width to 75%.
                    """),
                    html_p([
                        "This card uses the ",
                        html_code("w-75"),
                        " class to set the width to 75%",
                    ])
                ]), 
                className="w-75 mb-3"
            ),
            dbc_card(
                dbc_cardbody([
                    html_h5("50% width card", className="card-title"),
                    dcc_markdown("""
                    This card uses the `w-50` class to set the width to 50%.
                    """)
                ]), 
                className="w-50 mb-3"
            ),

            html_h4("Using custom CSS"),
            html_small("$(@__FILE__): $(@__LINE__)"),
            dbc_card(
                dbc_cardbody([
                    html_h5("Custom CSS", className="card-title"),
                    dcc_markdown("""
                    This card has inline styles applied controlling the width.
                    You could also apply the same styles with a custom CSS
                    class.
                    """)
                ]),
                style=Dict("width"=>"18rem"),
            )
        ], className="p-3 my-2 border rounded"),

        dbc_container([ # Card style
            html_h3("Card style"),
            html_h4("Background and color"),
            html_small("$(@__FILE__): $(@__LINE__)"),
            dbc_row([
                dbc_col(dbc_card(card_content, color="primary", inverse=true)),
                dbc_col(dbc_card(card_content, color="secondary", inverse=true)),
                dbc_col(dbc_card(card_content, color="info", inverse=true)),
            ], className="mb-4"),
            dbc_row([
                dbc_col(dbc_card(card_content, color="success", inverse=true)),
                dbc_col(dbc_card(card_content, color="warning", inverse=true)),
                dbc_col(dbc_card(card_content, color="danger", inverse=true)),
            ], className="mb-4"),
            dbc_row([
                dbc_col(dbc_card(card_content, color="light", inverse=false)),
                dbc_col(dbc_card(card_content, color="dark", inverse=true)),
            ], className="mb-4"),

            html_h4("Outline style"),
            html_small("$(@__FILE__): $(@__LINE__)"),
            dbc_row([
                dbc_col(dbc_card(card_content, color="primary", outline=true)),
                dbc_col(dbc_card(card_content, color="secondary", outline=true)),
                dbc_col(dbc_card(card_content, color="info", outline=true)),
            ], className="mb-4"),
            dbc_row([
                dbc_col(dbc_card(card_content, color="success", outline=true)),
                dbc_col(dbc_card(card_content, color="warning", outline=true)),
                dbc_col(dbc_card(card_content, color="danger", outline=true)),
            ], className="mb-4"),
            dbc_row([
                dbc_col(dbc_card(card_content, color="light", outline=true)),
                dbc_col(dbc_card(card_content, color="dark", outline=true)),
            ], className="mb-4"),

        ], className="p-3 my-2 border rounded"),

        dbc_container([ # Card layout
            html_h3("Card layout"),
            html_h4("Card group"),
            html_small("$(@__FILE__): $(@__LINE__)"),
            dbc_cardgroup([
                dbc_card(dbc_cardbody([
                    html_h5("Card 1", className="card-title"),
                    dcc_markdown("""
                    This cas has some text content, which is a little
                    bit longer than the second card.
                    """, className="card-text"),
                    dbc_button("Go", color="success", className="mt-auto"),
                ])),
                dbc_card(dbc_cardbody([
                    html_h5("Card 2", className="card-title"),
                    dcc_markdown("""
                    This card has some text content.
                    """, className="card-text"),
                    dbc_button("Go", color="warning", className="mt-auto"),
                ])),
                dbc_card(dbc_cardbody([
                    html_h5("Card 3", className="card-title"),
                    dcc_markdown("""
                    This card has some text content, which is longer than
                    both of the other two cards, in order to demonstrate the
                    equal height property of cards in a card group.
                    """, className="card-text"),
                    dbc_button("Go", color="danger", className="mt-auto"),
                ])),
            ], className="mb-3"),

            html_h4("Card deck"),
            html_small("$(@__FILE__): $(@__LINE__)"),
            dbc_carddeck([
                dbc_card(dbc_cardbody([
                    html_h5("Card 1", className="card-title"),
                    dcc_markdown("""
                    This cas has some text content, which is a little
                    bit longer than the second card.
                    """, className="card-text"),
                    dbc_button("Go", color="success", className="mt-auto"),
                ])),
                dbc_card(dbc_cardbody([
                    html_h5("Card 2", className="card-title"),
                    dcc_markdown("""
                    This card has some text content.
                    """, className="card-text"),
                    dbc_button("Go", color="warning", className="mt-auto"),
                ])),
                dbc_card(dbc_cardbody([
                    html_h5("Card 3", className="card-title"),
                    dcc_markdown("""
                    This card has some text content, which is longer than
                    both of the other two cards, in order to demonstrate the
                    equal height property of cards in a card group.
                    """, className="card-text"),
                    dbc_button("Go", color="danger", className="mt-auto"),
                ])),
            ], className="mb-3"),

            html_h4("Card columns"),
            dbc_badge("Line: $(@__LINE__)", color="info", className="mb-1"),
            dbc_cardcolumns([
                dbc_card(card_content_1, color="primary", inverse=true),
                dbc_card(card_content_2),
                dbc_card(card_content_1, color="secondary", inverse=true),
                dbc_card(card_content_3, color="info", inverse=true),
                dbc_card(card_content_1, color="success", inverse=true),
                dbc_card(card_content_1, color="warning", inverse=true),
                dbc_card(card_content_1, color="danger", inverse=true),
                dbc_card(card_content_3, color="light", inverse=false),
                dbc_card(card_content_1, color="dark", inverse=true),

            ]),

        ], className="p-3 my-2 border rounded")

        
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

function nav_example(; app=nothing)
    if isnothing(app)
        app = dash(external_stylesheets=[dbc_themes.SPACELAB])
    end

    content = [
        dbc_container([html_h3("Base nav"),
            dbc_badge("Line $(@__LINE__)"),
            dcc_markdown("""Use `dbc_navitem` with `dbc_navlink`. """),
            dbc_nav([
                dbc_navitem(dbc_navlink("Active", active=true, href="#")),
                dbc_navitem(dbc_navlink("Link 1", href="#")),
                dbc_navitem(dbc_navlink("Link 2", href="#")),
                dbc_navitem(dbc_navlink("Disabled", disabled=true, href="#")),
                dbc_dropdownmenu([
                    dbc_dropdownmenuitem("Item 1"),
                    dbc_dropdownmenuitem("Item 2"),
                ], 
                label="Dropdown", 
                nav=true, # button looking -> menu looking
                ),
            ]),
            dbc_badge("Line $(@__LINE__)"),
            dcc_markdown("""Use `dbc_navlink` directly."""),
            dbc_nav([
                dbc_navlink("Active", active=true, href="#"),
                dbc_navlink("Link 1", href="#"),
                dbc_navlink("Link 2", href="#"),
                dbc_navlink("Disabled", disabled=true, href="#"),
                dbc_dropdownmenu([
                    dbc_dropdownmenuitem("Item 1"),
                    dbc_dropdownmenuitem("Item 2"),
                ], 
                label="Dropdown", 
                nav=true, # button looking -> menu looking
                ),
            ])

        ], className="p-3 my-2 border rounded"),

        dbc_container([html_h3("Using NavLink"),
            dbc_badge("Source", href="https://dash-bootstrap-components.opensource.faculty.ai/docs/components/nav/"),
            dbc_badge("Line $(@__LINE__)", className="ml-1"),

        ], className="p-3 my-2 border rounded"),
    ]
    
    app.layout = dbc_container(content)

    return app
end

function navbar_example(; app=nothing)
    if isnothing(app)
        app = dash(external_stylesheets=[dbc_themes.SPACELAB])
    end
   
    content = [
        dbc_container([html_h3("NavbarSimple"),
            dbc_badge("Line $(@__LINE__)"),
            dbc_navbarsimple(children = [
                dbc_navitem(dbc_navlink("Page 1", href="#")),
                dbc_navitem(dbc_navlink("Page 2", href="#")),
                dbc_dropdownmenu([
                    dbc_dropdownmenuitem("More pages", header=true),    
                    dbc_dropdownmenuitem("Page 3", href="#"),
                    dbc_dropdownmenuitem("Page 4", href="#"),
                ], 
                nav = true,
                in_navbar=true,
                label="More",
                )
                
            ],
            brand = "NavbarSimple",
            brand_href="#",
            color = "primary",
            dark = true,            
            ),

        ], className="p-3 my-2 border rounded"),
        dbc_container([html_h3("Navbar"),
            dbc_badge("Line $(@__LINE__)"),

        ], className="p-3 my-2 border rounded"),

    ]

    app.layout = dbc_container(content)

    return app
end