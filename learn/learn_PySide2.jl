using Conda
using PyCall

# Does not work

begin # See learn_PyCall.jl
    path = Conda.bin_dir(dirname(PyCall.pyprogramname))
    if isnothing(findfirst(path, ENV["PATH"])) && Sys.iswindows()
        ENV["PATH"] = path * ";" * ENV["PATH"]
    end
end

# # Qt stuff from 
# # https://stackoverflow.com/questions/41994485/how-to-fix-could-not-find-or-load-the-qt-platform-plugin-windows-while-using-m
begin
    path = dirname(PyCall.pyprogramname)
    path = joinpath(path, "Library", "plugins")
    #if isnothing(findfirst(path, ENV["QT_PLUGIN_PATH"])) && Sys.iswindows()
        #ENV["QT_PLUGIN_PATH"] = path * ";" * ENV["QT_PLUGIN_PATH"]
        ENV["QT_PLUGIN_PATH"] = path
    #end

    #ENV["QT_QPA_PLATFORM_PLUGIN_PATH"] = path
end

function learn_first_app()
    py"""
    import PySide2
    from PySide2.QtCore import QSize, Qt
    from PySide2.QtWidgets import QApplication, QMainWindow, QPushButton
    """
    lpy = pyimport("learnall.pyside2")
    app = lpy.get_app()
    #win = lpy.MainWindow()
    #win.show()
    #app.exec_()
    
    #lpy.hello3()
end

learn_first_app()







# #C:\Users\Yi-Kun.Yang\local\mambaforge\envs\py38\Library\plugins
# py"""
# import PySide2
# import PySide2.QtWidgets
# """
# sys = pyimport("sys")
# qtw = pyimport("PySide2.QtWidgets")
# qtc = pyimport("PySide2.QtCore")


# app = qtw.QApplication(sys.argv)

# win = qtw.QWidget()
# win.resize(320,240)
# win.setWindowTitle("Hello, World!")

# win.show()


# sys.exit(app.exec_())