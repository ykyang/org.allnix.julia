# IJulia stopped working after switching to external Conda
# Start

using Conda
using PyCall
import Pkg

env = "py38"

path = Conda.bin_dir(dirname(PyCall.pyprogramname))
if isnothing(findfirst(path, ENV["PATH"])) && Sys.iswindows()
    ENV["PATH"] = path * ";" * ENV["PATH"]
    ENV["PATH"] = Conda.ROOTENV * ";" * ENV["PATH"]
end

#using IJulia
#jupyterlab(dir=pwd())

# Use external Conda
if false # does not work
    ENV["JUPYTER"] = joinpath(Conda.ROOTENV, "envs", env, "Scripts", "jupyter.exe")
    #ENV["JUPYTER"] = joinpath(Conda.ROOTENV, "envs", env, "Scripts")
    Pkg.build("IJulia")
end

# Use internal Conda
if false # does not work
    ENV["JUPYTER"] = ""
    Pkg.build("IJulia")
end