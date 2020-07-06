#' # Minimizing functions - how a computer learns

#' In the previous notebooks, we've seen that by changing **parameters** in a
#' function, we could find a "best fit" of that function to some data. We use
#' a **loss function** to quantify the "goodness" of a set of parameters and
#' we look for those parameters that **optimize**, in fact **minimize**,
#' the loss function. If we teach a machine how to minimize the loss function
#' on its own, we say that machine is able to **learn** how to model our data.
#'
#' In the last notebook, we threw around terms like **derivative**,
#' **gradient**, and **gradient descent** to give you a rough sense of how we
#' minimize a function on a computer. In this notebook, we will step through
#' these concepts more carefully, with the aim of being able to implement them
#' using Julia.

#' ## Minimizing a 1D function using calculus
#' Let's draw the 1D loss function $L_1$ from a previous notebook again:

using Plots
#gr()
#pyplot()
plotly()

sigma(x) = 1 / (1 + exp(-x))
f(x,w) = sigma(w * x)

x1 = 2
y1 = 0.8

L1(w) = (y1 - f(x1, w))^2

plot(L1, -2, 1.5, xlabel="w", ylabel="L1(w)", legend=false)

#' By eye, we can see that the minimum is around $w=0.6$. But how can we get
#' the computer to work this out on its own?

#' In the previous notebook, we thought of this function plot as a hill,
#' viewed from the side. We could find the minimum by making the hill sticky,
#' and letting a ball roll down it. The ball will find and settle in the
#' minimum of the function.  Now let's see how to teach a computer to do this.

#' We need to find the downhill direction along the hill, which is related to
#' its *slope* (how steep it is). Calculus provides us with tools to calculate
#' that slope!

#' Namely, the slope of a curve $L_1(w)$ at $w$ is given by its **derivative**
#' $L_1'(w)$; geometrically, this is the slope of the **tangent line** to the
#' curve at that point, i.e. the straight line which touches the curve at that
#' point.

#' Calculus provides us with some rules to calculate an analytical formula for
#' the derivative, and we will see later how to apply these rules, albeit
#' indirectly, for machine learning.
#' To gain understanding, however, we will see here how to get the computer
#' to help us out by calculating the derivatives **numerically** instead!

#' ## Approximating derivatives

#' Let's recall that the derivative $L_1'(w)$ of a function is defined as
#'
#' $$L_1'(w) \simeq \frac{L_1(w+h) - L_1(w)}{h},$$
#'
#' for a small step size $h$. (Strictly speaking, we must take the limit
#' when $h$ tends to $0$ to obtain the exact value of the derivative.)

#' #### Exercise 1
#'
#' Write a function to calculate the derivative of a function at a given
#' point. Note that in Julia, we can easily pass functions as arguments
#' to other functions!
#' The function should take the function, the point $w$ at which to calculate
#' the derivative, and the value of $h$, which should have a default value
#' of 0.001.
#'
#' *Note*: A function input argument can have a *default value* if we set
#' the input argument equal to that default value when we define the function.
#' For example,
#'
#' ```julia
#' f(x, a = 3) = a * x^2
#' ```
#'
#' The function `f` will square the input we give it and multiply by `a`.
#' However,  if we choose to call `f(x)` *without* passing it an `a` input,
#' it will assume `a` is `3` and return `3*x^2`.

#' #### Solution
#'
#' We could define the `derivative` function as
function derivative(f, w, h=0.001)
    Ans = f(w + h) - f(w)
    Ans /= h
    return Ans
end

#' **Tests**
@assert isapprox(derivative(x -> x^2, 0.2), 0.4, atol=0.01)
@assert isapprox(derivative(x -> x^2, 0.2, 0.5), 0.9, atol=0.5)
@assert isapprox(derivative(x -> x^3, 0.2), 0.12, atol=0.01)


