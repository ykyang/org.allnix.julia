#' # Representing data in a computer
#' The core of data science and machine learning is **data**: we are interested in extracting knowledge from data.
#'
#' But how exactly do computers represent data? Let's find out exactly what an "artificial intelligence" has at its disposal to learn from.
import JuliaAcademyData
JAD = JuliaAcademyData

#' ## Data is represented as arrays
#'
#' Let's take a look at some fruit. Using the `Images.jl` library, we can load in some images:
import Images

#' Load apple
apple = Images.load("data/10_100.jpg")
#' Load banana
banana = Images.load("data/104_100.jpg")

#' Here we have images of apples and bananas. We would eventually like to build a program that can automatically distinguish between the two. However, the computer doesn't "see" an apple or a banana; instead, it just sees numbers.
#'
#' An image is encoded in something called an **array**, which is like a container that has boxes or slots for individual pieces of data:
#'
#' An array is a bunch of numbers in connected boxes; the figure above shows a 1-dimensional array. Our images are instead 2-dimensional arrays, or matrices, of numbers, arranged something like this:
#'
#'
#' ![array](data/array2d_s.png)
#'

@show typeof(apple)
@show size(apple)

apple
dump(apple[40,60])
x = apple[40,60]
apple[18:20,29:31]
Float64(Images.red(x))

import Statistics
STAT = Statistics

funcs = [Images.red, Images.green, Images.blue]
imgs = [apple, banana]
A = [ STAT.mean(float.( f.(img) )) for f = funcs, img = imgs ]

import Plots
Plots.gr()
v = float.(Images.green.(apple[:]))
pt = Plots.histogram(v, color="red", label="apple", normalize=true, nbins=25)
v = float.(Images.green.(banana[:]))
Plots.histogram!(pt, v, color="yellow", label="banana", normalize=true, nbins=25)

pixel = apple[40,60]

red = Float64(Images.red(pixel))
green = Float64(Images.green(pixel))
blue = Float64(Images.blue(pixel))
println("The RGB values are ($red, $green, $blue)")

pixel = apple[1,1]

red = Float64(Images.red(pixel))
green = Float64(Images.green(pixel))
blue = Float64(Images.blue(pixel))
println("The RGB values are ($red, $green, $blue)")

R_of_apple = Float64.(Images.red.(apple))
STAT.mean(R_of_apple)

R_of_banana = Float64.(Images.red.(banana))
STAT.mean(R_of_banana)

G_of_banana = Float64.(Images.green.(banana))
STAT.mean(G_of_banana)
