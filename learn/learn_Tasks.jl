# https://docs.julialang.org/en/v1/base/parallel/

using Test

function learn_Tasks()
    ## Core.Task
    # Task from a function
    a() = sum([i for i in 1:1000])
    b = Task(a)

    ## Base.@task
    b = @task a()

    @test false == istaskstarted(b)
    schedule(b)
    yield()
    @test true == istaskstarted(b)
    @test true == istaskdone(b)
    
    x = fetch(b)
    @show x
end

learn_Tasks()

nothing
