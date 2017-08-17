function vecadd1(a,b,c,N)
  for i = 1:N
    c = a + b
  end
end

function vecadd2(a,b,c,N)
  for i = 1:N, j=1:length(c)
    c[j] = a[j] + b[j]
  end
end

A = rand(2)
B = rand(2)
C = zeros(2)

time = @elapsed vecadd1(A,B,C,100000000)
println(time)
C = zeros(2)
time = @elapsed vecadd2(A,B,C,100000000)
println(time)
