
using Conda
using PyCall
import Pkg

# Change python
#py39 = joinpath(Conda.ROOTENV, "py39", "python.exe")
#ENV["PYTHON"] = py39
#Pkg.build("PyCall")

function learn_setup()
    @show PyCall.pyversion
    @show PyCall.libpython
    @show PyCall.pyprogramname
    @show PyCall.conda
    

    #@show Pkg.dir("PyCall", "deps", "PYTHON") # deprecated
    @show joinpath(dirname(pathof(PyCall)), "deps", "PYTHON")
    
    sys = pyimport("sys")
    @show sys.version
end

function learn_basic()
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

function build()
    ENV["PYTHON"] = ""
    #ENV["PYTHON"] = raw"C:\Users\Yi-Kun.Yang\local\conda3\envs\qt\python.exe"
    Pkg.build("PyCall")
end

#build()

#learn_setup()
#learn_basic()
#learn_qt()
#learn_gtk()



nothing
