# https://docs.julialang.org/en/v1/manual/asynchronous-programming/

using FileWatching

function learn_basic_task_operations()
    # 3 ways to async

    func = function()       # function
        sleep(5)
        println("Done-1")
    end
    task1 = Task(func)      # create task from a function
    schedule(task1)         # run task

    task2 = @task begin     # create task from code block
        sleep(4)
        println("Done-2")
    end
    schedule(task2)         # run task

    task3 = @async begin    # task & run in 1 step
        sleep(3)
        println("Done-3")
    end
    
    #wait(task1)
end

function learn_Channel()
    order_chn = Channel{Int}(32)
    ship_chn = Channel{Tuple}(32)

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

function learn_file_task()
    n = 100

    writefile = function()
        open("output.txt", "w") do io
            for i in 1:n
                sleep(0.1)
                println(io, "Hello! Number $i")
                flush(io)
            end
        end
    end

    readfile = function()
        #st = watch_file("output.txt", 1)
        #println("Timeout: $(st.timedout)")
        st = (changed=true,)
        while st.changed
            println("Wait for file changes")
            st = watch_file("output.txt", 10)
            println("Changed: $(st.changed)")
            #if st.changed
                open("output.txt", "r") do io
                    for line in eachline(io)
                        println("Read $line")
                    end
                end
            #end
            
            println("Timedout: $(st.timedout)")
        end
    end 


    write_task = Task(writefile)
    read_task = Task(readfile)
    schedule(write_task)
    schedule(read_task)

    wait(read_task)
    wait(write_task)
end



#learn_basic_task_operations()
#learn_Channel()
learn_file_task()

nothing
