include("Learn.jl")

module TestLearn
#using Revise
using Test
using ..Learn

function test_log()
    ## indent, tab not defined
    @test (@isdefined indent) == false
    @test (@isdefined tab)    == false
    @test (@log   "Hello World!")    == "Hello World!"
    @test (@log 3 "Hello World!")    == "Hello World!"

    ## tab not defined
    let indent = "--" # tab not defined
        @test (@isdefined tab) == false
        @test (@log   "Hello World!")    == "--Hello World!"
        @test (@log 3 "Hello World!")    == "--Hello World!"
    end
    
    ## indent, tab defined
    indent = "--"; tab = "+"
    @test (@log   "Hello World!")     == "--+Hello World!"
    @test (@log 3 "Hello World!")     == "--+++Hello World!"

    ## Ignore non-strinng tab
    indent="--"; tab = 10; 
    @test (@log   "Hello World!")     == "--Hello World!"
    @test (@log 3 "Hello World!")     == "--Hello World!"
    
    ## overwrite with inline tab
    indent="--"; tab = "-"; 
    @test (@log "+" 3 "Hello World!") == "--+++Hello World!"

    ## overwrite with inline indent, tab
    indent="--"; tab = "-"; 
    @test (@log "+++" "-" 2 "Hello World!") == "+++--Hello World!"

    nothing
end
end