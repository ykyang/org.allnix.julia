"""

Learn regular expressions

Resources
* PCRE: https://learnxinyminutes.com/docs/pcre/
* Cheat sheet: https://www.debuggex.com/cheatsheet/regex/pcre
"""
module LearnRegularExpressions

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
        rem = match(re, text, 1); @test rem.match == "1"
        rem = match(re, text, 6); @test rem.match == "2"
        rem = match(re, text, 11); @test rem.match == "3"
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