# build PyCall with the python on path
using Pkg
ENV["PYTHON"] = "python"
#ENV["PYTHON"] = raw"C:\Users\Yi-Kun.Yang\local\conda3\envs\qt\python.exe"
Pkg.build("PyCall")
