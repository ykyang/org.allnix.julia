# May need to use build.jl to rebuild PyCall then 
# restart Julia to make this work
using PyCall


sys = pyimport("sys")
qws = pyimport("PySide2.QtWidgets")

app = qws.QApplication([])
label = qws.QLabel("Qt for Python!")
label.show()
#sys.exit(app.exec_())