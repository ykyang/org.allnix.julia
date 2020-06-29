#' ## Run this cell to load the graphics packages
using Plots
gr()

#' ## Run this cell to use a couple of definitions from the previous
#' Tools notebook

sigma(x) = 1 / (1 + exp(-x))
f(x, w) = sigma(w * x)

#' ## Multiple function parameters
#'
#' In notebook 6, we saw how we could adjust a parameter to make a curve fit
#' a single data point. What if there is more data to fit?
#'
#' We'll see that as we acquire more data to fit, it can sometimes be useful
#' to add complexity to our model via additional parameters.

#' ## Multiple function parameters
#'
#' In notebook 6, we saw how we could adjust a parameter to make a curve fit
#' a single data point. What if there is more data to fit?
#'
#' We'll see that as we acquire more data to fit, it can sometimes be useful
#' to add complexity to our model via additional parameters.

#' ## Adding more data
#' Suppose there are now two data points to fit, the previous $(x_0, y_0)$
#' used in notebook 6 and also $(x_1, y_1) = (-3, 0.3)$.

#' #### Exercise 1
#
# Make an interactive plot of the function $f_w$ together with the two data
# points. Can you make the graph of $f_w$ pass through *both* data points
# at the *same* time?

x0, y0 = 2, 0.8
x1, y1 = -3, 0.3
w = 0.4
plot(x->f(x, w), -5, 5, ylims=(0, 1), label="f")
scatter!([x0,x1], [y0,y1], label="data")

#' You should have found that it's actually *impossible* to fit both data points
#' at the same time! The best we could do is to *minimise* how far away the
#' function is from the data. To do so, we need to somehow balance the distance
#' from each of the two data points.

#' #### Exercise 2
#'
#' Play with the slider to find the value $w^*$ of $w$ that you think has the "least error" in an intuitive sense.

w=0.45
plot(x->f(x, w), -5, 5, ylim=(0,1))
scatter!([x0, x1], [y0, y1])

#' ## Defining a loss function
#' How can we *quantify* some kind of overall measure of the distance from *all* of the data? Well, we just need to define a new loss function! One way to do so would be to sum up the loss functions for each data point, i.e. the sum of the squared vertical distances from the graph to each data point:
#'
#' $$L(w) = [y_0 - f_w(x_0)]^2 + [y_1 - f_w(x_1)]^2.$$
#'
#' Since the two pieces that we are adding have the same mathematical "shape" or structure, we can abbreviate this by writing it as a sum:
#'
#' $$L(w) = \sum_{i=0}^1 [y_i - f_w(x_i)]^2.$$

#' So now we want to find the value $w^*$ of $w$ that minimizes this new
#' function $L$!

#' #### Exercise 3
#'
#' Make a visualization to show the function $f_w$ and to visualize the
#' distance from each of the data points.
xs = [2, -3]
ys = [0.8, 0.3]

L(w) = sum( (ys .- f.(xs, w)) .^ 2 )

begin
    w = 0.3 # Try manipulating w between -2 and 2

    plot(x->f(x, w), -5, 5, ylims=(0, 1), lw = 3, label="f_w")

    scatter!(xs, ys, label="data")

    for i in 1:2
        plot!([xs[i], xs[i]], [ys[i], f(xs[i], w)], c=:green)
    end


    title!("L(w) =  $(round(L(w); sigdigits = 5))")
end


#' #### Exercise 4
#'
#' After playing with this for a while, it is intuitively obvious that we
# cannot make the function pass through both data points for any value of
# $w$. In other words, our loss function, `L(w)`, is never zero.
#'
#' What is the minimum value of `L(w)` that you can find by altering `w`?
#' What is the corresponding value of `w`?
w = 0.42
plot(x->f(x, w), -5, 5, ylims=(0, 1), lw = 3, label="f_w", legend=(0.8,0.1))

scatter!(xs, ys, label="data")

for i in 1:2
    plot!([xs[i], xs[i]], [ys[i], f(xs[i], w)], c=:green)
end


title!("L($w) =  $(round(L(w); sigdigits = 5))")

#' ### Sums in Julia
#' To generate the above plot we used the `sum` function.
#' `sum` can add together all the elements of a collection or range,
#' or it can add together the outputs of applying a function to all the
#' elements of a collection or range.
#'
#' Look up the docs for `sum` via
#'
#' ```julia
#' ?sum
#' ```
#' if you need more information.

#' #### Exercise 6
#'
#' What is the sum of the absolute values of all integers between -3 and 3? Use `sum` and the `abs` function.

#' #### Solution

sum(abs, -3:3)

#' ## What does the loss function $L$ look like?
#' In our last attempt to minimize `L(w)` by varying `w`, we saw that `L(w)`
#' always seemed to be greater than 0.  Is that true? Let's plot it to find out!

#' #### Exercise 7
#'
#' Plot the new loss function $L(w)$ as a function of $w$.
#' #### Solution
plot(L, -2, 2, xlabel="w", ylabel="L(w)", ylims=(0, 1.2))

#' ### Features of the loss function
#' The first thing to notice is that $L$ is always positive.
#' Since it is the sum of squares, and squares cannot be negative,
#' the sum cannot be negative either!
#'
#' However, we also see that although $L$ dips close to $0$ for a single,
#' special value $w^* \simeq 0.4$, it never actually *reaches* 0!
#' Again we could zoom in on that region of the graph to estimate it more
#' precisely.

#' We might start suspecting that there should be a better way of using the
#' computer to minimize $L$ to find the location $w^*$ of the minimum,
#' rather than still doing everything by eye. Indeed there is, as we will
#' see in the next two notebooks!

#' ## Adding more parameters to the model

#' If we add more parameters to a function, we may be able to improve how it
#' fits to data. For example, we could define a new function $g$ with another
#' parameter, a shift or **bias**:
#'
#' $$g(x; w, b) := \sigma(w \, x + b).$$

g(x, w, b) = sigma(w*x + b)