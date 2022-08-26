## Learn SymPy

module LearnSymPy
using SymPy
using Test

x = symbols("x"); @test x isa Sym
y = sin(pi*x);    @test y(1) == 0
@test y(1) == y(x=>1)
"""... The package overloads the familiar math functions ..."""
end