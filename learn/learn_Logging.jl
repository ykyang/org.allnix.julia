module LearnLogging
# https://github.com/oxinabox/LoggingExtras.jl

using Logging
using LoggingExtras
using Dates
using Formatting

## Customer ConsoleLogger
import Base.CoreLogging:
    closed_stream, 
    handle_message, shouldlog, min_enabled_level, catch_exceptions,
    _min_enabled_level, current_logger_for_env
include("MyLogging.jl")
include("MyConsoleLogger.jl")
include("MySimpleLogger.jl")
include("MyFileLogger.jl")

"""
    learn_ActiveFilteredLogger()

Run with
```julia
include("learn_Logging.jl"); LearnLogging.learn_ActiveFilteredLogger();
```
"""
function learn_ActiveFilteredLogger()
    filtered_logger = ActiveFilteredLogger(
        function(log_args)
            #@show log_args
            # log_args = (
            #     level = Info, message = "Boring message", 
            #    _module = Main, group = :learn_LoggingExtras, 
            #    id = :Main_1a9832fc, 
            #    file = "c:\\Users\\ykyan\\work\\org.allnix.julia\\learn\\learn_LoggingExtras.jl", 
            #    line = 13, kwargs = Base.Iterators.Pairs{Union{}, Union{}, Tuple{}, NamedTuple{(), Tuple{}}}()
            # )
            startswith(log_args.message, "Yo Dawg!")
        end,
        global_logger()
    )
    
    with_logger(filtered_logger) do
        @info "Boring message"
        @warn "Yo Dawg! it is bad"
        @info "Another boring message"
        @info "Yo Dawg! it is all good"
    end
end

function make_throttled_logger(period)
    history = Dict{Symbol, DateTime}()

    logger = EarlyFilteredLogger(global_logger()) do log
        # https://docs.julialang.org/en/v1/stdlib/Logging/
        # message id: fixed identifier for the source code statement where the logging macro appears
        # @show log
        # log = (
        #     level = Info, _module = Main, group = :learn_LoggingExtras, 
        #     id = :Main_cc652dec
        # )
        if !haskey(history, log.id)
            history[log.id] = now()
            return true
        elseif now() - history[log.id] > period # has been long enough since last logging
            history[log.id] = now()
            return true
        else
            return false
        end    
    end

    return logger
end

function learn_EarlyFilteredLogger()
    logger = make_throttled_logger(Second(3))
    with_logger(logger) do
        for i in 1:10
            sleep(1)
            @info "It happened" i 
        end
    end
end

function learn_MinLevelLogger()
    @debug "Debug"
    @info "Info"

    logger = ConsoleLogger(stdout, Logging.Debug)
    debug_logger = MinLevelLogger(logger, Logging.Debug)
    with_logger(debug_logger) do
        @debug "Debug Logger"
    end
    error_logger = MinLevelLogger(logger, Logging.Error)
    with_logger(error_logger) do
        @debug "Debug no show"
        @error "Error Logger"
    end
end

function learn_TransformerLogger()
    truncating_logger = TransformerLogger(global_logger()) do log
        # @show log
        # log = (
        #     level = Info, message = "The truncating logger only truncates long messages", 
        #     _module = Main, group = :learn_LoggingExtras, 
        #     id = :Main_31932d27, 
        #     file = "C:\\Users\\ykyan\\work\\org.allnix.julia\\learn\\learn_LoggingExtras.jl", 
        #     line = 85, kwargs = Base.Iterators.Pairs{Union{}, Union{}, Tuple{}, NamedTuple{(), Tuple{}}}()
        # )

        if length(log.message) > 50
            short_message = log.message[1:(50-3)] * "..."
            return merge(log, (;message=short_message))
        else
            return log
        end
    end

    with_logger(truncating_logger) do
        @info "The truncating logger only truncates long messages"
        @info "Like this one that is this is a long and rambling message, it just keeps going and going and going,  and it seems like it will never end."
        @info "Not like this one, that is is short"
    end
