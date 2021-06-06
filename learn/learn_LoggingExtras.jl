# https://github.com/oxinabox/LoggingExtras.jl

using Logging
using LoggingExtras
using Dates

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

function learn_FileLogger()
    demux_logger = TeeLogger(
        MinLevelLogger(FileLogger("info.log"), Logging.Info),
        MinLevelLogger(FileLogger("warn.log"), Logging.Warn),
    )

    with_logger(demux_logger) do
        @warn "Warn-1"
        @info "Info-1"
        @error "Error-1"
        @debug "Debug-1"
    end
end

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
        println(io, "$(log._module) | [$(log.level)] $(log.message)")
    end

    with_logger(logger) do
        @info "Info-1"
        @warn "Warn-1"
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

# Simple, clean logging with color coded "Info"
function learn_console_logger()
    # Save a copy
    default_logger = global_logger()
    @info "Default global logger"

    cout_logger = ConsoleLogger(stdout, Logging.Info) 
    global_logger(cout_logger)
    @info "cout_logger"

    # Restore
    global_logger(default_logger)
end

# SimpleLogger prints the line number.
function learn_simple_logger()
    # Save a copy
    default_logger = global_logger()
    @info "Default global logger"

    logger = SimpleLogger(stdout, Logging.Info)
    global_logger(logger)
    @info "SimpleLogger"

    # Restore
    global_logger(default_logger)
end

#learn_ActiveFilteredLogger()
#learn_EarlyFilteredLogger()
#learn_MinLevelLogger()
#learn_TransformerLogger()
#learn_FileLogger()
#learn_FormatLogger()
#learn_timestamp()
#my_logging()
#learn_console_logger()
learn_simple_logger()

nothing
