# Chapter 18. Subtyping
# https://benlauwens.github.io/ThinkJulia.jl/latest/book.html#chap18

include("AllnixThinkJulia.jl")
import .AllnixThinkJulia
ns = AllnixThinkJulia

# Cards
# https://benlauwens.github.io/ThinkJulia.jl/latest/book.html#_cards
queen_of_diamonds = ns.Card(2, 12)

# Global Variables
ns.Card(3,11)

# Comparing Cards
# https://benlauwens.github.io/ThinkJulia.jl/latest/book.html#_comparing_cards

# Exercise 18-1


# Unit Testing
# https://benlauwens.github.io/ThinkJulia.jl/latest/book.html#_unit_testing
using Test

@test ns.Card(1,4) < ns.Card(2,4)
@test ns.Card(1,3) < ns.Card(1,4)


# Decks
# https://benlauwens.github.io/ThinkJulia.jl/latest/book.html#_decks
# See ch18module.jl

# Add, Remove, Shuffle and Sort
import Random.shuffle!
deck = ns.Deck()
pop!(deck)
deck
shuffle!(deck)

# Exercise 18-2
sort!(deck)


# Abstract Types and Subtyping
# https://benlauwens.github.io/ThinkJulia.jl/latest/book.html#_abstract_types_and_subtyping

# Subtyping: Group related concrete types <- Abstract Type
deck = ns.Deck()
deck isa ns.CardSet

hand = ns.Hand("new hand")

# Abstract Types and Functions
# https://benlauwens.github.io/ThinkJulia.jl/latest/book.html#_abstract_types_and_functions
deck = ns.Deck()
shuffle!(deck)
card = pop!(deck)
push!(hand, card)

ns.move!(deck, hand, 4)
@which ns.move!(deck, hand, 4)
supertype(ns.Deck) 
