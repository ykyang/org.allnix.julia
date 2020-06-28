import Pkg

Pkg.add(Pkg.PackageSpec(url="https://github.com/JuliaComputing/JuliaAcademyData.jl"))
Pkg.add("Weave")
Pkg.add("IJulia")
Pkg.add("Images")
Pkg.add("ImageMagick")
Pkg.add("ImageIO")
Pkg.add("Interact")
Pkg.add("Statistics")
Pkg.add("Plots")
Pkg.add("GR")
Pkg.add("Plotly")
Pkg.add("Glob")
Pkg.add("WebIO")
Pkg.add("Conda")
Pkg.add("PyCall")
Pkg.add("PyPlot")
Pkg.add("Revise")

# Force PyCall to use Conda.jl
#ENV["PYTHON"] = ""
#Pkg.build("PyCall")

# Interact
#import WebIO
#WebIO.install_jupyter_nbextension()

