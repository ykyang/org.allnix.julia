module LearnLsqFit

using LsqFit
using Random
using OffsetArrays
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

"""
Fitting with `exp` function.
"""
function learn_basic_exp()
    fig,ax = plt.subplots()

    func_exp(x,p) = p[1] .* exp.(-p[2] * x) .+ p[3] # y = a*exp(-b*x) + c
    
    data_ys = [10000, 9000, 5000]
    data_xs = [10,20,30]

    ## Plot data
    ax.plot(data_xs, data_ys, linestyle="", marker="o")

    p_init = [10000, -0.1, 10]
    fit = curve_fit(func_exp, data_xs, data_ys, p_init) 
    @show fit

    xs = 5:35 #range(5,35, length=100)
    model(x) = func_exp(x,fit.param)
    ys = @. model(xs)

    
    ax.plot(xs,ys)
end

function convex_data()
    xs = Float64[10,20,30]
    ys = Float64[2000, 3000, 8000] #[10000, 9000, 5000]
    return xs, ys
end

function concave_data()
    xs = Float64[10,20,30]
    ys = Float64[10000, 9000, 5000]
    return xs, ys
end

function decay_data()
    #xs = [10,20,30]
    xs = Float64[10,15,30]
    ys = Float64[10000, 5000,4000]
    return xs, ys
end

function linear_data()
    xs = Float64[10,30]
    ys = Float64[10000,4000]
    return xs, ys
end

function const_data()
    xs = Float64[10,30]
    ys = Float64[4000,4000]
    return xs, ys
end

function plot_data(ax, x, y)
    ax.plot(x, y, linestyle="", marker="o")
end
function plot_model(ax, model::Function)
    x = 10:30
    y = model.(x)
    ax.plot(x,y)
end
function config_plot(fig, ax)
    ax.grid(true)
end



function learn_concave_exp_1()
    fn_name = string(StackTraces.stacktrace()[1].func)
    
    fig,ax = plt.subplots()
    fig.suptitle(fn_name)

    ## Data
    data_xs,data_ys = concave_data()
    ax.plot(data_xs, data_ys, linestyle="", marker="o")

    ## Model
    func(x,p) = p[1] .* exp.(p[2] * x) .+ p[3] # y = a*exp(-b*x) + c
    p_init = [0.1, 0.1, 2000]
   
    fit = curve_fit(func, data_xs, data_ys, p_init) 
    @info fn_name
    @info "Fitting parameters: $(fit.param)" # [ Info: Fitting parameters: [31249.99999999991, -0.1609437912434097, 3749.999999999997]

    model(x) = func(x,fit.param)

    plot_model(ax, model)
    config_plot(fig, ax)
end
function learn_concave_power_1()
    fn_name = string(StackTraces.stacktrace()[1].func)
    
    fig,ax = plt.subplots()
    fig.suptitle(fn_name)

    ## Data
    data_xs,data_ys = concave_data()
    plot_data(ax, data_xs, data_ys)

    ## Model
    func(x,p) = @. p[1] * x^(p[2]) + p[3] # y = a*x^b + c
    p_init = [0.1, 3.8, 10000]

    fit = curve_fit(func, data_xs, data_ys, p_init) 
    @info fn_name
    @info "Fitting parameters: $(fit.param)" # [ Info: Fitting parameters: [-0.011318158524437691, 3.8261808257742382, 10075.850176941023]

    model(x) = func(x,fit.param)

    plot_model(ax, model)
    config_plot(fig, ax)
end
function learn_convex_exp_1()
    fn_name = string(StackTraces.stacktrace()[1].func)
    
    fig,ax = plt.subplots()
    fig.suptitle(fn_name)

    ## Data
    data_xs,data_ys = convex_data()
    plot_data(ax, data_xs, data_ys)

    ## Model
    func(x,p) = @. p[1] * exp(p[2] * x) + p[3] # y = a*exp(-b*x) + c
    p_init = [0.1, 0.1, 2000]
   
    fit = curve_fit(func, data_xs, data_ys, p_init) 
    @info fn_name
    @info "Fitting parameters: $(fit.param)" # [ Info: Fitting parameters: [31249.99999999991, -0.1609437912434097, 3749.999999999997]

    model(x) = func(x,fit.param)

    plot_model(ax, model)

    config_plot(fig, ax)
end
function learn_convex_power_1()
    fn_name = string(StackTraces.stacktrace()[1].func)
    
    fig,ax = plt.subplots()
    fig.suptitle(fn_name)

    ## Data
    data_xs,data_ys = convex_data()
    plot_data(ax, data_xs, data_ys)

    ## Model
    func(x,p) = @. p[1] * x^(p[2]) + p[3] # y = a*x^b + c
    p_init = [0.1, 3.8, 10000]

    fit = curve_fit(func, data_xs, data_ys, p_init) 
    @info fn_name
    @info "Fitting parameters: $(fit.param)" # [ Info: Fitting parameters: [-0.011318158524437691, 3.8261808257742382, 10075.850176941023]

    model(x) = func(x,fit.param)

    plot_model(ax, model)
    config_plot(fig, ax)
