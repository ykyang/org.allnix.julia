

"""
    Inf1

Alias for [`LogLevel(-1)`](@ref LogLevel).
"""
const Inf1 = LogLevel(-1)
macro inf1(exs...) Base.CoreLogging.logmsg_code((Base.CoreLogging.@_sourceinfo)..., :Inf1, exs...) end
const Inf2 = LogLevel(-2)
macro inf2(exs...) Base.CoreLogging.logmsg_code((Base.CoreLogging.@_sourceinfo)..., :Inf2, exs...) end
const Inf3 = LogLevel(-3)
macro inf3(exs...) Base.CoreLogging.logmsg_code((Base.CoreLogging.@_sourceinfo)..., :Inf3, exs...) end

# import Base: show
# function show(io::IO, level::LogLevel)
#     if     level == BelowMinLevel  print(io, "BelowMinLevel")
#     elseif level == Debug          print(io, "Debug")
#     # elseif level == Inf3           print(io, "Inf3")
#     # elseif level == Inf2           print(io, "Inf2")
#     # elseif level == Inf1           print(io, "Inf1")
#     elseif level == Info           print(io, "Info")
#     elseif level == Warn           print(io, "Warn")
#     elseif level == Error          print(io, "Error")
#     elseif level == AboveMaxLevel  print(io, "AboveMaxLevel")
#     #else                           print(io, "LogLevel($(level.level))")
#     else                           print(io, "L$(sprintf1("%+d",level.level))")
#     end
# end

import Base: print
# Called by string()
function print(io::IO, level::LogLevel)
    if     level == BelowMinLevel  print(io, "BelowMinLevel")
    elseif level == Debug          print(io, "Debug")
    # elseif level == Inf3           print(io, "Inf3")
    # elseif level == Inf2           print(io, "Inf2")
    # elseif level == Inf1           print(io, "Inf1")
    elseif level == Info           print(io, "Info")
    elseif level == Warn           print(io, "Warn")
    elseif level == Error          print(io, "Error")
    elseif level == AboveMaxLevel  print(io, "AboveMaxLevel")
    #else                           print(io, "LogLevel($(level.level))")
    else                           print(io, "L$(sprintf1("%+d",level.level))")
    end
end