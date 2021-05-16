using ProgressMeter

function learn_basic()
    n = 100
    p = Progress(n, dt=0.1, desc="Computing...", color=:black)
    for i in 1:n
        sleep(0.1)
        next!(p)
    end
end

learn_basic()

nothing
