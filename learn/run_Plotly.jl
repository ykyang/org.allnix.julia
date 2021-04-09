include("learn_Plotly.jl")

app = dash(external_stylesheets=[
    dbc_themes.SPACELAB,
    "https://cdnjs.cloudflare.com/ajax/libs/font-awesome/4.7.0/css/font-awesome.min.css",
    #"/myassets/spacelab.css",
    #"myassets/my.css"
    ])

#app = configuration_options(app=app)
#app = scatter_plots(app=app)
app = line_charts(app=app)

run_server(
    app, 
    "0.0.0.0", 
    8050, 
    debug=true, # enables hot reload and more
)
