# Learn how to copy files and directories

if Sys.iswindows()
    println("Windows")
    src = raw"C:\Users\Yi-Kun.Yang\tmp\org.allnix.julia"
    tgt = raw"C:\TEMP\org.allnix.julia"
    cmd = `cmd /c robocopy /move /s $(src) $(tgt) `

    cerr = IOBuffer()
    cout = IOBuffer()
    proc = run(pipeline(cmd, stdout=cout, stderr=cerr), wait=false)
    
    wait(proc)
    if proc.exitcode > 1
        @error "exitcode = $(proc.exitcode)"
        err = String(take!(cerr))
        @error err
    end    
else
    println("Unsupported OS: $(Sys.MACHINE)")
end