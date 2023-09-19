## Copy from julia-1.9.2/share/julia/base/logging.jl
"""
    MySimpleLogger([stream,] min_level=Info)

Simplistic logger for logging all messages with level greater than or equal to
`min_level` to `stream`. If stream is closed then messages with log level
greater or equal to `Warn` will be logged to `stderr` and below to `stdout`.
"""
struct MySimpleLogger <: AbstractLogger
    stream::IO
    min_level::LogLevel
    message_limits::Dict{Any,Int}
end
MySimpleLogger(stream::IO, level=Info) = MySimpleLogger(stream, level, Dict{Any,Int}())
MySimpleLogger(level=Info) = MySimpleLogger(closed_stream, level)

shouldlog(logger::MySimpleLogger, level, _module, group, id) =
    get(logger.message_limits, id, 1) > 0

min_enabled_level(logger::MySimpleLogger) = logger.min_level

catch_exceptions(logger::MySimpleLogger) = false

function handle_message(logger::MySimpleLogger, level::LogLevel, message, _module, group, id,
                        filepath, line; kwargs...)
    @nospecialize
    maxlog = get(kwargs, :maxlog, nothing)
    if maxlog isa Core.BuiltinInts
        remaining = get!(logger.message_limits, id, Int(maxlog)::Int)
        logger.message_limits[id] = remaining - 1
        remaining > 0 || return
    end
    buf = IOBuffer()
    stream::IO = logger.stream
    if !(isopen(stream)::Bool)
        stream = stderr
    end
    iob = IOContext(buf, stream)

    ## MOD
    #levelstr = level == Warn ? "Warning" : string(level)
    levelstr = string(level)

    msglines = eachsplit(chomp(convert(String, string(message))::String), '\n')
    msg1, rest = Iterators.peel(msglines)
    ## MOD
    #println(iob, "┌ ", levelstr, ": ", msg1)
    println(iob, "[", lpad(levelstr, 5, " "), "] ", msg1)

    i = 2
    for msg in rest
        #println(iob, "│ ", msg)
        println(iob, "[", lpad(i, 5, " "), "] ", msg)
        i += 1
    end
    for (key, val) in kwargs
        key === :maxlog && continue
        #println(iob, "│   ", key, " = ", val)
        println(iob, "[", lpad(i, 5, " "), "] ", key, " = ", val)
        i += 1
    end
    ## MOD: not printing
    #println(iob, "└ @ ", _module, " ", filepath, ":", line)

    write(stream, take!(buf))
    nothing
end