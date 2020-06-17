#' # Modeling data 1
#'
#' Machine learning and data science is about modeling data. **Modeling** is the representation of an idea with some parameters and  a mathematical representation which we will encode in software. All machine learning methods are about training a computer to fit a model to some data. Even the fanciest neural networks are simply choices for models. In this notebook, we will begin to start building our first computational model of data.

#' ## Modeling data is hard!
#'
#' Let's pick up where we left off in notebook 1 with fruit. We were left with a riddle: when we load images of apples and bananas,

import Images
import Statistics
S = Statistics
# -

#' Load apple
apple = Images.load("data/10_100.jpg")
#' Load banana
banana = Images.load("data/104_100.jpg")
#' and then compare their average value for the color red, we end up with something that is perhaps surprising:

apple_red_amount = S.mean(Float64.(Images.red.(apple)))
banana_red_amount = S.mean(Float64.(Images.red.(banana)));

"The average value of red in the apple is $apple_red_amount, " *
"while the average value of red in the banana is $banana_red_amount."

#' We see that the banana's mean red value is higher than the apple's, even though the apple looks much redder. Can you guess why?
#'
#' There are actually two reasons. One of the reasons is the background: the image of the banana has a lot more white background than the apple, and that white background has a red value of 1! In our minds we ignore the background and say "the banana is bright yellow, the apple is dark red", but a computer just has a bundle of numbers and does not know where it should be looking.
#'
#' The other issue is that "bright yellow" isn't a color that exists in a computer. The computer has three colors: red, green, and blue. "Bright yellow" in a computer is a mixture of red and green, and it just so happens that to get this color yellow, it needs more red than the apple!

"The amount of red in the apple at (60, 60) is $(Float64(Images.red(apple[60, 60]))), " *
"while the amount of red in the banana at (60, 60) is $(Float64(Images.red(banana[60, 60])))."
#'
apple[60,60]
#'
banana[60,60]
#' This is a clear example that modeling data is hard!

#' ### A note on string interpolation
#'
#' In the last two input cells, we *interpolated a string*. This means that when we write the string using quotation marks (`"  "`), we insert a placeholder for some **value** we want the string to include. When the string is evaluated, the value we want the string to include replaces the placeholder. For example, in the following string,
#'
#' ```julia
#' mystring = "The average value of red in the apple is $apple_red_amount"
#' ```
#'
#' `$apple_red_amount` is a placeholder for the value stored in the variable `apple_red_amount`. Julia knows that we want to use the value bound to the variable `apple_red_amount` and *not* the word "apple_red_amount" because of the dollar sign, `$`, that comes before `apple_red_amount`.
