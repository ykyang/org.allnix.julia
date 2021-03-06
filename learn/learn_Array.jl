using Logging
logger = SimpleLogger(stdout, Logging.Info)
global_logger(logger)

@info "Learn Julia 2D Array"
row_count = 5
col_count = 10
A = Array{Int}(undef, row_count, col_count)
B = fill(Int(0), row_count, col_count)

@info "Learn Julia Array of Array"
frac_count = 10
C = Array{Array{Int}}(undef, frac_count)
C[1] = [1, 2, 3]
C[2] = [-1,0,1]
for i in 3:length(C)
    C[i] = [-2,-1,0,1,2]
end

@info "Learn comprehension"
D = [[-13,-7,0,7,13] for i in 1:length(C)]

nothing