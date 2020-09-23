# https://docs.julialang.org/en/v1/base/io-network/#Base.IOBuffer

# String -> IO
io = IOBuffer()

# # TODO: Is there a length limit?
write(io, "This is a string buffer") # Write string to the buffer

x = take!(io)      # x is a byte array as shown below
typeof(x)          # Array{UInt8,1}
println(String(x)) # Convert to String



