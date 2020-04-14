# Chapter 8. Strings

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

module ch8
z = 1
i = 1
while i < 3
    global i
    i += 1
end

#@show(z)

# Exercise 8-1
function printbackward(word)
    wordLength = length(word)
    for i in wordLength:-1:1
        println(word[i])
    end
end

printbackward("ABC")

end