end
"""
    learn_FileLogger()

Run with
```julia
include("learn_Logging.jl"); LearnLogging.learn_FileLogger();
```
"""
function learn_FileLogger()
    demux_logger = TeeLogger(
        MinLevelLogger(LoggingExtras.FileLogger("info.log"), Logging.Info),
        MinLevelLogger(LoggingExtras.FileLogger("warn.log"), Logging.Warn),
    )

    with_logger(demux_logger) do
        @debug "LoggingExtras.FileLogger"
        @warn  "LoggingExtras.FileLogger"
        @info  "LoggingExtras.FileLogger"
        @error "LoggingExtras.FileLogger"
    end
end

function learn_MyFileLogger()
    demux_logger = TeeLogger(
        MinLevelLogger(MyFileLogger("info.log"), Logging.Info),
        MinLevelLogger(MyFileLogger("warn.log"), Logging.Warn),
    )

    with_logger(demux_logger) do
        @debug "My FileLogger"
        @warn  "My FileLogger"
        @info  "My FileLogger"
        @error "My FileLogger"
        
        @warn  "Line 1\nLine 2\nLine 3\nLine 4\nLine 5\nLine 6\nLine 7"
        @error "Line 1\nLine 2\nLine 3\nLine 4\nLine 5\nLine 6\nLine 7"
    end
end

"""
    learn_FormatLogger()

Run with
```julia
include("learn_Logging.jl"); LearnLogging.learn_FormatLogger();
```
"""
function learn_FormatLogger()
    logger = FormatLogger() do io, log
        # @show log
        # log = (
        #     level = Info, message = "Info-1", 
        #     _module = Main, group = :learn_LoggingExtras, 
        #     id = :Main_1a175f96, 
        #     file = "C:\\Users\\ykyan\\work\\org.allnix.julia\\learn\\learn_LoggingExtras.jl", 
        #     line = 128, kwargs = Base.Iterators.Pairs{Union{}, Union{}, Tuple{}, NamedTuple{(), Tuple{}}}()
        # )
        print(io, "$(log._module) | [")
        printstyled(io, "$(log.level)"; color=Logging.default_logcolor(log.level))
        println(io, "] $(log.message)")
        #println(io, "$(log._module) | [$(log.level)] $(log.message)")
    end

    with_logger(logger) do
        @info "Info-1"
        @warn "Warn-1"
        @error "Error-1"
    end
end

function learn_timestamp()
    date_format = "yyyy-mm-dd HH:MM:SS"

    timestamp_logger(logger) = TransformerLogger(logger) do log
        date_str = Dates.format(now(), date_format)
        merge(log, (; message = "$date_str $(log.message)"))
    end

    logger = ConsoleLogger(stdout, Logging.Debug) |> timestamp_logger

    with_logger(logger) do
        @debug "Time stampped logger"
    end
end

function my_logging()
    # const date_format = "yyyy-mm-dd HH:MM:SS" # if global
    date_format = "yyyy-mm-dd HH:MM:SS.sss"

    timestamp_logger(logger) = TransformerLogger(logger) do log
        date_str = Dates.format(now(), date_format)
        merge(log, (; message = "$date_str $(log.message)"))
    end

    logger = TeeLogger(
        ConsoleLogger(stdout, Logging.Warn) |> timestamp_logger,
        MinLevelLogger(FileLogger("allnix.log", append=false, always_flush=true), Logging.Info) |> timestamp_logger,
    )
    global_logger(logger)

    @info "File only"
    @warn "Console and file"
end

"""

Simple, clean logging with color coded "Info"
"""
function learn_ConsoleLogger()
    # Save a copy
    default_logger = global_logger()
    @info "Default global logger"

    cout_logger = Logging.ConsoleLogger(stdout, Logging.Debug) 
    global_logger(cout_logger)
    @debug "cout_logger"
    @info  "cout_logger"
    @warn  "cout_logger"
    @error "cout_logger"

    @info "long long long long long long long long long long long long long long long long long long long long long long long long"

    @debug "Line 1\nLine 2\nLine 3\nLine 4"
    @info "Line 1\nLine 2\nLine 3\nLine 4"
    @warn "Line 1\nLine 2\nLine 3\nLine 4"
    @error "Line 1\nLine 2\nLine 3\nLine 4"

    x = 1; y = 2;
    @info "Test kwargs" x y 

    # Restore
    global_logger(default_logger)

    nothing
