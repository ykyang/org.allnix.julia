using Dash, DashHtmlComponents, DashCoreComponents, DashBootstrapComponents

include("learn_PlotlyJS.jl")

function show_plot(app, plt)
    if isnothing(app)
        app = dash(external_stylesheets=[dbc_themes.SPACELAB])
    end
    
    @show typeof(plt)

    app.layout = html_div() do #dbc_container() do
        dcc_graph(
            id = "plotly",
            figure = plt,
        )
    end

    return app
end

app = dash(external_stylesheets=[dbc_themes.SPACELAB])

#app = show_plot(app, clustering_alpha_shapes())
app = show_plot(app, linescatter5())
#app = show_plot(app, scatter_3d())

run_server(
    app, 
    "0.0.0.0", 
    8050, 
    debug=true, # enables hot reload and more
)