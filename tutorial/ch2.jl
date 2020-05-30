#=
Block comment
=#
str1 = "String 1"
str2 = "String 2"
println(str1 * str2)
println(string(str1, str2))
all = "$str1 and $str2"
println(all)

# Array
a = Int32[]
a = Array{Int32, 1}(undef, 3)
# zeros & ones
Zeros = zeros(Int32, 3,3)
Ones = ones(Int32, 2,2)
# Row vector
row = [1 2 3]
# Column vector
col = [1, 2, 3]

# Double array
d = Array{Float64, 1}(undef, 3)
d .= 0
# Append 1 element
push!(d, 1)
# Append elements
append!(d, zeros(Float64, 2))

# Heterogeneous array with Any type

# Union is more efficient
