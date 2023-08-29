"""
Learn `Formatting.jl`
"""
module LearnFormatting

using Formatting
using Test

function learn()
    ## String
    @test sprintf1("%s", "This is a string") == "This is a string"
    fmt = "%s" # @sprintf does not allow this, therefore the test
    @test sprintf1(fmt, "This is a string") == "This is a string"

    ## Float
    @test sprintf1("%10.3f", 3.14159) == "     3.142"
    
    ## Integer
    @test sprintf1("%d", 1000000)  == "1000000"
    @test sprintf1("%'d", 1000000) == "1,000,000"

    fmt = "x is %s"
    @test sprintf1(fmt, "a string") == "x is a string"

end

@testset "Basic" begin
    learn()
end

end