end

"""
    learn_MyConsoleLogger()

`LearnLogging.ConsoleLogger`, a modification to `Logging.ConsoleLogger`.
Make the beginning a lines aligned, and with a number.  This is used to display
the progress of data processing and plotting where indentation of the tasks is
important.
"""
function learn_MyConsoleLogger()
    # Save a copy
    default_logger = global_logger()
    @info "Default global logger"

    cout_logger = MyConsoleLogger(stdout, Logging.Debug) 
    global_logger(cout_logger)
    @debug "cout_logger"
    @info  "cout_logger"
    @warn  "cout_logger"
    @error "cout_logger"

    @info "long long long long long long long long long long long long long long long long long long long long long long long long"

    @debug "Line 1\nLine 2\nLine 3\nLine 4"
    @info "Line 1\nLine 2\nLine 3\nLine 4"
    @warn "Line 1\nLine 2\nLine 3\nLine 4"
    @error "Line 1\nLine 2\nLine 3\nLine 4"
    
    x = 1; y = 2;
    @info "Test kwargs" x y 

    # [ Info]     Line 1
    # [    2]     Line 2
    # [    3]       x = 1
    # [    4]       y = 2    
    @info """
        Line 1
    Line 2
    """ x y

    # [ Info] Line 1
    # [    2]   x = 1
    # [    3]   y = 2
    @info "Line 1" x y
    
    # [ Info]     Line 1
    # [    2]       x = 1
    # [    3]       y = 2
    @info "    Line 1" x y
    
    # Restore
    global_logger(default_logger)

    nothing
end

function learn_Inf1()
    @info "Default global logger"; default_logger = global_logger()

    @warn "Switching to MyConsoleLogger(stdout, Logging.Debug)"
    global_logger(MyConsoleLogger(stdout, Logging.Debug))
    @logmsg LogLevel(1) "Level 1"
    @info "info"
    @inf1 "inf1"
    @inf2 "inf2"
    @inf3 "inf3"
    @debug "Debug"

    @warn "Switching to MyConsoleLogger(stdout, Inf3)"
    global_logger(MyConsoleLogger(stdout, Inf3))
    @logmsg LogLevel(1) "Level 1"
    @info "info"
    @inf1 "inf1"
    @inf2 "inf2"
    @inf3 "inf3"
    @debug "Debug"

    @warn "Switching to MyConsoleLogger(stdout, Inf2)"
    global_logger(MyConsoleLogger(stdout, Inf2))
    @logmsg LogLevel(1) "Level 1"
    @info "info"
    @inf1 "inf1"
    @inf2 "inf2"
    @inf3 "inf3"
    @debug "Debug"

    @warn "Switching to MyConsoleLogger(stdout, Inf1)"
    global_logger(MyConsoleLogger(stdout, Inf1))
    @logmsg LogLevel(1) "Level 1"
    @info "info"
    @inf1 "inf1"
    @inf2 "inf2"
    @inf3 "inf3"
    @debug "Debug"

    @warn "Switching to MyConsoleLogger(stdout, Info)"
    global_logger(MyConsoleLogger(stdout, Info))
    @logmsg LogLevel(1) "Level 1"
    @info "info"
    @inf1 "inf1"
    @inf2 "inf2"
    @inf3 "inf3"
    @debug "Debug"


    @warn "Switching to MySimpleLogger(stdout, Debug)"
    global_logger(MySimpleLogger(stdout, Debug))
    @logmsg LogLevel(1) "Level 1"
    @info "info"
    @inf1 "inf1"
    @inf2 "inf2"
    @inf3 "inf3"
    @debug "Debug"

    @warn "Switching to MySimpleLogger(stdout, Inf3)"
    global_logger(MySimpleLogger(stdout, Inf3))
    @logmsg LogLevel(1) "Level 1"
    @info "info"
    @inf1 "inf1"
    @inf2 "inf2"
    @inf3 "inf3"
    @debug "Debug"

    @warn "Switching to MySimpleLogger(stdout, Inf2)"
    global_logger(MySimpleLogger(stdout, Inf2))
    @logmsg LogLevel(1) "Level 1"
    @info "info"
    @inf1 "inf1"
    @inf2 "inf2"
    @inf3 "inf3"
    @debug "Debug"


    @warn "Switching to MySimpleLogger(stdout, Inf1)"
    global_logger(MySimpleLogger(stdout, Inf1))
    @logmsg LogLevel(1) "Level 1"
    @info "info"
    @inf1 "inf1"
    @inf2 "inf2"
    @inf3 "inf3"
    @debug "Debug"

    @warn "Switching to MySimpleLogger(stdout, Info)"
    global_logger(MySimpleLogger(stdout, Info))
    @logmsg LogLevel(1) "Level 1"
    @info "info"
    @inf1 "inf1"
    @inf2 "inf2"
    @inf3 "inf3"
    @debug "Debug"

    # Restore
    global_logger(default_logger)

    nothing
