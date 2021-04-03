include("learn_Plotly.jl")

app = dash(external_stylesheets=[dbc_themes.SPACELAB])

app = configuration_options(app=app)

run_server(
    app, 
    "0.0.0.0", 
    8050, 
    debug=true, # enables hot reload and more
)
