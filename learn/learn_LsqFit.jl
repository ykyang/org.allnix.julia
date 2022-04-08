using LsqFit
using Random
import PyPlot as plt

function learn_basic()
    Random.seed!(19680801)

    model(t, p) = p[1] * exp.(-p[2] * t)

    tdata = range(0,10, length=20)
    ydata = model(tdata, [1.0, 2.0]) + 0.01*randn(length(tdata))

    p0 = [0.5, 0.5]

    fit = curve_fit(model, tdata, ydata, p0)

    # using Plots
    # plotly()

    # pt = plot(title="Nonlinear Regression", size=(600,400))
    # plot!(pt, tdata, ydata, seriestype=:scatter)

    # a = fit.param[1]
    # b = fit.param[2]
    # fitmodel(t) = a * exp.(-b*t)
    # #plot!(pt, fitmodel, extrema(tdata)..., seriestype=:line)
    # x = range(0,10,length=100)
    # y = @. fitmodel(x)
    # plot!(pt, x, y, seriestype=:line)
    # gui(pt)


    fig,ax = plt.subplots()

    ax.plot(tdata, ydata, linestyle="", marker="o")

    a = fit.param[1]
    b = fit.param[2]
    fitmodel(t) = a * exp.(-b*t)
    x = range(0,10,length=100)
    y = @. fitmodel(x)
    ax.plot(x,y)
end

function learn_power()
    Random.seed!(19680801)
    model(t, p) = p[1] * exp.(-p[2] * t)
    #model(t, p) = p[1] * t.^(-p[2])
    #p0 = [0.5, 0.5]
    tdata = range(1,10, length=20)
    

    fig,ax = plt.subplots()
    ydata = model(tdata, [10000.0, 0.8]) + 0.01*randn(length(tdata))
    
    tdata = tdata[[1,2,9,20]]
    ydata = ydata[[1,2,9,20]]

    ax.plot(tdata, ydata, linestyle="", marker="o")



    p0 = [0.5, 0.5] # initial guess
    fit = curve_fit(model, tdata, ydata, p0)
    a = fit.param[1]
    b = fit.param[2]
    fitmodel(t) = a * exp.(-b*t)
    #fitmodel(t) = a * t.^(-b)
    x = range(1,10,length=100)
    y = @. fitmodel(x)
    ax.plot(x,y)

    # ydata = model(tdata, [1.0, 3.0])# + 0.01*randn(length(tdata))
    # ax.plot(tdata, ydata, linestyle="", marker="o")
end

#learn_basic()
learn_power()

nothing