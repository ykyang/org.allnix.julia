using LinearAlgebra
using SparseArrays
using Images
using MAT

# Matrix
dim = 4
A = rand(dim,dim)
AT = A'
A2 = A*AT

@show A[11] == A[1,2]
b = rand(dim)
# Solve for x where Ax = b
x = A\b
@show norm(A*x - b)

@show typeof(A)
@show typeof(b)
@show typeof(rand(1,dim))
@show typeof(AT)

#A = [1 2;3 4]
sizeof(A) # => byte count
sizeof(AT)
B = copy(AT)
sizeof(B)

# \(x, y) => x^(-1) * y
#x = \(A,b) # => A^(-1)*b
@show \(3,6) # => 1/3 * 6
@show 3\6    # => 1/3 * 6

1//3 + 1//2

#A = sparse([1,2,4], [1,1,1], [1.0,1.0,1.0], 4, 2)
#F = qr(A)

luA = lu(A)
# LU = PA
norm(luA.L*luA.U - luA.P*A)

# QR = A
qrA = qr(A)
Q = qrA.Q
R = qrA.R
norm(Q*R - A)

# Skip Cholesky factorization
