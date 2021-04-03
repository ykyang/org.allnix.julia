# Use version 1.5.3 and run in command line
#
#   julia --project=@. run_Dash.jl
#
# this will enable hot reloading, meaning the server refresh the page when
# learn_Dash.jl is updated.
# 
# Run in interactive mode is fine by
#
#   include("learn_Dash.jl")
#
# but needs to shutdown and restart the server every time the file updated.

#
# Use this to run functions in learn_Dash.jl
# The separation is necessary due to hot reloading from Dash.  It automatically
# reload and this may not be desired sometimes.  The use of run_Dash.jl creates
# a buffer to get more control of when to reload.
# 
# Apparently, hot redloading check included file so the idea of buffering is out.

include("learn_Dash.jl")

# https://dash-julia.plotly.com/getting-started
#hello_dash()
#dash_table()
dash_plotly() # RDatasets does not work
#dash_markdown()
#dash_core()
#dash_basic_callback()
#dash_layout_figure_slider()
#Ans = dash_app_multiple_inputs()
#Ans = dash_app_multiple_outputs()
#Ans = dash_app_chained_callbacks()
#Ans = dash_app_state()
#Ans = dash_intro_visual()
#Ans = dash_update_graphs_on_hover()
#Ans = dash_generic_crossfilter_recipe()