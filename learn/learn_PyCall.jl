
using Conda
using PyCall
import Pkg

env = "py38"

# Change python
if false
    ENV["PYTHON"] = joinpath(Conda.ROOTENV, "envs", env, "python.exe")
    Pkg.build("PyCall")
end

# Default python
if false
    ENV["PYTHON"] = ""
    Pkg.build("PyCall")
end

begin
    # Keyword: VTK, numpy, Julia, import _vtkmodules_static, vtkmodules.all
    # Keyword: Conda, non-root, env
    #
    # From Conda document,
    # NOTE: If you are installing Python packages for use with PyCall,
    # you must use the root environment.
    # 
    # The following code allows using env other than root.
    # Add "...\envs\py38\Library\bin" to path
    path = Conda.bin_dir(dirname(PyCall.pyprogramname))
    if isnothing(findfirst(path, ENV["PATH"])) && Sys.iswindows()
        ENV["PATH"] = path * ";" * ENV["PATH"]
    end
    # VTK, numpy etc now will work
end

function learn_basic()
    @show PyCall.pyversion
    @show PyCall.libpython
    @show PyCall.pyprogramname
    @show PyCall.conda
    
    @show joinpath(dirname(pathof(PyCall)), "deps", "PYTHON")
    
    sys = pyimport("sys")
    @show sys.version

    math = pyimport("math")
    @show math.sin(math.pi / 4)   # 1/sqrt(2) = 0.70710678

    # use PyCall
    # problem with Qt
    # plt = pyimport("matplotlib.pyplot")
    # x = range(0;stop=2*pi,length=1000); y = sin.(3*x + 4*cos.(2*x));
    # plt.plot(x, y, color="red", linewidth=2.0, linestyle="--") # not working
end

function learn_qt()
    sys = pyimport("sys")
    qws = pyimport("PySide2.QtWidgets")

    app = qws.QApplication([])
    label = qws.QLabel("Qt for Python!")
    label.show()
    #sys.exit(app.exec_())
end

function learn_gtk()
    # conda install pygobject gtk3
    gi = pyimport("gi")
    gi.require_version("Gtk", "3.0")
    
    grepo = pyimport("gi.repository")
    gtk = pyimport("gi.repository.Gtk")
    
    win = gtk.Window(title="Hello World")
    win.connect("destroy", gtk.main_quit)
    win.show_all()
    gtk.main()    
end

function learn_tkinter()
    tkinter = pyimport(:tkinter)
end

function learn_wx()
    # For graphic heavy library such as wxpython,
    # use py""" """ to import before pyimport(:wx).

    # Must load in Python before loading in Julia
    py"""
    import wx
    """
    wx = pyimport(:wx)
end


#learn_basic()
#learn_qt()
#learn_gtk()

#learn_tkinter()
#learn_wx()



nothing
