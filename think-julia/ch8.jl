# Chapter 8. Strings
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

end
