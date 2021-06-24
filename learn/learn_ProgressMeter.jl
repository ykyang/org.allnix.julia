using ProgressMeter
using Dates

function learn_basic()
    n = 50
    p = Progress(n, dt=0.1, desc="Computing...", color=:green)
    for i in 1:n
        sleep(0.1)
        next!(p)
    end
    finish!(p)
end

function learn_showvalues()
    n = 50
    p = Progress(n, dt=0.1, desc="Computing...", color=:green)
    for i in 1:n
        sleep(0.1)
        next!(p, showvalues = [("Time",Dates.now())])
    end
    finish!(p)
end

function learn_update()
    n = 50
    p = Progress(n, dt=0.1, desc="Computing...", color=:green)
    for i in 1:n
        sleep(0.1)
        ProgressMeter.update!(p, i, showvalues = [("Time",Dates.now())])
    end
    finish!(p)
end

#learn_basic()
#learn_showvalues()
learn_update()

nothing
