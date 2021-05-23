using Test

# https://en.wikibooks.org/wiki/Introducing_Julia/Strings_and_characters#Splitting_and_joining_strings
function learn_split()
    # Split by multiple tokens using regular expression.
    # How fast is this?
    # Split by " " or ",".
    str = "This is a\tlearning,experience"
    Ans = ["This", "is", "a", "learning", "experience"]
    @test Ans == split(str, r"\ |,|\t")                   # regular expression
    delimiters = [' ', ',', '\t']
    @test Ans == split(str, delimiters)                    # array
    @test Ans == split(str, in(delimiters))                # function
    @test Ans == split(str, x -> x in delimiters)          # function

    @test 3 == findfirst('i', str)::Union{Nothing,Int,UnitRange{Int}}
    @test 3 == findfirst(==('i'), str)::Union{Nothing,Int,UnitRange{Int}}

    # Conver snake case to camel case
    # . is broadcast
    greeting = "hello_how_are_you"
    @test "HelloHowAreYou" == split(greeting, '_') .|> uppercasefirst |> join
end




learn_split()
learn_Fix2()


nothing
