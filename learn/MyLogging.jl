"""
    Inf1

Alias for [`LogLevel(1)`](@ref LogLevel).
"""
const Inf1 = LogLevel(-1)
macro inf1(exs...) Base.CoreLogging.logmsg_code((Base.CoreLogging.@_sourceinfo)..., :Inf1, exs...) end
