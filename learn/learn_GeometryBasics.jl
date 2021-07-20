using GeometryBasics
import GeometryBasics as gb

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