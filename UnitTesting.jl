using Base.Test

@testset "Study" begin
  @test true
  @test_throws DomainError throw(DomainError())
  @test_throws ErrorException error("Error Message")
end

try
  error("Error 3")
catch e
  println("Error type: $(typeof(e)), message: $(e.msg)")
end

#error("Error 2")
function f()
end
