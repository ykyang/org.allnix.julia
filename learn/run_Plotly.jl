include("learn_Plotly.jl")

app = dash(external_stylesheets=[
    dbc_themes.SPACELAB,
    "https://cdnjs.cloudflare.com/ajax/libs/font-awesome/4.7.0/css/font-awesome.min.css",
    #"/myassets/spacelab.css",
    #"myassets/my.css"
    ])

# Uncomment one of the following to run
#app = chapter_configuration_options(app=app)
#app = chapter_scatter_plots(app=app)
#app = chapter_line_charts(app=app)
#app = chapter_bar_charts(app=app)
#app = chapter_pie_charts(app=app)
#app = chapter_bubble_charts(app=app)
app = chapter_histograms(app=app)
#app = chapter_contour_plots(app=app)
#app = chapter_heatmaps(app=app)
#app = chapter_3d_scatter_plots(app=app)
#app = chapter_3d_surface_plots(app=app)

try # Enable Ctrl-C
    run_server(
        app, 
        "0.0.0.0", 
        8050, 
        debug=true, # enables hot reload and more
    )
catch e
    @show e
end