#' #### Exercise 2
#'
#' Write an interactive visualization of the tangent line to the graph of
#' $L_1$, so that we can visualize the tangent at any point on $L_1$.
#' Include the current value of the derivative in the title.
#'
#' *Hint*: Recall that the straight line through the point $(x_0, y_0)$ with
#' slope $m$ is given by
#'
#' $$\frac{y - y_0}{x - x_0} = m,$$
#'
#' so
#'
#' $$y = y_0 + m*(x - x_0).$$

wmin = -2
wmax = 1
w = 0.5
pl = plot(L1, wmin, wmax, label="L_1")

x0 = w
y0 = L1(w)
scatter!(pl, [x0], [y0], label="")

m = derivative(L1, w)

plot!(pl, x -> y0 + m * (x - x0), ls=:dash, label="tangent line")

ylims!(pl, -0.1, 0.6)
xlims!(pl, wmin, wmax)

#' #### Exercise 3
#'
#' What is the value of the derivative (slope of the tangent line) at a
#' minimum? Can this happen anywhere else?

#' #### Solution
#' The derivative is `0` at a minimum. This happens at any minimum, maximum or
#' "point of inflection" of a smooth function.

#' #### Exercise 4
#'
#' When the derivative $L_1'(w)$ is positive, that means that $L_1$ increases
#' from left to right at point $w$.
#'
#' If the derivative $L_1'(w)$ is positive (> 0), in which direction should
#' we move $w$ to *decrease* $L_1$?

#' #### Solution
#'
#' We should move $w$ left, i.e. decrease it.

#' #### Exercise 5
#'
#' If the derivative $L_1'(w)$ is negative (< 0), in which direction should we
#' move $w$ to *decrease* $L_1$?

#' We can use this information to tell the computer which way to take a step.
# This constitutes the numerical algorithm called **gradient descent**;
#' it is called this since we are descending (moving downwards) along the
#' graph of the function by using information about its gradient (slope).

#' #### Exercise 6
#'
#' Implement gradient descent by following this prescription for an
#' **iterative (repetitive) algorithm**:
#'
#' 1. Start at an initial guess $w_0$ for $w$.
#'
#' 2. At each step, calculate the derivative, $L_1'(w_n)$ at the current value
#' of $w_n$ using the function that you created above.
#'
#' 3. Modify the value of $w$ by a small multiple (for example, $\eta=0.01$)
#' of the value of the derivative you just created, via
#' $w_{n+1} = w_n - \eta L_1'(w_n)$.
#'
#' For this problem, start with $w_0 = -2.0$. Repeat steps 2 and 3 a total
#' of `2000` times.
#'
#' Package this code into a function called `gradient_descent` that takes two
#' inputs, a function and a range for values of $w$, and returns the final
#' value of $w$ and $L_1(w)$.
#'
#' Using `L1` and `-2:0.01:1.5` as your inputs to `gradient_descent`,
#' for what value of $w$ is $L_1$ at a minimum?

#' #### Solution
function gradient_descent(f) # wrange not used?
    w = -2.0
    for i in 1:2000
        fprime = derivative(f, w)
        step = 0.01 * fprime
        w = w - step
    end

    return w, f(w)
end

(w, fw) = gradient_descent(L1)

#' #### Exercise 7
#'
#' Modify your code for gradient descent to return the result once it has
#' found an answer within some *tolerance*, rather than taking a set number
#' of steps. The new prescription for this algorithm is:
#'
#' 1. Start at an initial guess $w_0$ for $w$.
#'
#' 2. At each step, calculate the derivative, $L_1'(w_n)$ at the current value
#' of $w_n$, using the function that you created above.
#'
#' 3. Modify the value of $w$ by a small multiple (for example, $\eta=0.01$)
#' of the value of the derivative you just created, via
#' $w_{n+1} = w_n - \eta L_1'(w_n)$.
#'
#' 4. Check how different $w_{n+1}$ is from $w_n$. If you're satisfied that
#' $L_1(w_{n+1})$ is minimized, return $w_{n+1}$ and $L_1(w_{n+1})$.
#' Otherwise, go to step (2) and continue.
#'
#' Edit `gradient_descent` so that it takes three inputs: a function, a range
#' for values of $w$, and a tolerance that tells you how close $w_{n+1}$ must
#' be to $w_n$ before you can stop iterating.
#'
#' Using `L1`, `-2:0.01:1.5`, and `.000001` as your inputs to
#' `gradient_descent`, for what value of $w$ is $L_1$ at a minimum?

