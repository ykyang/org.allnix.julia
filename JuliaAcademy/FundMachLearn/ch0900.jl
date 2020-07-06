#' ## What is learning?
#'
#' Computers read data, as we saw in notebooks 1 and 2. We can then build
#' functions that model that data to make decisions, as we saw in notebooks
#' 3 and 5.
#'
#' But how do you make sure that the model actually fits the data well?
#' In the last notebook, we saw that we can fiddle with the parameters of our
#' function defining the model to reduce the loss function. However, we don't
#' want to have to pick the model parameters ourselves.
#' Choosing parameters ourselves works *well enough* when we have a simple
#' model and only a few data points, but can quickly become extremely complex
#' for more detailed models and larger data sets.
#'
#' Instead, we want our machine to *learn* the parameters that fit the model
#' to our data, without needing us to fiddle with the parameters ourselves.
#' In this notebook, we'll talk about the "learning" in machine learning.

#' ### Motivation: Fitting parameters by hand
#'
#' Let's go back to our example of fitting parameters from notebook 3.
#' Recall that we looked at whether the amount of green in the pictures could
#' distinguish between an apple and a banana, and used a sigmoid function to
#' model our choice of "apple or banana" using the amount of green in an image.

using Plots
gr()
using Images, Statistics

sigma(x,w,b) = 1/(1+exp(-w*x + b))

apple = load("data/10_100.jpg")
banana = load("data/104_100.jpg")
apple_g = mean(Float64.(green.(apple)))
banana_g = mean(Float64.(green.(banana)))

w = 1.0 # Try manipulating w between 0 and 30 to see how the plot changes
b = 1.0 # Try manipulating b bewteen 0 and 30

plot(x->sigma(x,w,b), 0, 1, label="Model", legend=(0.1,0.9), lw=3)
scatter!([apple_g], [0.0], label="Apple")
scatter!([banana_g], [1,0], label="Banana")

#' Intuitively, how did you tweak the sliders so that way the model sends apples
#' to 0 and bananas to 1? Most likely, you did the following:
#'
#' #### Move the sliders a bit, see whether the curve moves in the right
#' direction, and if it did, keep doing it.
#'
#' For a machine, "learning" is that same process, translated into math!

#' ## "Learning by nudging": The process of descent
#'
#' Let's start to formalize this idea. In order to push the curve in the
#' "right direction", we need some measurement of "how right" and "how wrong"
#' the model is. When we translate the idea of a "right direction" into math,
#' we end up with a **loss function**, `L(w, b)`, as we saw in notebook 5.
#' We say that the loss function is lowest when the model `σ(x, w, b)` performs
#' the best.
#'
#' Now we want to create a loss function that is the lowest when the apple
#' is at `0` and the banana is at `1`. If the data (the amount of green) for
#' our apple is $x_1$, then our model will output $σ(x_1,w, b)$ for our apple.
#' So, we want the difference $0 - σ(x_1, w, b)$ to be small. Similarly,
#' if our data for our banana (the banana's amount of green) is $x_2$,
#' we want the difference $1 - σ(x_2, w, b)$ to be small.
#'
#' To create our loss function, let's add together the squares of the
#' difference of the model's output from the desired output for the apple and
#' the banana. We get
#'
#' $$ L(w,b) = (0 - σ(x_1, w, b))^2 + (1 - σ(x_2, w, b))^2. $$
#'
#' $L(w, b)$ is lowest when it outputs `0` for the apple and `1` for the banana,
#' and thus the cost is lowest when the model "is correct".
#'
#' We can visualize this function by plotting it in 3D with the `surface`
#' function or in 2D with contour lines

L(w,b) = (0 - sigma(apple_g,w,b))^2 + (1 - sigma(banana_g,w,b))^2

w_range = 10:0.1:13
b_range = 0:1:20

L_vec = [L(w,b) for b in b_range, w in w_range]

w = 11.5 # Try manipulating w with values from w_range (between 10 and 13)
b = 10 # Try manipulating b with values from b_range (between 0 and 20)

p1 = contour(w_range, b_range, L_vec, levels=0.05:0.1:1, 
    xlabel="w", ylabel="b", cam=(70,40), cbar=false, leg=false)
scatter!(p1, [w], [b], markersize=5, color=:blue)

p2 = plot(x->sigma(x,w,b), 0, 1, label="Model", legend = (0.1,0.9), lw=3)
scatter!(p2, [apple_g],  [0.0], label="Apple", markersize=10)
scatter!(p2, [banana_g], [1.0], label="Banana", markersize=10, xlim=(0,1), ylim=(0,1))
plot(p1, p2, layout=(2,1))

#' The blue ball on the 3D plot shows the current parameter choices, plotted as
#' `(w,b)`. Shown below the 3D plot is a 2D plot of the corresponding model
#' with those parameters. Notice that as the blue ball rolls down the hill,
#' the model becomes a better fit. Our loss function gives us a mathematical
#' notion of a "hill", and the process of "learning by nudging" is simply
#' rolling the ball down that hill.

