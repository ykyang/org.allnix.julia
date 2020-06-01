import LinearAlgebra
import SparseArrays
#using Images
import Images
import MAT

LA = LinearAlgebra
SA = SparseArrays
Img = Images

# Matrix
dim = 4
A = rand(dim,dim)
AT = A'
A2 = A*AT

@show A[11] == A[1,2]
b = rand(dim)
# Solve for x where Ax = b
x = A\b
@show LA.norm(A*x - b)

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

luA = LA.lu(A)
# LU = PA
LA.norm(luA.L*luA.U - luA.P*A)

# QR = A
qrA = LA.qr(A)
Q = qrA.Q
R = qrA.R
LA.norm(Q*R - A)

# Skip Cholesky factorization

# Skip Sparse Linear Algebra

# Images as matrices
X1 = Images.load("data/khiam-small.jpg")
# Gray scale
Xgray = Images.Gray.(X1)
# Extract RGB values
R = map(i -> X1[i].r, 1:length(X1))    # => Vector
R2 = Float64.(reshape(R, size(X1)...)) # (80089,) => (283,283)
G = map(i -> X1[i].g, 1:length(X1))
G2 = Float64.(reshape(G, size(X1)...)) # (80089,) => (283,283)
B = map(i -> X1[i].b, 1:length(X1))
B2 = Float64.(reshape(B, size(X1)...))

Z = zeros(size(G2)...)
Images.RGB.(Z,G2,Z)

Xgrayvalues = Float64.(Xgray)
# SVD: A = U*Sigma*V'
usv =LA.svd(Xgrayvalues)
# usv.U, S, V, Vt
U = usv.U
S = usv.S
V = usv.V
Vt = usv.Vt

LA.norm(U*LA.diagm(S)*Vt - Xgrayvalues)

# Use the top 4 singular vectors/values to form a new image
i = 1
u1 = usv.U[:,i]
v1 = usv.V[:,i]
img1 = usv.S[i]*u1*v1'

i = 2
u1 = usv.U[:,i]
v1 = usv.V[:,i]
img1 += usv.S[i]*u1*v1'

i = 3
u1 = usv.U[:,i]
v1 = usv.V[:,i]
img1 += usv.S[i]*u1*v1'

i = 4
u1 = usv.U[:,i]
v1 = usv.V[:,i]
img1 += usv.S[i]*u1*v1'

Images.Gray.(img1)

i = 1:100
u1 = usv.U[:,i]
s1 = SA.spdiagm(0=>usv.S[i])
v1 = usv.V[:,i]
img1 = u1 * s1 * v1'
Img.Gray.(img1)
# Close but not the same
LA.norm(Xgrayvalues - img1)

# Face recognition
M = MAT.matread("data/face_recog_qr.mat")
# V2 contains 490 faces
# each column is a face and need to reshape into 192,168
V2 = M["V2"]
q = reshape(V2[:,200], 192, 168)
Img.Gray.(q)
b = q[:]

A = V2[:,2:end]
x = A\b
Img.Gray.(reshape(A*x, 192,168))
LA.norm(A*x - b)

# Skip
