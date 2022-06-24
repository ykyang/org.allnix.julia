module LearnRegularExpressions

using Test

include("Learn.jl")
using .Learn

## https://docs.julialang.org/en/v1/manual/strings/#man-regex-literals
## https://learnxinyminutes.com/docs/pcre/

re = r"^\s*(?:#|$)" # match comment on its own line
# ?: not capture in ()
# #|$ # or end of line

@test typeof(re) == Regex
@test occursin(re, "not a comment") == false
@test occursin(re, "asb #  ")       == false
@test occursin(re, "# a comment")   == true
@test occursin(re, "#a comment")    == true
@test occursin(re, "")              == true
@test occursin(re, "       ")       == true
@test occursin(re, "  #    ")       == true

@test match(re, "not a comment") isa Nothing
@test match(re, "# A comment")   isa RegexMatch

# https://docs.microsoft.com/en-us/dotnet/standard/base-types/quantifiers-in-regular-expressions
re = r"^\s*(?:#\s*(.*?)\s*$|$)" # why .*?, lazy quantifier, https://docs.microsoft.com/en-us/dotnet/standard/base-types/quantifiers-in-regular-expressions#Greedy
m = match(re, "# a comment"); showrepl(m)
m = match(re, "# a  comment"); showrepl(m)
m = match(re, "# "); showrepl(m)

re = r"\bword\b"
m = match(re, "  word  "); showrepl(m)
# https://medium.com/factory-mind/regex-tutorial-a-simple-cheatsheet-by-examples-649dc1c3f285

end # module LearnRegularExpressions