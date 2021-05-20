using FileWatching

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

        pos = 0 # position of from last file opening
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
                #println("EOF: $(eof(io))") # EOF: true
            end
            # When first_line is blank meaning no update on the file between
            # opening.
            println("First line: $first_line")
            println("Final line: $final_line")
        end

        # do one more time here?
    end

    write_task = Threads.@spawn writefile()
    read_task = Threads.@spawn readfile()
    
    wait(write_task) # use fetch() to get return value
    wait(read_task)
end

learn_write_read_file()

nothing