#' #### Solution
#'
#'
#' Your code should look something like this
#'
#' $L_1$ is at a minimum when `gradient_descent(L1, -2:0.01:1.5, .000001)[1]`,
#' or $w$, is around `0.69216`.

function gradient_descent(f, tol)
    w = -2.0
    ccount = 0
    
    while ccount < 2000000   # do no more than 2000 times
        fprime = derivative(f, w)
        step = 0.01 * fprime
        w = w - step
        if abs(step) < tol
            return w, f(w)
        end

        ccount += 1
    end
end

(w, fw) = gradient_descent(L1, 0.000001)
@assert 0.69215 < w < 0.69217



#' After you've completed this step, you will have found a good approximation
#' to the value $w^*$ where $L_1$ reaches its minimum, and the minimum
#' value $L_1(w^*)$, which in this case is (almost) $0$.

#' #### Exercise 8
#'
#' Alter the function `gradient_descent` so that it stores the results
#' `(w, L1(w))` at each step of the algorithm as an array and returns
#' this array. How many steps does the algorithm take for input parameters
#' `(L1, -2:0.01:1.5, .000001)` before terminating? You should count your
#' starting $w_0$ as your first step.

"""
    gradient_descent(f, wrange, tol)

Use gradient descent method to find the minimum of a function.

# Examples

# Arguments
- `f`: Find the minimum of the function `f`.
- `wrange`: User proivded initial guess range.
- `tol`: Tolerance of consequtive step size.  Returns when the difference of
        consequtive steps is less than `tol`.
"""
function gradient_descent(f, wrange; tol=0.000001, w_init=undef)
    # find initial guess from wrange
    if w_init == undef
        w_vec = Vector{Float64}(undef, 0)
        fw_vec = Vector{Float64}(undef, 0)
    
        for w = wrange
            fw = f(w)
            push!(w_vec, w)
            push!(fw_vec, fw)
        end

        min_ind = argmin(fw_vec)
        w_init = w_vec[min_ind]
        fw_init = fw_vec[min_ind]
        println("Initial guess: $w_init, $fw_init")
    # return (w_inti, fw_init)
    end

    # gradient descent
    w = w_init
    w_vec = Vector{Float64}(undef, 0)
    fw_vec = Vector{Float64}(undef, 0)
    ccount = 0
    fw = f(w)
    push!(w_vec, w)
    push!(fw_vec, fw)
    while ccount < 1000000
        fprime = derivative(f, w)
        step = 0.01 * fprime

        w = w - step
        fw = f(w)
        push!(w_vec, w)
        push!(fw_vec, fw)
        if abs(step) < tol
            println("iteration = $ccount")
            return w_vec, fw_vec
        end

        ccount += 1
    end

    error("Exceeded maximum iterations")
end
(w, fw) = gradient_descent(L1, -2:0.1:1.5; tol=0.000001)
println("Iteration count: $(length(w))")

#' #### Exercise 9
#'
#' Overlay the steps taken in the last exercise with a plot of
#' $L_1(w)$ vs. $w$.
#'
#' Where does our algorithm take the largest steps?
#' (Where does the ball move fastest down the hill?)
#'
#' A) Between w = -2:-1<br>
#' B) Between w = -1:0<br>
#' C) Between w = 0:.6
#'
#' *Hint*: It may be easier to see what's going on if you only plot,
#' for example, every 15th step.

