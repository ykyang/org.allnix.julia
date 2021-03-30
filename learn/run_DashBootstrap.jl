include("learn_DashBootstrap.jl")

#app = hello_world()
app = alert_dismissing()

run_server(
    app, "0.0.0.0", 
    8050, 
    debug=true, # enables hot reload and more
)