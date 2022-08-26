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

function learn_unknown_update()
    n = 10
    step = 1
    prog = ProgressUnknown("Waiting for lock:")
    for i in 1:n
        ProgressMeter.update!(prog, i*1)
        sleep(1.0)
    end
    ProgressMeter.finish!(prog)
end

"""
    learn_long_runtime()

Control bar length so the ETA does not get cut off.
"""
function learn_long_runtime()
    n1 = 10
    n2 = 86400
    n = n1 + n2
    p = Progress(n, dt=0.1, desc="Computing...", color=:green, barlen=25)
    for i in 1:n1
        sleep(1)
        ProgressMeter.update!(p, i, showvalues = [("Time",Dates.now())])
    end
    for i in 1:n2
        #sleep(10/n)
        ProgressMeter.update!(p, i, showvalues = [("Time",Dates.now())])
    end
    finish!(p)
end

# learn_basic()
# learn_showvalues()
# learn_update()
# learn_unknown_update()
learn_long_runtime()
nothing
