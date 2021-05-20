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

"""

@async does not seem to work, see same function in `learn_Threads.jl`
"""
function learn_write_read_file()
    n = 5000000
    done = Threads.Atomic{Bool}(false)

    writefile = function()
        open("output.txt", "w") do io
            for i in 1:n
                #sleep(0.1)
                println(io, "Hello! Number $i")
                #flush(io)
            end
        end

        Threads.atomic_or!(done, true)
        println("Done writing")
    end

    readfile = function()
        while !isfile("output.txt")
            sleep(0.1)
        end
        
        pos = 0
        first_line = ""
        final_line = ""

        while !done[]
            sleep(0.2)
            open("output.txt", "r") do io
                skip(io, pos)
                
                first_line = readline(io)
                for line in eachline(io)
                    final_line = line
                end

                pos = position(io)
            end

            # When first_line is blank meaning no update on the file between
            # opening.
            println("First line: $first_line")
            println("Final line: $final_line")
        end

        # do one more time here?
    end
    # readfile = function()
    #     #st = watch_file("output.txt", 1)
    #     #println("Timeout: $(st.timedout)")
    #     st = (changed=true,)
    #     while st.changed
    #         println("Wait for file changes")
    #         st = watch_file("output.txt", 3)
    #         println("Changed: $(st.changed)")
    #         #if st.changed
    #             open("output.txt", "r") do io
    #                 line = nothing
    #                 for line in eachline(io)
    #                     #println("Read $line")
    #                 end
    #                 println("Final Line: $line")
    #             end
    #         #end
            
    #         println("Timedout: $(st.timedout)")
    #     end
    # end 


    write_task = Task(writefile)
    read_task = Task(readfile)
    
    schedule(read_task)
    schedule(write_task)
    

    wait(read_task)
    wait(write_task)
end



#learn_basic_task_operations()
#learn_Channel()
learn_write_read_file()

nothing
