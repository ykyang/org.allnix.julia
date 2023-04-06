module MyPythonPlot

import PythonPlot

plt = PythonPlot.matplotlib.pyplot


# https://matplotlib.org/stable/tutorials/introductory/usage.html#a-simple-example
function learn_a_simple_example()
    fig, ax = plt.subplots()
    ax.plot([1,2,3,4], [1,4,2,3])

    savefig("a_simple_example", fig)
end



end