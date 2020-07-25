using PyCall
py"print('Hello World from Python')"
py"2+2"
A = 15
py"print"("A = $A")

os = pyimport("os")

cwd = os.getcwd()
py"print"("cwd = $cwd")
os.path.basename(cwd)
os.path.dirname(cwd)
