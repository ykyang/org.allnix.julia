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

#' Try manipulating the value of `w` between 0 to :
w = 10.0
plot(x->sigma(w*x), -5, 5, label="σ", lw=2, legend=(0.1,0.9))
plot!(heaviside, ls=:dash, label="step")
# This particular function takes any real number as input, and gives an output
# between $0$ and $1$. It is continuous and smooth.
#' Try a smaller $w$.
w = 1.0
plot(x->sigma(w*x), -5, 5, label="σ", lw=2, legend=(0.1,0.9))
plot!(heaviside, ls=:dash, label="step")
#' #### Exercise 2
#' Declare the sigmoid function above as an anonymous function with a different
#' name.
σx = x -> 1/(1+exp(-x))
σx(1)
#' ### Mutating functions: `...!`
#' To generate our plot of σ above, we used some functions that end with `!`.
#'  What does a `!` at the end of a function name mean in Julia?
#'
#' Functions that change or modify their inputs are called
#' **mutating functions**. But wait, don't all functions do that?
#' No, actually. Functions typically take *inputs* and use those *inputs* to
#' generate *outputs*, but the inputs themselves usually don't actually get
#' changed by a function. For example, copy and execute the following code:
v1 = [9, 4, 7, 11]
v2 = sort(v1)
#' `v2` is a sorted version of `v1`, but after calling `sort`, `v1` is still
#' unsorted.
v1
#+ results="hidden"
sort!(v1)
#' Look at the values in `v1` now!
v1
#' This time, the original vector itself was changed (mutated), and is now
#' sorted. Unlike `sort`, `sort!` is a mutating function. Did the `!` make
#' `sort!` mutating? Well, no, not really. In Julia, `!` indicates mutating
#' functions by convention. When the author of `sort!` wrote `sort!`, they added
#' a `!` to let you to know that `sort!` is mutating, but the `!` isn't what
#' makes a function mutating or non-mutating in the first place.

#' #### Exercise
#' Some of our plotting commands end with `!`. Copy and execute the following code:
r = -5:0.1:5
g(x) = x^2
h(x) = x^3
plot(r, g, label="g")
plot!(r, h, label="h")
#' Then change the code slightly to remove the `!` after `plot!(r, h)`.
#' How does this change your output? What do you think it means to add `!`
#' after plotting commands?
#' #### Solution
r = -5:0.1:5
g(x) = x^2
h(x) = x^3
p1 = plot(r, g, label="g")
#'
p2 = plot(r, h, label="h")
#' ```julia
#' plot(r, g)
#' plot!(r, h)
#' ```
#' creates an overlay of `g` and `h`, whereas
#'
#' ```julia
#' plot(r, g)
#' plot(r, h)
#' ```
#'
#' creates one plot for `g` and one for `h`.
#'
#' When we add a `!` after a plotting command, we are mutating or updating an
#' *existing* plot.

#' ## Pointwise application of functions, `f.(x, y)` and `x .+ y` - broadcasting
#' We saw in a previous notebook that we needed to add `.` after the names of
#' some functions, as in
#'
#' ```julia
#' green_amount = mean(Float64.(green.(apple)))
#' ```
#'
#' What are those extra `.`s really doing?
#'
#' When we add a `.` after a function's name, we are telling Julia that we want
#' to "**broadcast**" that function over the inputs passed to the function.
#' This means that we want to apply that function *element-wise* over the
#' inputs; in other words, it will apply the function to each element of the
#' input, and return an array with the newly-calculated values.

#' For example, copy and execute the following code:
g.(r)
#' Since the function `g` squares it's input, this squares all the elements of
#' the range `r`.
#' What happens if instead we just call `g` on `r` via
# g(r)

#' You should see an error message after calling `g(r)`, which says that Julia
#' cannot multiply two vectors. When we call `g(r)`, we ask Julia to multiply
#' `r` by `r`. When we call `g.(r)`, we ask Julia to multiply *each element*
#' in `r` by itself.

#' Try this and see what happens.
x = [1 2 3; 4 5 6]
f(t) = sqrt(t) + 5
f.(x)

#' #### Exercise 3
#'
#' Copy and execute the following code to get the type of the object
#' `numbers = [1, 2, "three", 4.0]`:
#+ results="hidden"
numbers = [1, 2, "three", 4.0]
#' What is the type of `numbers`?
typeof(numbers)
#' Its type is `Array{Any,1}`. This means that `numbers` is a
#' 1-dimensional array that has elements of abstract type `Any`. We can think
#' of the `Any` type as a classification that includes *all* concrete types,
#' for example, `Float64`, `Int32`, `Bool`, `String`, `Char`, etc.

#' #### Exercise 4
#'
#' Broadcast `typeof` over `numbers` to see what the types of the elements
#' stored inside `numbers` are.
typeof.(numbers)

#' Note: Alternatively, we could have looked at the `typeof` each element in
#' the array `numbers` using a `for` loop:
for n in numbers
    println(typeof(n))
end

#' #### Exercise 5
#'
#' Write a `for` loop that applies `g` to each of the elements of `r` and
#' prints the results. Verify that the numbers printed by this `for` loop are
#' equal to the entries of the output of `g.(r)`.
r = -5:0.1:5
for x in r
    #println(g(x)) # uncomment to print
end

#' We can check this via
broadcasted_g = g.(r)
for (x, bg) = zip(r, broadcasted_g)
    # println(g(x) == bg) # uncomment to print
end

#' A better way
answers_match = true
for (x, bg) = zip(r, broadcasted_g)
    if (g(x) != bg)
        answers_match = false
    end
end
answers_match ? println("Our `for` loop worked!") : println("Our `for` loop does not work")

#' #### Exercise 6
#'
#' Define a range `xs` between -5 and 5 with steps of 0.5.
#' Apply the $\sigma$ function pointwise to this range and define `ys` as the
#' result.
#' What does the result look like? Plot these as points and join them with
#' lines.
#'
#' Make the plot interactive where you can vary the step size. Fix the range of
#' the plot in the `x` and `y` directions using the functions `xlims!` and
#' `ylims!`.
#'
#' Learn about plot optinos by `plotattr(:Series)` and `plotattr("markershape")`
xs = -5:0.5:5
ys = sigma.(xs)
pl = plot(xs, ys; legend=(0.1,0.9), markershape=:circle)

#' Try manipulating `stepsize` between 0 and 1:
stepsize = 0.5
xs = -5.0:stepsize:5.0
ys = σ.(xs)

scatter(xs, ys)
plot!(xs, ys)

xlims!(-5, 5)
ylims!(0, 1)
