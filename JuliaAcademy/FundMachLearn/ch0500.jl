#' # Modeling data 2

#' ## Building a model
#' Recall that in notebook 3, we saw that we could use a mathematical function
#' to classify an image as an apple or a banana, based on the average amount of
#' green in an image:
#'
#' ![data_flow](data/data_flow.png)
#'
#' ![what_is_model](data/what_is_model.png)

#' A common function for performing this kind of **classification** is the
#' sigmoid that we saw in the last notebook, and that we will now extend by
#' adding two **parameters**, $w$ and $b$:
#'
#' $$\sigma(x; w, b) := \frac{1}{1 + e^{(-wx + b)}}$$
#'
#' $$x = \mathrm{data}$$
#'
#'
#' $$\begin{align}
#' \sigma(x;w,b) &\approx 0 \implies \mathrm{apple} \\
#' \sigma(x;w,b) &\approx 1 \implies \mathrm{banana}
#' \end{align}$$
#'
#' In our mathematical notation above, the `;` in the function differentiates
#' between the **data** and the **parameters**. `x` is the data and is
#' determined from the image. The parameters, `w` and `b`, are numbers which we
#' choose to make our function match the results it should be modeling.

#' Note that in the code below, we don't distinguish between data and
#' parameters - both are just inputs to our function, σ!

using Images, Statistics

apple = load("data/10_100.jpg")
banana = load("data/104_100.jpg")

apple_green_amount = mean(Float64.(green.(apple)))
banana_green_amount = mean(Float64.(green.(banana)))

println("Average green for apple = $apple_green_amount")
println("Average green for banana = $banana_green_amount")

#+ results="hidden"
σ(x, w, b) = 1 / (1 + exp(-w * x + b))
#+

#' What we want is that when we give σ as input the average green for the apple,
#' roughly `x = 0.3385`, it should return as output something close to 0,
#' meaning "apple". And when we give σ the input `x = 0.8808`, it should output
#' something close to 1, meaning "banana".

#' By changing the parameters of the function, we can change the shape of the
#' function, and hence make it represent, or **fit**, the data better!

#' ## Data fitting by varying parameters

# We can understand how our choice of `w` and `b` affects our model by seeing how our values for `w` and `b` change the plot of the $\sigma$ function.

using Plots;
gr()   # GR works better for interactive manipulations
#plotly()
#' Run the code in the next cell. You should see two "sliders" appear, one for
#' `w` and one for `b`.

#' **Game**:
#' Change w and b around until the blue curve, labeled "model", which is the
#' graph of the `\sigma` function, passes through *both* of the data points at
#' the same time.

w = 10.0 # try manipulating w between -10 and 30
b = 10.0 # try manipulating b between 0 and 20

using Interact

pt = plot()
scatter!(pt, [apple_green_amount],  [0.0], label="apple", ms=5)   # marker size = 5
scatter!(pt, [banana_green_amount], [1.0], label="banana", ms=5)
plot!(pt, x -> σ(x, w, b), xlim=(-0,1), ylim=(-0.1,1.1), label="model",
legend=:topleft, lw=3)
# Interact must be the last plot command
function myplot(w,b)
      pt = plot()
      scatter!(pt, [apple_green_amount],  [0.0], label="apple", ms=5)   # marker size = 5
      scatter!(pt, [banana_green_amount], [1.0], label="banana", ms=5)
      plot!(pt, x -> σ(x, w, b), xlim=(-0,1), ylim=(-0.1,1.1), label="model", legend=:topleft, lw=3)
end
# pw = widget(-10:1:30, label="w")
# pb = widget(0:1:20, label="b")
# ipl = map(pt, pw, pb)
# vbox(pw, pb, ipl)
@manipulate for w=-10:0.2:30,b = 0:0.2:20
     vbox(w,b,myplot(w,b))
end


#'
