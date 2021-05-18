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
    order_chn = Channel{Int}(32)
    ship_chn= Channel{Tuple}(32)

    n = 10

    take_order = function()
        for order_id in 1:n
            println("Received order $order_id")
            put!(order_chn, order_id)
        end
    end

    manufacture = function()
        for order_id in order_chn
            
            manufacture_time = rand()
            sleep(manufacture_time)
            println("Order $order_id manufactured in $manufacture_time")
            put!(ship_chn, (order_id, manufacture_time))
        end
    end

    ship = function()
        for (order_id,manufacture_time) in ship_chn
            println("Shipped $order_id")
        end
    end

    @async ship()
    @async manufacture()
    @async take_order()
end




#learn_basic_task_operations()
learn_Channel()

nothing
