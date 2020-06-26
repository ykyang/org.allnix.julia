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
import WebIO
WebIO.install_jupyter_nbextension()
