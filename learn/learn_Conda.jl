using Conda
import Pkg

# Access Julia Conda from terminal
# Navigate to Julia's Conda installation at ~/.julia/conda/3/condabin
# Drag "activate.bat" into a terminal.

@show Conda.ROOTENV

env   = "py38"
pyver = "3.8"

# Assign external Conda
if false
    ENV["CONDA_JL_HOME"] = joinpath(ENV["USERPROFILE"], "local", "mambaforge")
    Pkg.build("Conda")
end

# Back to Julia Conda
if false
    # ENV["JULIA_DEPOT_PATH"]???
    ENV["CONDA_JL_HOME"] = joinpath(ENV["USERPROFILE"], ".julia", "conda", "3")
    Pkg.build("Conda")
end

# Create new Conda env
if false
    Conda.runconda(`create --name $(env) python=$(pyver)`)
end

# Common Conda commands
if false
    Conda.runconda(`info`)
    Conda.runconda(`search python`)
    Conda.runconda(`env list`)
    Conda.runconda(`list`)
end

# Add package
if false
    Conda.add("vtk",   env)
    Conda.add("numpy", env)
    Conda.add("jupyterlab", env)
    # or
    Conda.runconda(`install paraview -n $(env)`)
    Conda.runconda(`install vtk      -n $(env)`)
end

function learn_basic()
    #@show Conda.ROOTENV

    # From Conda document,
    # NOTE: If you are installing Python packages for use with PyCall,
    # you must use the root environment.
    #
    # This may allow using non-root-installed packages.
    #
    # https://github.com/JuliaPy/PyCall.jl/issues/730
    # ENV["PATH"] = Conda.bin_dir(Conda.ROOTENV) * ";" * ENV["PATH"]

    #Conda.runconda(`create --name py39 python=3.9`)    
    #Conda.runconda(`create --name py38 python=3.8`)

    ## env names
    #env = "py38"
    #env = "py382"

    ## Common Conda commands
    #Conda.runconda(`search python`)
    #Conda.runconda(`env list`)
    #Conda.runconda(`info`)
    
    # Conda.add("vtk", :py38)
    # Conda.add("numpy", :py38)
    # Conda.runconda(`install paraview`)
    # Conda.runconda(`install vtk -n $env`)
    
    
    ## Revert back to default Conda
    # ENV["CONDA_JL_HOME"] = raw"C:\Users\Yi-Kun.Yang\.julia\conda\3"
    # Pkg.build("Conda")

    ## Assign external Conda
    # ENV["CONDA_JL_HOME"] = joinpath(ENV["USERPROFILE"], "local", "mambaforge")
    # Pkg.build("Conda")

    ## Assign external Conda
    # ENV["CONDA_JL_HOME"] = raw"C:\Users\Yi-Kun.Yang\local\conda3"
    # Pkg.build("Conda")

    ## Revert back to root python
    # ENV["PYTHON"] = ""
    # Pkg.build("PyCall")

    ## Assign non-root python 
    # ENV["PYTHON"] = joinpath(Conda.ROOTENV, "envs", env, "python.exe")
    # Pkg.build("PyCall")
    
    #ENV["PYTHON"] = raw"C:\Users\Yi-Kun.Yang\.julia\conda\3\python.exe"
    #Pkg.build("PyCall")

    # ENV["PYTHON"] = joinpath(Conda.ROOTENV, "envs", "py382", "python.exe")
    # Pkg.build("PyCall")

    # ENV["PYTHON"] = joinpath(Conda.ROOTENV, "envs", env, "python.exe")
    # Pkg.build("PyCall")



    
end

learn_basic()

nothing

