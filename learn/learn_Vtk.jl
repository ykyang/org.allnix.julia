#
# Enclosed in Module to avoid loading vtk multiple times
#
# Learn using VTK in Julia
#
# See complete list of event at 
# https://vtk.org/doc/nightly/html/vtkCommand_8h_source.html

# https://kitware.github.io/vtk-examples/site/
# See vtkInteractorStyle for key binding
module Vtk

using Logging
using Conda
using PyCall

#
# Set up VTK in a separate Conda environment.
# See learn_Conda.jl

env   = "py38"
pyver = "3.8"

# Assign external Conda
if false
    ENV["CONDA_JL_HOME"] = joinpath(ENV["USERPROFILE"], "local", "mambaforge")
    Pkg.build("Conda")
end
# Exit Julia

# Create new Conda env, install vtk
if false
    Conda.runconda(`create --name $(env) python=$(pyver)`)
    Conda.add("vtk", env)
end
# Re-build PyCall
if false
   ENV["PYTHON"] = joinpath(Conda.ROOTENV, "envs", env, "python.exe")
   Pkg.build("PyCall")
end
# Exit Julia


begin # See learn_PyCall.jl
    path = Conda.bin_dir(dirname(PyCall.pyprogramname))
    if isnothing(findfirst(path, ENV["PATH"])) && Sys.iswindows()
        ENV["PATH"] = path * ";" * ENV["PATH"]
    end
end

struct VtkWindow
    interactor
    renderer
    render_window
    
    function VtkWindow(interactor, renderer, renwin)
        new(interactor, renderer, renwin)
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

# Attempt self-contained callback function
# and it works.
function animation_callback(obj, event; 
    timer_id=nothing, steps=nothing, actor=nothing)

    interactor = obj

    timer_count = 0
    step = 0
    while step < steps
        println("Timer Count: $timer_count")
        actor.SetPosition(timer_count/100.0, timer_count/100.0, 0.0)
        interactor.GetRenderWindow().Render()
        timer_count += 1
        step += 1
    end
    if !isnothing(timer_id)
        println("Destroy timer $timer_id")
        interactor.DestroyTimer(timer_id)
    end
end

function learn_animation()
    colors = vtk.vtkNamedColors()

    # Create a sphere
    sphereSource = vtk.vtkSphereSource()
    sphereSource.SetCenter(0.0, 0.0, 0.0)
    sphereSource.SetRadius(2)
    sphereSource.SetPhiResolution(30)
    sphereSource.SetThetaResolution(30)

    # Create a mapper and actor
    mapper = vtk.vtkPolyDataMapper()
    mapper.SetInputConnection(sphereSource.GetOutputPort())
    actor = vtk.vtkActor()
    actor.GetProperty().SetColor(colors.GetColor3d("Peacock"))
    actor.GetProperty().SetSpecular(0.6)
    actor.GetProperty().SetSpecularPower(30)
    actor.SetMapper(mapper)
    # actor.SetPosition(-5, -5, 0)

    # Setup a renderer, render window, and interactor
    renderer = vtk.vtkRenderer()
    renderer.SetBackground(colors.GetColor3d("MistyRose"))
    renderWindow = vtk.vtkRenderWindow()
    renderWindow.SetWindowName("Animation")
    renderWindow.AddRenderer(renderer)

    renderWindowInteractor = vtk.vtkRenderWindowInteractor()
    renderWindowInteractor.SetRenderWindow(renderWindow)

    # Add the actor to the scene
    renderer.AddActor(actor)

    # Render and interact
    renderWindow.Render()
    renderer.GetActiveCamera().Zoom(0.8)
    renderWindow.Render()

    # Initialize must be called prior to creating timer events.
    renderWindowInteractor.Initialize()

    # Sign up to receive TimerEvent
    #cb = vtkTimerCallback(200, actor, renderWindowInteractor)
    
    timer_id = renderWindowInteractor.CreateRepeatingTimer(500)
    cb = function(obj,event) 
        animation_callback(obj, event; timer_id=timer_id, steps=200, actor=actor)
    end
    obid = renderWindowInteractor.AddObserver("TimerEvent", cb)
    println("Observer ID: $obid")

    # start the interaction and timer
    renderWindow.Render()
    renderWindowInteractor.Start()
