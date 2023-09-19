# Copy from .julia/packages/LoggingExtras/0kWBo/src/Sinks/filelogger.jl

struct MyFileLogger <: AbstractLogger
    logger::MySimpleLogger
    always_flush::Bool
end

"""
    MyFileLogger(path::AbstractString; append=false, always_flush=true)

Create a logger sink that write messages to a file specified with `path`.
To append to the file (rather than truncating the file first), use `append=true`.
If `always_flush=true` the stream is flushed after every handled log message.

!!! note
    `MyFileLogger` uses the same output formatting as `SimpleLogger`. Use a `FormatLogger`
    instead of a `MyFileLogger` to control the output formatting.

"""
function MyFileLogger(path; append=false, kwargs...)
    filehandle = open(path, append ? "a" : "w")
    MyFileLogger(filehandle; kwargs...)
end

"""
    MyFileLogger(io::IOStream; always_flush=true)

Create a logger sink that write messages to the `io::IOStream`. The stream
is expected to be open and writeable.
If `always_flush=true` the stream is flushed after every handled log message.

!!! note
    `MyFileLogger` uses the same output formatting as `SimpleLogger`. Use a `FormatLogger`
    instead of a `MyFileLogger` to control the output formatting.


# Examples
```julia
io = open("path/to/file.log", "a") # append to the file
logger = MyFileLogger(io)
```
"""
function MyFileLogger(filehandle::IOStream; always_flush=true)
    MyFileLogger(MySimpleLogger(filehandle, BelowMinLevel), always_flush)
end

function handle_message(filelogger::MyFileLogger, args...; kwargs...)
    handle_message(filelogger.logger, args...; kwargs...)
    filelogger.always_flush && flush(filelogger.logger.stream)
end
shouldlog(filelogger::MyFileLogger, arg...) = true
min_enabled_level(filelogger::MyFileLogger) = BelowMinLevel
catch_exceptions(filelogger::MyFileLogger) = catch_exceptions(filelogger.logger)
