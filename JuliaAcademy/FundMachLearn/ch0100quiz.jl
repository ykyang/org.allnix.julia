#' # Tools - Using arrays to store data
#'
#' ### Introduction to arrays
#'
#' **Arrays are collections of boxes that we can use to store data.**
#' In the last notebook, we saw an image that can help us to picture a 1-dimensional array:
#'
#' ![Drawing](data/array_cartoon_s.png)
#'
#' *Why do we want an object like this to store our data?*
#'
#' An alternative to using an array in some contexts would be to name every individual piece of data, as follows:
# Assign to variable
a = 1.1;
b = 2.2;
c = 3.3;
# - Avoid printing 3.3
#' We can visualize how this data is stored:
#'
#' ![No Array](data/without_arrays_s.png)
#'
#' This is like having a separate box for every piece of data, rather than a series of connected boxes for all our data.
#'
#' The more data we have, the more annoying it becomes to keep track of all these boxes and their names.
#'Furthermore, if we want to do the same thing with many pieces of data, it's much easier to put all of these pieces of data in one place to work with them at once.
#'
#' For example, we may want to multiply `a`, `b`, and `c` by `2`. We could multiply three times:
# Assign to individual variables
a * 2
b * 2
c * 2
# -
#'
#' Or, instead, we could create one array (let's call it `numbers`) and multiply
#' that array by `2`:
#' ```julia
#' numbers * 2
#' ```
#'
#' The syntax for creating this array, `numbers`, is
#'
numbers = [a, b, c]
#'
#' Or, we could have just written
#'
numbers = [1.1, 2.2, 3.3]
# Multiple the whole array by 2
numbers*2
#'
#' It's worth noting that in Julia, 1-dimensional arrays are also called "vectors".

#' ### Creating arrays
#'
#' In the last section, we saw that we could create the array `numbers` by
#' typing our elements, `a`, `b`, and `c` (or `1.1`, `2.2`, and `3.3`),
#' inside square brackets.
#' #### Exercise 1
#' Create an array called `first_array` that stores the numbers 10 through 20.
first_array = collect(10.0:20.0)