# Initial guess = 0.7 so the plot range needs to be smaller to see
(w, fw) = gradient_descent(L1, -2:0.1:1.5; tol=0.000001)
pl = plot(L1, 0.692, 0.70, xlabel="w", ylabel="L1(w)", legend=false)
ws = reverse(w[end:-50:1]) # Make sure end point is included
fws = reverse(fw[end:-50:1]) 
scatter!(pl, ws,fws)

# Initial guess = -2.0
(w, fw) = gradient_descent(L1, -2:0.1:1.5; tol=0.000001, w_init=-2)
pl = plot(L1, -2, 1.5, xlabel="w", ylabel="L1(w)", legend=false)
ws = reverse(w[end:-50:1]) # Make sure end point is included
fws = reverse(fw[end:-50:1]) 
scatter!(pl, ws,fws)

#' ## Functions of 2 variables and their derivatives
#' So far, we have been looking at the minimizing a loss function
#' $L_1(w)$ that depends on a single parameter, $w$. Now let's turn to
#' the cost function $L_2(w, b)$ from a previous notebook, that is a
#' function of *two* parameters, $w$ and $b$, and try to minimize it.
#'
#' As we've seen, we get a **surface**, instead of a curve,
#' when we graph $L_2$ as a function of both of its parameters.

#' **Exercise 10**
#'
#' Draw a surface plot of $L_2$, given by
#'
#' $$L_{2}(w, b) = \sum_i(y_i - g(x_i, w, b))^2$$
#'
#' using the `surface` function from `Plots.jl`. For this plot, use the
#' values of `xs` and `ys` from notebook 5:
#'
#' We can get a nice interactive 3D plot by using the Plotly backend
#' of `Plots.jl` by executing the command
#'
#'     plotly()
# if !(@isdefined WEAVE_ARGS)
#     plotly()
# end

xs = [2, -3, -1, 1]
ys = [0.8, 0.3, 0.4, 0.4]

sigma(x) = 1/(1 + exp(-x))
g(x,w,b) = sigma(w*x) + b

L2(w,b) = sum(abs2, ys .- g.(xs,w,b))

pl = plot()
surface!(pl, -2:0.02:2, -2:0.02:2, L2, alpha=0.6, xlabel="w",
        ylabel="b", zlabel="L2(w,b)",
        size=(600,600))
#'
if !(@isdefined WEAVE_ARGS)
    gui(pl)
end

#' ### Finding the minimum
#' We can just about see, by rotating the graph, that $L_2$ has a single
#' minimum. We want to find the values of $w$ and $b$ where this
#' minimum value is reached.

#' Following what we did for the function $L_1$ above, we expect that
#' we will need to calculate derivatives of $L_2$. Since the function is
#' more complicated, though, the derivatives are too!
#'
#' It turns out that the right concept is that of the
#' [**gradient**](https://en.wikipedia.org/wiki/Gradient) of
#' $L_2$, denoted $\nabla L_2(w, b)$. This is a **vector** consisting
#' of $2$ numbers if there are $2$ parameters 
#'[or, in general, $n$ numbers if there are $n$ parameters].
#'
#' The numbers that form the gradient $\nabla L_2(w, b)$ are called the **partial derivatives** of $L_2$ with respect to $w$ and $b$,  written as
#'
#' $$\frac{\partial L_2}{\partial w} \quad \text{and} \quad \frac{\partial L_2}{\partial b}.$$
#'
#' Although this notation might look complicated, all it means is that we calculate derivatives just like we did before, except that we fix the value of the other variable.
#' For example, to calculate $\frac{\partial L_2}{\partial w}$, the partial derivative of $L_2$ with respect to $w$, we fix the value of $b$ and think of the resulting function as a function of the single variable $w$; then we use the formula for derivatives of functions of a single variable.
#'
#' [Note that $\frac{\partial L_2}{\partial w}$ is itself a function of $w$ and $b$; we could write $\frac{\partial L_2}{\partial w}(w, b)$.]
