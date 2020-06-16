# julia --project=. plotscript.jl
#
# This will take a long time to start so won't
# recommend doing this.
using Plots
gr

# x = 1:10
# y = rand(10)
# p = plot(x,y)
# gui()
# display(p)
# println("Hello World!")
# readline()

n = 50 # points
x_vec = fill(0.0, n)
y_vec = fill(0.0, n)
xmin = -10.0
xmax = 10.0
x_range = LinRange(xmin, xmax, n)
# Sigmoid function
# Generalized logistic function
function fx(x, w, b, alpha)
    #y = 1/(1 + exp(-w*x + b))
    y = (1+ exp(-w*x)+b)^(-alpha)
    #y = exp(-w*x)
    return y
end

"""
    glf(x, A, K, B, mu, Q, C, M)

Generalized logistic function
"""
function glf(x, A, K, B, mu, Q, C, M)
    Y = A + (K-A)/(C + Q*exp(-B*(x-M)))^(1/mu)
end
# w = 1
# b = 20# 0 - 10
# alp = 0.3
A = 0.01
K = 1.0
Q = 1.0 #0.5
C = 1.0

# B = 1.8# 2 # 5 # 0 to 10 # top angle
# mu = 1.8 # Close rate  # bottom angle
# M = 5.8 # shift left and right
B = 1.8 # 2 # 5 # 0 to 10 # top angle
mu = 1.7 # Close rate  # bottom angle
M = 5.8 # shift left and right
for (ind,x) in enumerate(x_range)
    y_vec[ind] = glf(x, A, K, B, mu, Q, C, M)
end

# scale to 14.7 to 9200 psi
pmin = 14.7
pmax = 9200
pdist = pmax - pmin
dist = xmax - xmin
scale = pdist/dist
for (ind,x) in enumerate(x_range)
    x_vec[ind] = (x+10)*scale + pmin
end

pt = plot(x_vec,y_vec, legend=(0.1,0.9))

# B = 2 # 2 # 5 # 0 to 10 # top angle
# mu = 2 # Close rate  # bottom angle
# M = 5 # shift left and right
# for (ind,x) in enumerate(x_range)
#     y_vec[ind] = glf(x, A, K, B, mu, Q, C, M)
# end

# scale to 14.7 to 9200 psi
# pmin = 14.7
# pmax = 9200
# pdist = pmax - pmin
# dist = xmax - xmin
# scale = pdist/dist
# for (ind,x) in enumerate(x_range)
#     x_vec[ind] = (x+10)*scale + pmin
# end
#
# plot!(pt, x_vec, y_vec)

ps = [  14.7,   3000,    5000,    5316,    5800,   6284,   6500,       6700, 7167,  7601, 7900, 8200, 9204]
ks = [0.01, 0.01,    0.01,    0.015,    0.04,      0.08,     0.16,   0.30,   0.65,  0.85, 0.95, 1, 1]

plot!(pt, ps, ks)
