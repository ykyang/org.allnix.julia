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
    global i = i + 1
    global z = 5
end

@show(z)
@show(i)
end

@show(i)