end


function boxCallback(obj, event)
    #vtk = pyimport("vtk") # Is this OK?
    t = vtk.vtkTransform()
    obj.GetTransform(t)
    obj.GetProp3D().SetUserTransform(t)
    # type(event): str
    # event:InteractionEvent
end

function cmd_callback(obj, event, ref::Ref{Union{Function,Nothing}})
    if isnothing(ref[]) return end
    #println("Calling: $(ref[])")
    
    ref[]() # call
    
    # reset
    ref[] = nothing
end

function learn_box(;
    renderer=vtk.vtkRenderer(), 
    renwin=vtk.vtkRenderWindow(),
    interactor = vtk.vtkRenderWindowInteractor(),
    )
    try
    #@show vtk.vtkVersion.GetVTKVersion()
    
    colors = vtk.vtkNamedColors()

    # Create a Cone
    cone = vtk.vtkConeSource()
    cone.SetResolution(30)
    coneMapper = vtk.vtkPolyDataMapper()
    coneMapper.SetInputConnection(cone.GetOutputPort())
    coneActor = vtk.vtkActor()
    coneActor.SetMapper(coneMapper)
    coneActor.GetProperty().SetColor(colors.GetColor3d("BurlyWood"))

    # A renderer and render window
    #renderer = vtk.vtkRenderer()
    renderer.SetBackground(colors.GetColor3d("Blue"))
    renderer.AddActor(coneActor)

    #renwin = vtk.vtkRenderWindow()
    renwin.AddRenderer(renderer)
    

    # An interactor
    #interactor = vtk.vtkRenderWindowInteractor()
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
    # Initialize must be called prior to creating timer events.
    interactor.Initialize()

    interactor.CreateRepeatingTimer(100)
    # cb = function(obj,event)
    #     cmd_callback(obj, event, fn_ref)
    # end
    # ob_id = interactor.AddObserver("TimerEvent", cb)
    # println("Observer ID: $ob_id")

    interactor.AddObserver("ExitEvent", (obj,event)-> renwin.Finalize())

    renwin.SetWindowName("BoxWidget")
    renwin.Render()
    interactor.Start()
    catch e
        @error e
        @error stacktrace(catch_backtrace())
        rethrow(e)
    end
end

# https://discourse.vtk.org/t/interactor-start-blocking-execution/1095/2
# https://gitlab.kitware.com/vtk/vtk/-/blob/master/Wrapping/Python/vtkmodules/wx/wxVTKRenderWindowInteractor.py
function learn_wx()
    # Must load in Python before loading in Julia
    py"""
    import wx
    from vtkmodules.wx.wxVTKRenderWindowInteractor import wxVTKRenderWindowInteractor
    """
    wx = pyimport("wx")
    # https://gitlab.kitware.com/vtk/vtk/-/blob/master/Wrapping/Python/vtkmodules/wx/wxVTKRenderWindowInteractor.py
    
    #vwxw = pyimport("vtkmodules.wx.wxVTKRenderWindowInteractor")
    #widget = vwxw.wxVTKRenderWindowInteractor(frame, -1)
    
    vwx = pyimport("vtkmodules.wx")

    # la = pyimport("learnall")
    # @show la.hello()
    # util = pyimport("learnall.util")
    # @show util.hello()
    
    colors = vtk.vtkNamedColors()

    # every wx app needs an app
    app = wx.App(false)
    frame = wx.Frame(nothing, -1, "wxVTKRenderWindowInteractor", size=(400,400))
    #widget = vwxw.wxVTKRenderWindowInteractor(frame, -1)
    widget = vwx[:wxVTKRenderWindowInteractor].wxVTKRenderWindowInteractor(frame, -1)
    #widget = vwx.wxVTKRenderWindowInteractor.wxVTKRenderWindowInteractor(frame, -1)
    sizer = wx.BoxSizer(wx.VERTICAL)
    sizer.Add(widget, 1, wx.EXPAND)
    frame.SetSizer(sizer)
    frame.Layout()

    widget.Enable(1)
    widget.AddObserver("ExitEvent", (obj,event)-> frame.Close())

    ren = vtk.vtkRenderer()
    renwin = widget.GetRenderWindow()
    widget.GetRenderWindow().AddRenderer(ren)

    cone = vtk.vtkConeSource()
    cone.SetResolution(8)

    coneMapper = vtk.vtkPolyDataMapper()
    coneMapper.SetInputConnection(cone.GetOutputPort())

    coneActor = vtk.vtkActor()
    coneActor.SetMapper(coneMapper)

    ren.AddActor(coneActor)

    # show the window
    frame.Show()
    #frame.Close()
    app.MainLoop() # comment out to interact in ipython
