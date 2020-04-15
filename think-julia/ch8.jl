# Chapter 8. Strings
# https://benlauwens.github.io/ThinkJulia.jl/latest/book.html#chap08
module ch8
'x'
🍌 = 5 # \:banana:
🐷 = "Yi-Kun Yang" # \:pig:
@show(🐷)

# A String is a sequence
fruit = "banana"
fruit[1]
fruit[end]

# nextind, firstind, sizeof
fruits = "🍌🍎🍐🍑"
sizeof(fruits)
nextind(fruits, 1)
fruits[5]
nextind(fruits, 5)
fruits[9]

i = 13


z = 1
i = 1
while i < 3
    global i
    i += 1
end

#@show(z)

# Traversal
# Use the one below which is way easier
index = firstindex(fruits)
while index <= sizeof(fruits)
    letter = fruits[index]
    println(letter)
    global index = nextind(fruits, index)
end

# Way easier
for letter in fruits
    println(letter)
end


# Exercise 8-1
function printbackward(word)
    wordLength = length(word)
    for i in wordLength:-1:1
        println(word[i])
    end
end

printbackward("ABC")

# Exercise 8-2

# String Slices
str = "Julius Caesar"

str[1:6]
str[:]
#fruits[1:5]

# Strings are immutable

# String Interpolation
greet = "Hello"
whom = "World"
"$greet, $(whom)"
"1 + 2 = $(1 +2)"

# Searching
# Exercise 8-4
function find(word, letter, index = 1)::Int64
    if !(letter isa Char)
        println("letter must be a Char")
        return -1
    end

    #index = firstindex(word)

    while index <= sizeof(word)
        if word[index] == letter
            return index
        end
        index = nextind(word, index)
    end
    -1
end

find("abc", 'a', 2)

function count(word, char)::Int64
    if !(char isa Char)
        println("char must be a Char")
        return -1
    end
    count = 0
    for letter in word
        if letter == char
            count += 1
        end
    end

    return count
end
count("banana", 'a')

# String Library
uppercase("Hello, World!")
ind = findfirst("a", "banana")
ind.start
ind.stop
ind = findfirst("na", "banana")
ind.start
ind.stop

# The ∈ Operator (\in)
# https://benlauwens.github.io/ThinkJulia.jl/latest/book.html#_the_operator
# The IN Operator
@show(∈)
#@show(ϵ)

'a' ∈ "banana"

function inboth(word1, word2)
    for char in word1
        if char ∈ word2
            print(char, " ")
        end
    end
end

inboth("apple", "orange")

# String Comparison
# https://benlauwens.github.io/ThinkJulia.jl/latest/book.html#_string_comparison

# ==

# Debugging
# Exercise 8-6

end # module ch8
