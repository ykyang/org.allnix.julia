include("learn_DashBootstrap.jl")

#app = dash(external_stylesheets=["https://stackpath.bootstrapcdn.com/bootstrap/4.5.2/css/bootstrap.min.css"])
#app = dash(external_stylesheets=[dbc_themes.MATERIA])
app = dash(external_stylesheets=[dbc_themes.SPACELAB])
#app = dash()

#app = hello_world()
#app = alert_dismissing()
#app = badge_example(app=app)
#app = button_example(app=app)
#app = button_group_example(app=app)
app = card_example(app=app)
#app = layout_row_with_columns_1(app=app)
#app = layout_row_with_columns_2(app=app)
#app = layout_specify_order_and_offset(app=app)
#app = layout_specify_width_for_different_screen_sizes(app=app)

run_server(
    app, 
    "0.0.0.0", 
    8050, 
    debug=true, # enables hot reload and more
)
