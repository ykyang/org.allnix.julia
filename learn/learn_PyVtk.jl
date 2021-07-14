using PyCall

vtk = pyimport("vtk")

colors = vtk.vtkNamedColors()

cone = vtk.vtkConeSource()
mapper = vtk.vtkPolyDataMapper()
mapper.SetInputConnection(cone.GetOutputPort())

actor = vtk.vtkActor()
actor.SetMapper(mapper)
actor.GetProperty().SetDiffuseColor(colors.GetColor3d("bisque"))

renderer = vtk.vtkRenderer()



renWin = vtk.vtkRenderWindow()
renWin.AddRenderer(renderer)


renderer.AddActor(actor)
renderer.SetBackground(colors.GetColor3d("Salmon"))

iren = vtk.vtkRenderWindowInteractor()
iren.SetRenderWindow(renWin)

iren.Initialize()
# We'll zoom in a little by accessing the camera and invoking a "Zoom"
# method on it.
#ren.ResetCamera()
#ren.GetActiveCamera().Zoom(1.5)
renWin.SetSize(300, 300)
renWin.SetWindowName("Cone")
renWin.Render()
iren.Start()
