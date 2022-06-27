"""

Learn regular expressions

Resources
* PCRE: https://learnxinyminutes.com/docs/pcre/
* Cheat sheet: https://www.debuggex.com/cheatsheet/regex/pcre
"""
module LearnRegularExpressions

using Dates
using Test

include("Learn.jl")
using .Learn

## https://learnxinyminutes.com/docs/pcre/
## https://www.debuggex.com/cheatsheet/regex/pcre

"""

Follow Julia document on regular expression
https://docs.julialang.org/en/v1/manual/strings/#man-regex-literals
"""
function julia_man_regex_literals()
    ## Match comment "# ..." or "   " on its own line
    let 
        re = r"^\s*(?:#|$)"
        # ?:     not capture ()
        # #|$    match # or end of line

        @test typeof(re) == Regex

        ## occursin()
        @test occursin(re, "# a comment")
        @test occursin(re, "#a comment")
        @test occursin(re, "")
        @test occursin(re, "       ")
        @test occursin(re, "  #    ")
        
        @test !occursin(re, "not a comment")
        @test !occursin(re, "asb #  ")

        ## match()
        @test match(re, "not a comment") isa Nothing
        @test match(re, "# A comment")   isa RegexMatch
        @test match(re, "# ABC").match == "#"

        re = r"^\s*#|$"
        @test match(re, "# ABC").match == "#"
    end
    ## Capature non-blank string in comment
    let 
        re = r"^\s*(?:#\s*(.*?)\s*$|$)" # .*? is a lazy quantifier, see learn_greedy_and_lazy_quantifiers()
        m = match(re, "# a comment "); @test m[1] == "a comment"; #showrepl(m)
    end
    ## Specify starting index in match()
    let
        re = r"[0-9]"
        text = "aaaa1aaaa2aaaa3"
        rem = match(re, text, 1); @test rem.match == "1"; @test rem.offset == 5
        rem = match(re, text, 6); @test rem.match == "2"; @test rem.offset == 10
        rem = match(re, text, 11); @test rem.match == "3"; @test rem.offset == 15
    end
    ## Access RegexMatch
    let
        """
        * the entire substring matched: m.match
        * the captured substrings as an array of strings: m.captures
        * the offset at which the whole match begins: m.offset
        * the offsets of the captured substrings as a vector: m.offsets 
        """
        rem = match(r"(a|b)(c)?(d)", "acd")
        @test rem.match == "acd"
        @test rem.captures == ["a", "c", "d"]
        @test rem.offset == 1
        @test rem.offsets == [1,2,3]

        rem = match(r"(a|b)(c)?(d)", "ad")
        @test rem.match == "ad"
        @test rem.captures == ["a", nothing, "d"]
        @test rem.offset == 1
        @test rem.offsets == [1,0,2]

        rem = match(r"(a|b)(c)?(d)", "xadx")
        @test rem.match == "ad"
        @test rem.captures == ["a", nothing, "d"]
        @test rem.offset == 2
        @test rem.offsets == [2,0,3]
        ## Use iterator method
        first, second, third = rem.captures
        @test first == "a"; @test isnothing(second); @test third == "d"
    end
    ## replace()
    let
        ## Refer to group by number
        ## s"" is a SubstitutionString
        text = "first second"
        Ans = replace(text, r"(\w+) (\w+)" => s"\2 \1");
        @test Ans == "second first"
        Ans = replace(text, r"(\w+) (\w+)" => s"\g<2> \g<1>"); # by g<> syntax
        @test Ans == "second first"
        ## Named capture group, G in the example below
        Ans = replace(text, r"(\w+) (?<G>\w+)" => s"\g<G> \1")
        @test Ans == "second first"
    end
    ## flags i, m, s, and x
    let
        re = r"a+.*b+.*?d$"ism
        rem = match(re, "Goodbye,\nOh, angry,\nBad world\n")
        @test rem.match == "angry,\nBad world"
    end
    ## Using Regex()
    let
        re_d = Regex("Day " * string(day(Date(1962,7,10))))
        @test re_d == r"Day 10"
        rem = match(re_d, "It happened on Day 10")
        @test rem.match == "Day 10"

        ## \Q \E removes special meaning, so we can use $name
        name = "Jon"
        #                  " (              " ) 
        re_name = Regex("[\" (]\\Q$name\\E[\" )]")
        # re_name = r"[\" (]\\Q$name\\E[\" )]" # does not work
        rem = match(re_name, " Jon "); @test rem.match == " Jon "
        rem = match(re_name, "(Jon)"); @test rem.match == "(Jon)"
        rem = match(re_name, "[Jon]"); @test isnothing(rem)

    end

end 

# https://docs.microsoft.com/en-us/dotnet/standard/base-types/quantifiers-in-regular-expressions#match-one-or-more-times-


function learn_greedy_and_lazy_quantifiers()
    # https://docs.microsoft.com/en-us/dotnet/standard/base-types/quantifiers-in-regular-expressions#greedy-and-lazy-quantifiers
    
    greedy = r"\b.*([0-9]{4})\b"
    lazy   = r"\b.*?([0-9]{4})\b"
    text = "1112223333 3992991999"
    
    rem = match(greedy, text); @test rem[1] == "1999"; #showrepl(rem)
    rem = match(lazy, text);   @test rem[1] == "3333"; #showrepl(rem)

    ## From Julia documentation
    re = r"^\s*(?:#\s*(.*?)\s*$|$)"
    # .*?    lazy quantifier
    # lazy quantifier (.*?) grep as little as possible,
    # and that leaves tailing space to the final \s.
    m = match(re, "# a comment");  @test m[1] == "a comment"; #showrepl(m)
    m = match(re, "# a comment "); @test m[1] == "a comment"; #showrepl(m)
    m = match(re, "#");            @test m[1] == "";          #showrepl(m)
    m = match(re, "# ");           @test m[1] == "";          #showrepl(m)
    
    re = r"^\s*(?:#\s*(.*)\s*$|$)" 
    # .*    greedy quantifier
    # greedy quantifier (.*) grep as many as possible
    # after the first \s, including the space after chars
    m = match(re, "# a comment  "); @test m[1] == "a comment  "; #showrepl(m)
end



function learn_word_boundary()
    re = r"\bword\b"

    ## true
    @test occursin(re, "word")
    @test occursin(re, " word")
    @test occursin(re, "word ")
    @test occursin(re, "one word")
    ## false
    @test !occursin(re, "words")
    @test !occursin(re, "words ")
    @test !occursin(re, " words")
end

# https://medium.com/factory-mind/regex-tutorial-a-simple-cheatsheet-by-examples-649dc1c3f285

julia_man_regex_literals()
learn_greedy_and_lazy_quantifiers()
learn_word_boundary()

end # module LearnRegularExpressions