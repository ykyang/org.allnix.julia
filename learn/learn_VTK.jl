# https://github.com/plotly/dash-vtk
# Pkg.add(PackageSpec(url="https://github.com/plotly/dash-vtk.git"))
# add "https://github.com/plotly/dash-vtk.git"

using Dash, DashVtk, DashHtmlComponents

# app = dash()

# app.layout = html_div(style = (width = "100%", height = "calc(100vh - 16px)",)) do
#     vtk_view(
#         vtk_geometryrepresentation(
#             vtk_algorithm(
#                 vtkClass = "vtkConeSource",
#                 state = (resolution = 64, capping = false)
#             )
#         )
#     )
# end

xyz = Float64[]
for i in 1:10000
    push!(xyz, rand()) # x
    push!(xyz, rand()) # y
    push!(xyz, rand() * 0.01) # z
end

content = vtk_view(
    children = [
        vtk_geometryrepresentation(
            property = (pointSize = 3),
            children = [
                vtk_polydata(points=xyz, connectivity="points")
            ]
        )
    ]
)

app = dash()

app.layout = html_div(
    style = (width = "100%", height = "calc(100vh - 16px)",),
    children = [content]
) 

run_server(app)
