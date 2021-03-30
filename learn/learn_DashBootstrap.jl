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
    app = dash(external_stylesheets = ["https://codepen.io/chriddyp/pen/bWLwgP.css"])
    app.layout = dbc_container() do
        dbc_button(
            "Toggle alert with fade", type="button", color="primary", className="mr-1"
        ),
        html_button(
            "Toggle alert without fade"
        ),
        html_hr()
    end

    return app
    
end