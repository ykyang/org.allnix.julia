#' ## Run this cell to load the graphics packages
#+ results="hidden"
using Plots;
plotly()
#+

#' ## Adding a function parameter
#' In the last notebook, we saw an example of adding **parameters** to
#' functions. These are values that control the behavior of a function.
#' Let's look at that in some more detail.
#' Let's go back to our original version of the σ function:
#+ results="hidden"
sigma(x) = 1/(1+exp(-x))
#+
#' Instead of working with a single function, we can work with a whole class
#' (set) of functions that look similar but differ in the value of a
#' **parameter**. Let's make a new function that uses the previous $\sigma$
#' function, but also has a parameter, $w$. Mathematically, we could write

#' $$f_w(x) = f(x; w) = \sigma(w \, x).$$

#' (Here, $w$ and $x$ are multiplied in the argument of $\sigma$; we could
#' write $w \times x$ or $w * x$, or even $w \cdot x$, but usually the symbols
#' are not written.)

#' Mathematically speaking, we can think of $f_w$ as a different function for
#' each different value of the parameter $w$.

#' In Julia, we write this as follows:
#+ results="hidden"
f(x, w) = sigma(w * x)
#+
