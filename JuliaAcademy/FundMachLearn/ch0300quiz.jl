#' ## Functions
#'
#'
#' In the last notebook, we talked about modeling data with functions. A **function** is one of the most fundamental concepts in computing (and also in mathematics).
#'
#' A function is a piece of a program that receives **input arguments**, processes them by doing certain calculations on them, and returns **outputs**.
#'
#' For example, we might have a function `g` that takes a number as an input and returns the square of that number as an output. How can we define this function `g` on a computer? Julia gives us a few different ways to do this.
#' ### Defining functions
#' Firstly, we could write `g` as follows:

#+ results="hidden"
g(x) = x^2
#+
#'
g(2), g(3.5) # This is a tuple.
#'
g(3.0)
#' Alternatively, we could declare this function using the `function` and `end` keywords:
#+ results="hidden"
function g1(x)
    x^2
end
#+
g1(2), g1(3.5)
#' The third way we could have declared this function is as an "anonymous" or
#' "lambda" function. "Anonymous" functions are functions that truly don't need
#' names! For example, we could have declared a function that squares its input
#' as
(x->x^2)(2)
#' Now that we've done that, we can't access the function `x -> x^2` again
#' because we have no name to call! That seems a little silly, doesn't it?
#'
#' Actually, there are times where functions without names are especially
#' handy.  Most commonly they're used arguments to "higher-order" functions:
#' these are functions which take _other functions_ as arguments. For example:
map(sqrt, [1, 2, 3])
#'
map(x->x^2, [1, 2, 3])
#' Of course, you can also assign anonymous function a name, but in general
#' it's better style to use the non-anonymous equivalents above if you actually
#' want to use a name.
g2 = x -> x^2
g2(3.5), g2("I ♡ Julia ") # Use \heartsuit + TAB to get the ♡ character

#' ## An important sigmoidal function
#' A particular function that is used a lot in machine learning is a so-called
#' "sigmoidal" function (meaning a function that is S-shaped, i.e. the graph
#' of the function looks like an `S`).
#'
#' $$\sigma(x) = \frac{1}{1 + e^{-x}}$$
#'
#' The sigmoid function that we will use is given the name $\sigma$, and is
#' defined by the following mathematical expression:
#'
#' $$\sigma(x) := \frac{1}{1 + \exp(-x)}$$

#' #### Exercise 1
#'
#' Use the first syntax given above to define the function `σ` in Julia.
#' Note that Julia actually allows us to use the symbol σ as a variable name!
#' To do so, type `\sigma<TAB>` in the code cell.

#' #### Solution
# Short form
σ(x) = 1/(1 + exp(-x))
σ(1)
#+ results="hidden"
# Long form
function sigma(x)
    1/(1 + exp(-x))
end
#+
sigma(1)


#' ## Plotting functions

#' Let's draw the function σ to see what it looks like. Throughout this course,
#' we'll use the Julia package `Plots.jl` for all of the graphics. This package
#' provides a flexible syntax for plotting, in which options to change
#' attributes like the width of the lines used in the figure are given as named
#' keyword arguments.
#'
#' In addition, it allows us to use different "backends", which are the other
#' libraries that actually carry out the plotting following the instructions
#' from `Plots.jl`.
using Plots
#gr()
# plotly interferes mathjax, tpl file needs to be fixed
# see templates/julia_html.tpl
plotly()

pl = plot(sigma, -5, 5, legend=(0.1,0.9), label="σ")
# add horizontal lines at 0 and 1, with dashed style and linewidth 3
hline!(pl, [0,1], ls=:dash, lw=3, label=false)
# add a vertical line at 0
vline!(pl, [0], ls=:dash, lw=3, label=false)

#' We can think of $\sigma$ as a smooth version of a step or threshold function
#' (often called a "Heaviside" function). To see this, let's modify the
#' steepness of the jump in $\sigma$ and compare it to the Heaviside function;
#' we'll see how all this works in more detail later:
#+ results="hidden"
function heaviside(x)
    x < 0 ? 0.0 : 1.0
end
#+

#' try manipulating the value of `w` between 0 to :
w = 10.0
plot(x->sigma(w*x), -5, 5, label="σ", lw=2, legend=(0.1,0.9))
plot!(heaviside, ls=:dash, label="step")
