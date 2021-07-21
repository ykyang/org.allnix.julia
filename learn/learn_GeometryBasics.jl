using GeometryBasics
import GeometryBasics
import GeometryBasics as gb
using Test

x = Rect(Vec(0.0, 0.0), Vec(1.0, 1.0))
y = Rect(Vec(0.5, 0.7), Vec(1.0, 1.0))

#z = GeometryBasics.intersect(x,y)

# """
#     intersect(h1::Rect, h2::Rect)

# Perform a intersection between two Rects.
# """
# function intersect(h1::Rect{N}, h2::Rect{N}) where {N}
#     m = max.(minimum(h1), minimum(h2))
#     mm = min.(maximum(h1), maximum(h2))
#     return Rect{N}(m, mm - m)
# end
# https://github.com/JuliaGeometry/GeometryBasics.jl/blob/798ddaa812cb11a8b28cc9d75f6df12e07c72fdc/src/primitives/rectangles.jl#L337-L341
z = gb.intersect(x,y)

x = Rect(Vec(0.0, 0.0), Vec(1.0, 1.0))
y = Rect(Vec(2.5, 3.7), Vec(1.0, 1.0))
z = gb.intersect(x,y)
@show z

rect = Vector{Rect2D{Float64}}()
push!(rect, z)
rect

function learn_Rect()
    r1 = Rect(Vec(0.0, 0.0), Vec(1.0, 1.0))
    r2 = Rect(Vec(0.5, 0.7), Vec(1.0, 1.0))
    r3 = Rect2D{Float64}(0,0,1,1)
    
    @test r1 == r3
    @test 1 == area(r1)
    @test 1 == area(r2)

    r4 = Rect2D{Float64}(0,0,2,3)
    @test 2*3 == area(r4)

    r5 = Rect2D{Float64}(0.2, 0.4, 1, 1)
    r6 = GeometryBasics.intersect(r1,r5)
    @test (1-0.2)*(1-0.4) == area(r6)
    @test [0.2,0.4] == r6.origin
    @test [0.8,0.6] == r6.widths
    #@show r6


    ## No intersection of rectangles
    # Only 2 possible relative positions
    # Lower-left and upper-right
    # Upper-left and lower-right
    # If any of the width is negative then it is non-intersect
    # Test intersection with
    #
    #   any(ir.widths .<= 0)

    ## Lower-left and upper-right

    # Points are touching
    r = Rect2D{Float64}(1, 1, 1, 1)
    ir = GeometryBasics.intersect(r1,r)
    @test [1,1] == ir.origin
    @test [0,0] == ir.widths
    @test any(ir.widths .<= 0)
    
    # x >, y <
    r = Rect2D{Float64}(1.001, 0.5, 1, 1)
    ir = GeometryBasics.intersect(r1,r)
    @test any(ir.widths .<= 0)

    # x >, y >
    r = Rect2D{Float64}(1.001, 1.001, 1, 1)
    ir = GeometryBasics.intersect(r1,r)
    @test any(ir.widths .<= 0)

    # x <, y >
    r = Rect2D{Float64}(0.5, 1.001, 1, 1)
    ir = GeometryBasics.intersect(r1,r)
    @test any(ir.widths .<= 0)

    ## Upper-left and lower-right
    # x >, y <
    r = Rect2D{Float64}(1.001, -0.5, 1, 1)
    ir = GeometryBasics.intersect(r1,r)
    @test any(ir.widths .<= 0)

    # x >, y >
    r = Rect2D{Float64}(1.001, -1.001, 1, 1)
    ir = GeometryBasics.intersect(r1,r)
    @test any(ir.widths .<= 0)

    # x <, y >
    r = Rect2D{Float64}(0.5, -1.001, 1, 1)
    ir = GeometryBasics.intersect(r1,r)
    @test any(ir.widths .<= 0)
end

@testset "Base" begin
    learn_Rect()
end

nothing