end
function learn_decay_exp_1()
    fn_name = string(StackTraces.stacktrace()[1].func)
    
    fig,ax = plt.subplots()
    fig.suptitle(fn_name)

    ## Data
    data_xs,data_ys = decay_data()
    ax.plot(data_xs, data_ys, linestyle="", marker="o")

    ## Model
    func(x,p) = p[1] .* exp.(p[2] * x) .+ p[3] # y = a*exp(-b*x) + c
    p_init = [10000, -0.1, 10]
   
    fit = curve_fit(func, data_xs, data_ys, p_init) 
    @info fn_name
    @info "Fitting parameters: $(fit.param)" # [ Info: Fitting parameters: [31249.99999999991, -0.1609437912434097, 3749.999999999997]

    model(x) = func(x,fit.param)

    plot_model(ax, model)
    config_plot(fig, ax)
end
function learn_decay_power_1()
    fn_name = string(StackTraces.stacktrace()[1].func)
    
    fig,ax = plt.subplots()
    fig.suptitle(fn_name)

    ## Data
    data_xs,data_ys = decay_data()
    plot_data(ax, data_xs, data_ys)

    ## Model
    func(x,p) = @. p[1] * x^(p[2]) + p[3] # y = a*x^b + c
    p_init = [-0.1, 3.8, 10000,10]

    fit = curve_fit(func, data_xs, data_ys, p_init) 
    @info fn_name
    @info "Fitting parameters: $(fit.param)" # [ Info: Fitting parameters: [-0.011318158524437691, 3.8261808257742382, 10075.850176941023]

    model(x) = func(x,fit.param)

    plot_model(ax, model)
    config_plot(fig, ax)
end

function learn_linear()
    fn_name = string(StackTraces.stacktrace()[1].func)
    
    fig,ax = plt.subplots()
    fig.suptitle(fn_name)

    ## Data
    data_xs,data_ys = linear_data()
    ax.plot(data_xs, data_ys, linestyle="", marker="o")

    ## Model
    func(x,p) = @. p[1]*x + p[2] #p[1] .* exp.(p[2] * x) .+ p[3] # y = a*exp(-b*x) + c
    p_init = [1000, 10.0]
   
    fit = curve_fit(func, data_xs, data_ys, p_init) 
    @info fn_name
    @info "Fitting parameters: $(fit.param)" # [ Info: Fitting parameters: [31249.99999999991, -0.1609437912434097, 3749.999999999997]

    model(x) = func(x,fit.param)

    plot_model(ax, model)
    config_plot(fig, ax)
end

function learn_const()
    fn_name = string(StackTraces.stacktrace()[1].func)
    
    fig,ax = plt.subplots()
    fig.suptitle(fn_name)

    ## Data
    data_xs,data_ys = const_data()
    ax.plot(data_xs, data_ys, linestyle="", marker="o")

    ## Model
    func(x,p) = @. p[1]*x + p[2] #p[1] .* exp.(p[2] * x) .+ p[3] # y = a*exp(-b*x) + c
    p_init = [1000, 10.0]
   
    fit = curve_fit(func, data_xs, data_ys, p_init) 
    @info fn_name
    @info "Fitting parameters: $(fit.param)" # [ Info: Fitting parameters: [31249.99999999991, -0.1609437912434097, 3749.999999999997]

    model(x) = func(x,fit.param)

    plot_model(ax, model)
    config_plot(fig, ax)
end


function learn_basic_polynomial_1()
    fn_name = string(StackTraces.stacktrace()[1].func)

    fig,ax = plt.subplots()
    fig.suptitle(fn_name)

    func(x,p) = p[1] .+ p[2].*x .+ p[3].*x.^2 .+ p[4].*x.^3
    
    data_ys = [10000, 9000, 5000]
    data_xs = [10,20,30]

    ## Plot data
    ax.plot(data_xs, data_ys, linestyle="", marker="o")

    p_init = [0, 1, 0.1, 0.01]
    fit = curve_fit(func, data_xs, data_ys, p_init) 
    @info fn_name
    @info "Fitting parameters: $(fit.param)"

    xs = 5:35 #range(5,35, length=100)
    model(x) = func(x,fit.param)
    ys = @. model(xs)

    
    ax.plot(xs,ys)
end


# learn_basic()
# learn_power()

learn_concave_exp_1()
learn_concave_power_1()

learn_convex_exp_1()
learn_convex_power_1()

learn_decay_exp_1()
learn_decay_power_1()

learn_linear()
learn_const()


# learn_basic_exp_3()
# learn_basic_power_1()

# learn_basic_power_3()
# learn_basic_polynomial_1()

end # module LearnLsqFit