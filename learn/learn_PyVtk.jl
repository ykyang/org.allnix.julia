#
# Enclosed in Module to avoid loading vtk multiple times
#
# Learn using VTK in Julia
#
module Vtk

using Conda
using PyCall

# Set up VTK in a separate Conda environment.
#
#   Conda.runconda(`create --name py38 python=3.8`)
#   Conda.add("vtk", :py38)
#   ENV["PYTHON"] = joinpath(Conda.ROOTENV, "envs", "py38", "python.exe")
#   Pkg.build("PyCall")
#
# Use external Conda
#   ENV["CONDA_JL_HOME"] = joinpath(ENV["USERPROFILE"], "local", "mambaforge")
#   Pkg.build("Conda")
# Exit Julia
# Enter Julia
#   using Conda
#   ENV["PYTHON"] = joinpath(Conda.ROOTENV, "envs", "py38", "python.exe")
#   Pkg.build("PyCall")
# Exit Julia

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

# if isnothing(findfirst(Conda.bin_dir(Conda.ROOTENV), ENV["PATH"])) && Sys.iswindows()
#     ENV["PATH"] = Conda.bin_dir(Conda.ROOTENV) * ";" * ENV["PATH"]
# end

begin
    path = Conda.bin_dir(dirname(PyCall.pyprogramname))
    if isnothing(findfirst(path, ENV["PATH"])) && Sys.iswindows()
        ENV["PATH"] = path * ";" * ENV["PATH"]
    end
end
const vtk = pyimport("vtk")

function learn_cone()
    #vtk = pyimport("vtk")

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
end

function boxCallback(obj, event)
    #vtk = pyimport("vtk") # Is this OK?
    t = vtk.vtkTransform()
    obj.GetTransform(t)
    obj.GetProp3D().SetUserTransform(t)
    # type(event): str
    # event:InteractionEvent
end

function learn_box()
    #vtk = pyimport("vtk")

    colors = vtk.vtkNamedColors()

    # Create a Cone
    cone = vtk.vtkConeSource()
    cone.SetResolution(20)
    coneMapper = vtk.vtkPolyDataMapper()
    coneMapper.SetInputConnection(cone.GetOutputPort())
    coneActor = vtk.vtkActor()
    coneActor.SetMapper(coneMapper)
    coneActor.GetProperty().SetColor(colors.GetColor3d("BurlyWood"))

    # A renderer and render window
    renderer = vtk.vtkRenderer()
    renderer.SetBackground(colors.GetColor3d("Blue"))
    renderer.AddActor(coneActor)

    renwin = vtk.vtkRenderWindow()
    renwin.AddRenderer(renderer)
    

    # An interactor
    interactor = vtk.vtkRenderWindowInteractor()
    interactor.SetRenderWindow(renwin)

    # A Box widget
    boxWidget = vtk.vtkBoxWidget()
    boxWidget.SetInteractor(interactor)
    boxWidget.SetProp3D(coneActor)
    boxWidget.SetPlaceFactor(1.25)  # Make the box 1.25x larger than the actor
    boxWidget.PlaceWidget()
    boxWidget.On()

    # Connect the event to a function
    # This call makes cone move and stretch with the box.
    # See complete list of event at 
    # https://vtk.org/doc/nightly/html/vtkCommand_8h_source.html
    boxWidget.AddObserver("InteractionEvent", boxCallback)

    # Start
    interactor.Initialize()
    renwin.SetWindowName("BoxWidget")
    renwin.Render()
    interactor.Start()
end
end

#Vtk.learn_cone()
Vtk.learn_box()
