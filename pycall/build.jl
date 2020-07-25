# build PyCall with the python on path
using Pkg
ENV["PYTHON"] = "python"
Pkg.build("PyCall")