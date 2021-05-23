# https://levelup.gitconnected.com/functional-one-liners-in-julia-e0ed35d4ff7b

f = <(4) # (::Base.Fix2{typeof(<), Int64}) (generic function with 1 method)
@show f
@show filter(<(4), 1:10)
@show findall(==(4), [4, 8, 4, 2, 1, 5])
@show findfirst(==(4), [4, 8, 4, 2, 1, 5])

nothing