end
"""
    invoke_later(vtk_obj, fn)
    
Invoke a function, `fn`, in the GUI thread.

This is done by adding `fn` as a "TimerEvent" callback to the 
`vtk_obj`.  `vtk_obj` is usually a `vtkRenderWindowInteractor`.
Functions such as Render() must be called in the GUI thread through this type
of mechanism.
"""
function invoke_later(vtk_obj, fn)
    L = ReentrantLock()
    ref_id = nothing #Ref{Union{UInt64,Nothing}}(nothing)
    callback = function(obj,event)
        try
            fn() # run
        finally
            lock(L)
            vtk_obj.RemoveObserver(ref_id)
            unlock(L)
        end
    end
    lock(L)
    ref_id = vtk_obj.AddObserver("TimerEvent", callback)
    unlock(L)
end
"""
    invoke_later(vtk_obj, fn, renwin)

Invoke a function, `fn`, in the GUI thread and call `renwin.Render()` to render.
"""
function invoke_later(vtk_obj, renwin, fn::Function)
    L = ReentrantLock()
    ref_id = nothing #Ref{Union{UInt64,Nothing}}(nothing)
    callback = function(obj,event)
        try
            fn() # run
            renwin.Render()
        finally
            lock(L)
            vtk_obj.RemoveObserver(ref_id)
            unlock(L)
        end
    end
    lock(L)
    ref_id = vtk_obj.AddObserver("TimerEvent", callback)
    unlock(L)
end


end # module Vtk

#Vtk.learn_cone()
#Vtk.learn_animation()
#Vtk.learn_box()
#Vtk.learn_wx()


## Interactive VTK with Julia REPL --------------Interactive VTK with Julia REPL
## Start Julia with `-t 2`
colors = Vtk.vtk.vtkNamedColors()
renderer=Vtk.vtk.vtkRenderer()
renwin=Vtk.vtk.vtkRenderWindow()
interactor = Vtk.vtk.vtkRenderWindowInteractor()

# Window may close on its own if not a ref by a Julia structure
vwin = Vtk.VtkWindow(interactor, renderer, renwin)

#Vtk.learn_box(renderer=renderer, renwin=renwin, interactor=interactor)
task = Threads.@spawn Vtk.learn_box(
            renderer=renderer, 
            renwin=renwin, 
            interactor=interactor
        )
    

# sleep() here is a bad idea
# REPL may not get the prompt back
# 3 different ways to run
println("Enter to change color")
readline()
Vtk.invoke_later(interactor, renwin, ()->renderer.SetBackground(colors.GetColor3d("Red")))
println("Enter to change color")
readline()
fn = ()->renderer.SetBackground(colors.GetColor3d("Black")) 
Vtk.invoke_later(interactor, renwin, fn)
println("Enter to change color")
readline()
Vtk.invoke_later(interactor, renwin, function()
        renderer.SetBackground(colors.GetColor3d("Blue"))
    end 
)

nothing



