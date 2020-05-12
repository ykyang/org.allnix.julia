struct Card
    suit::Int64
    rank::Int64
    function Card(suit::Int64, rank::Int64)
        @assert(1 <= suit <= 4, "suite is not between 1 and 4")
        @assert(1 <= rank <= 13, "rank is not between 1 and 13")
        new(suit, rank)
    end
end

# Global Variables
const suit_names = ["♣", "♦", "♥", "♠"]
const rank_names = ["A", "2", "3", "4", "5", "6", "7", "8", "9", "10", "J", "Q", "K"]

function Base.show(io::IO, card::Card)
    print(io, rank_names[card.rank], suit_names[card.suit])
end

import Base.< # Must use import
# this won't work:
# function base.<(...)
# end
function <(c1::Card, c2::Card)
    # suit is compared first
    # than rank
    (c1.suit, c1.rank) < (c2.suit, c2.rank)
end

struct Deck
    cards::Array{Card, 1} # 1-D array of Card
end

function Deck()
    deck = Deck(Card[])
    for suit = 1:4
        for rank = 1:13
            push!(deck.cards, Card(suit, rank))
        end
    end

    deck
end

function Base.show(io::IO, deck::Deck)
    for card in deck.cards
        print(io, card, " ")
    end
    println()
end

function Base.pop!(v::Deck)
    pop!(v.cards)
end

function Base.push!(deck::Deck, card::Card)
    push!(deck.cards, card)
    deck
end

import Random: shuffle!
function shuffle!(deck::Deck)
    shuffle!(deck.cards)
    deck
end

# Exercise 18-2
function Base.isless(x::Card, y::Card)
    x < y
end

function Base.sort!(deck::Deck)
    sort!(deck.cards)
    deck
end
