# https://docs.julialang.org/en/v1/manual/asynchronous-programming/

function learn_basic_task_operations()
    # 3 ways to async

    func = function()       # function
        sleep(5)
        println("Done-1")
    end
    task1 = Task(func)      # task
    schedule(task1)         # run

    task2 = @task begin     # task
        sleep(4)
        println("Done-2")
    end
    schedule(task2)         # run

    task3 = @async begin    # task & run 
        sleep(3)
        println("Done-3")
    end
    
    #wait(task1)
end

function learn_Channel()
    orders = Channel{Int}(32)
    products = Channel{Tuple}(32)
    shipmentss = Channel{Int}(32)

    
end

learn_basic_task_operations()

nothing