end

"""
    learn_SimpleLogger()

SimpleLogger prints the line number.
"""
function learn_SimpleLogger()
    # Save a copy
    default_logger = global_logger()
    @info "Default global logger"

    logger = SimpleLogger(stdout, Logging.Debug)
    global_logger(logger)
    @info "SimpleLogger"

    # Restore
    global_logger(default_logger)
end

"""
    learn_MySimpleLogger()

SimpleLogger prints the line number.
"""
function learn_MySimpleLogger()
    # Save a copy
    default_logger = global_logger()
    @info "Default global logger\nLine 2\nLine 3"

    logger = MySimpleLogger(stdout, Logging.Debug)
    global_logger(logger)
    @info "MySimpleLogger"
    
    @debug "Line 1\nLine 2\nLine 3\nLine 4"
    @info "Line 1\nLine 2\nLine 3\nLine 4"
    @warn "Line 1\nLine 2\nLine 3\nLine 4"
    @error "Line 1\nLine 2\nLine 3\nLine 4"

    x = 1; y = 2;
    @info "Test kwargs" x y 

    # [ Info]     Line 1
    # [    2]     Line 2
    # [    3]       x = 1
    # [    4]       y = 2    
    @info """
        Line 1
    Line 2
    """ x y

    # [ Info] Line 1
    # [    2]   x = 1
    # [    3]   y = 2
    @info "Line 1" x y
    
    # [ Info]     Line 1
    # [    2]       x = 1
    # [    3]       y = 2
    @info "    Line 1" x y


    # Restore
    global_logger(default_logger)

    nothing
end




# include("learn_Logging.jl"); LearnLogging.learn_ActiveFilteredLogger()
# include("learn_Logging.jl"); LearnLogging.learn_EarlyFilteredLogger()
# include("learn_Logging.jl"); LearnLogging.learn_MinLevelLogger()
# include("learn_Logging.jl"); LearnLogging.learn_TransformerLogger()
# include("learn_Logging.jl"); LearnLogging.learn_FileLogger()
# include("learn_Logging.jl"); LearnLogging.learn_MyFileLogger()
# include("learn_Logging.jl"); LearnLogging.learn_FormatLogger()
# include("learn_Logging.jl"); LearnLogging.learn_timestamp()
# include("learn_Logging.jl"); LearnLogging.my_logging()
# include("learn_Logging.jl"); LearnLogging.learn_ConsoleLogger()
# include("learn_Logging.jl"); LearnLogging.learn_MyConsoleLogger()
# include("learn_Logging.jl"); LearnLogging.learn_Inf1()
# include("learn_Logging.jl"); LearnLogging.learn_SimpleLogger()
# include("learn_Logging.jl"); LearnLogging.learn_MySimpleLogger()

#nothing

end

