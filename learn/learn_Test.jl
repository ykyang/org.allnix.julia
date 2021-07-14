module TestLearn

using Test
@testset "All" begin
# nested testset required to run the 2nd test when the 1st would fail

@testset "First" begin
    println("First")
    @test true == false
end

@testset "Second" begin
    println("Second")
    @test true == false
end
end

end