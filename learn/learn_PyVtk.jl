using Conda
using PyCall


# From Conda document,
# NOTE: If you are installing Python packages for use with PyCall,
# you must use the root environment.
#
# If there is an error loading vtk module,
# then try use Conda root environment.
#
# This may allow using non-root-installed packages.
#
# https://github.com/JuliaPy/PyCall.jl/issues/730
# ENV["PATH"] = Conda.bin_dir(Conda.ROOTENV) * ";" * ENV["PATH"]

# Fix package must be in root env bug
if isnothing(findfirst(Conda.bin_dir(Conda.ROOTENV), ENV["PATH"])) && Sys.iswindows()
    ENV["PATH"] = Conda.bin_dir(Conda.ROOTENV) * ";" * ENV["PATH"]
end

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
