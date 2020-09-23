# Julia Process example
# key: cmd, command, external, sh, shell

# test_exit.bat
# @echo off
# echo "Test Exit"
# exit 1

using Logging

bat_file = "text_exit.bat"
cmd = `cmd /c $bat_file`

#
# Method 1
#
println("Method 1")
try
    # IO redirected so we will see error from cmd by default
    run(cmd)
catch e
    #@show e
    proc = e.procs[1]  # Process
    @info "Exit Code = $(proc.exitcode)"
end

#
# Method 2
#
# IO not redirected by default
println("Method 2")
proc = run(pipeline(cmd, stderr=stderr), wait=false)
wait(proc)
@info "Exit Code = $(proc.exitcode)"

#
# Method 2.1 with IO redirect
#
println("Method 2.1")
cerr = IOBuffer()
cout = IOBuffer()
proc = run(pipeline(cmd, stdout=cout, stderr=cerr), wait=false)
wait(proc)
err = String(take!(cerr))
out = String(take!(cout))
@info "stderr:$err"
@info "stdout:$out"
@info "Exit Code = $(proc.exitcode)"
