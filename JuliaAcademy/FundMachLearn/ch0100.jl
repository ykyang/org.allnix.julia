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

typeof(apple)
#'
size(apple)
#' We can grab the datum stored in the box at row `i` and column `j` by *indexing* using square brackets: `[i, j]`. For example, let's get the pixel (piece of the image) in box $(40, 60)$, i.e. in the 40th row and 60th column of the image:
apple
#'
dump(apple[40,60])
#'
x = apple[40,60]
#'
apple[18:20,29:31]

#' We see that Julia displays a coloured box! Julia, via the `Colors.jl` package, is clever enough t'o display colours in a way that is useful to us humans!
#'
#' So, in fact, an image is a 2D array, in which each element of the array is an object (a collection of numbers) describing a coloured pixel.

#' ## Colors as numbers
#'
#' How, then, are these colors actually stored? Computers store colors in RGB format, that is they s'tore a value between 0 and 1 for each of three "channels": red, green, and blue. Here, 0 means n'one of that color and 1 means the brightest form of that color. The overall color is a c'ombination of those three colors.
#'
#' For example, we can pull out the `red` value using the function `red` applied to the color. Since internally the actual value is stored in a special format, we choose to convert it to a standard floating-point number using the `Float64` function:
Float64(Images.red(x))
#'

import Statistics
STAT = Statistics

funcs = [Images.red, Images.green, Images.blue]
imgs = [apple, banana]
A = [ STAT.mean(float.( f.(img) )) for f = funcs, img = imgs ]
#'

import Plots
import Plotly
#Plots.gr()
Plots.plotly()
v = float.(Images.green.(apple[:]))
pt = Plots.histogram(v, color="red", label="apple", normalize=true, nbins=25)
v = float.(Images.green.(banana[:]))
Plots.histogram!(pt, v, color="yellow", label="banana", normalize=true, nbins=25)
#'
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
#'

R_of_banana = Float64.(Images.red.(banana))
STAT.mean(R_of_banana)
#'

G_of_banana = Float64.(Images.green.(banana))
STAT.mean(G_of_banana)

Ans = Plots.histogram(R_of_apple[:],color=:red,label="redness in the apple")

#' Julia's [mathematical standard library](https://docs.julialang.org/en/stable/stdlib/math/#Mathematics-1) has many mathematical functions built in. One of them is the `mean` function, which computes the average value. If we apply this to our apple:

STAT.mean(R_of_apple)

#' ## A quick riddle
#' Here's a quick riddle. Let's check the average value of red in the image of the banana.
R_of_banana = Float64.(Images.red.(banana))
STAT.mean(R_of_banana)
#' Oh no, that's more red than our apple? This isn't a mistake and is actually true! Before you move onto the next exercise, examine the images of the apple and the banana very carefully and see if you can explain why this is expected.

#' #### Exercise 1
#'
#' What is the average value of blue in the banana?
B_of_banana = Float64.(Images.blue.(banana))
STAT.mean(B_of_banana)

#' #### Exercise 2
#'
#' Does the banana have more blue or more green?
G_of_banana = Float64.(Images.green.(banana))
STAT.mean(G_of_banana)
#' which gives approximately `0.88`. The banana has more green on average.
