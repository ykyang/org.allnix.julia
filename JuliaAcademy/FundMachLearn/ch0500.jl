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

# apple = load("C:\\Users\\Yi-Kun.Yang\\work\\org.allnix.julia\\JuliaAcademy\\FundMachLearn/data/10_100.jpg")
# banana = load("C:\\Users\\Yi-Kun.Yang\\work\\org.allnix.julia\\JuliaAcademy\\FundMachLearn/data/104_100.jpg")
apple = load("data/10_100.jpg")
#'
banana = load("data/104_100.jpg")
#'

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

using Plots
gr()   # GR works better for interactive manipulations
#plotly()
#pyplot()

#' Run the code in the next cell. You should see two "sliders" appear, one for
#' `w` and one for `b`.

#' **Game**:
#' Change w and b around until the blue curve, labeled "model", which is the
#' graph of the `\sigma` function, passes through *both* of the data points at
#' the same time.

w = 10.0 # try manipulating w between -10 and 30
b = 10.0 # try manipulating b between 0 and 20

using Interact

# Function for Interact
function myplot(w,b)
      pt = plot()
      plot!(pt, x -> σ(x, w, b), xlim=(-0,1), ylim=(-0.1,1.1), label="model", legend=(0.1,0.9), lw=3)
      scatter!(pt, [apple_green_amount],  [0.0], label="apple", ms=5)   # marker size = 5
      scatter!(pt, [banana_green_amount], [1.0], label="banana", ms=5)

      return pt
end

#' Notice that the two parameters do two very different things. The **weight**,
#' `w`, determines *how fast* the transition between 0 and 1 occurs. It encodes
#' how trustworthy we think our data  actually is, and in what range we should
#' be putting points between 0 and 1 and thus calling them "unsure". The
#' **bias**, `b`, encodes *where* on the $x$-axis the switch should take place.
#' It can be seen as shifting the function left-right. We'll come to understand
#' these *parameters* more in notebook 6.

#' Here are some parameter choices that work well:

w = 25.58 #20.8
b = 15.6 #12.4
pt = myplot(w,b)

#+ results="hidden"
# Run this in Juno or Jupyter to get interative plot
# @manipulate for w=-10:0.2:30,b = 0:0.2:20
#      vbox(hbox(w,b),myplot(w,b))
# end
#+

#' (Note that in this problem there are many combinations of `w` and `b` that
#' fit the data well.)
apple2 = load("data/107_100.jpg")
#'
green_amount = mean(Float64.(green.(apple2)))
@show green_amount
scatter!(pt, [green_amount], [0.0], label="new apple")

#' Our model successfully says that our new image is an apple! Pat yourself on
#' the back: you've actually just trained your first neural network!

#' #### Exercise 1

#' Load the image of a banana in `data/8_100.jpg` as `mybanana`. Edit the code
#' below to calculate the amount of green in `mybanana` and to overlay data for
#' this image with the existing model and data points.
mybanana = load("data/8_100.jpg")
green_amount = mean(Float64.(green.(mybanana)))
@show green_amount
scatter!(pt, [green_amount], [1.0], label="new banana")
#' ## Closing remarks: bigger models, more data, more accuracy

#' That last apple should start making you think: not all apples are red; some
#' are yellow. "Redness" is one attribute of being an apple, but isn't the
#' whole thing. What we need to do is incorporate more ideas into our model by
#' allowing more inputs. However, more inputs would mean more parameters to
#' play with. Also, we would like to have the computer start "learning" on its
#' own, instead of modifying the parameters ourselves until we think it "looks
#' right". How do we take the next step?

#' The first thing to think about is, if you wanted to incorporate more data
#' into the model, how would you change the sigmoid function? Play around with
#' some ideas. But also, start thinking about how you chose parameters. What
#' process did you do to finally end up at good parameters? These two problems
#' (working with models with more data and automatically choosing parameters)
#' are the last remaining step to understanding deep learning.
