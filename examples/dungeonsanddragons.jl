#=
Created on 02/02/2021 14:28:02
Last update: -

@author: Michiel Stock
michielfmstock@gmail.com

A simple Dungeons and Dragons interface to illustrate the (composite) type system.
=#

# First we define all the different types we want to use.

abstract type Creature end

abstract type Humanoid <: Creature end

#=
Notice that we want to use a mutable struct for the characters below since
the values of their field will be changed throughout the game.
=#

mutable struct Human <: Humanoid
    name::String
    hp::Int
    level::Int
    gold::Int
end

Human(name) = Human(name, 10, 1, rand(20:50))

mutable struct Elf <: Humanoid
    name::String
    hp::Int
    level::Int
    gold::Int
    function Elf(name)
        return new(name, 12, 1, rand(10:40))
    end
end

mutable struct Gnome <: Humanoid
    name::String
    hp::Int
    level::Int
    spells::Array{String}
    gold::Int
end

abstract type Monster <: Creature end

#=
Below you can find an example of when you would use the Union{} function.
This makes is so that all types that fall under the Float64 or Int type will be accepted. 
=#

mutable struct Dragon{T<:Union{Float64,Int}} <: Creature
    hp::T
    strength::Int
    magic::Int
end

mutable struct GelatinousCube{T<:Union{Float64,Int}} <: Creature
    hp::T
    strength::Int
    object::String
end


# Lastly we define the functions we need.

languages(::Humanoid) = "Common Tongue"
languages(::Elf) = "Common Tongue, Elvish"

encounter(::Creature, ::Creature) = nothing
encounter(::Humanoid, ::Monster) = "run!"
encounter(::Monster, ::Humanoid) = "attack!"
encounter(::Humanoid, ::Humanoid) = "talk"
encounter(::Gnome, ::Humanoid) = "steals gold..."


Base.size(::Creature) = "medium"
Base.size(::Gnome) = "small"
Base.size(::Dragon) = "large"

damage(opponent, dragon::Dragon{Int}) = max(0, opponent.level - dragon.strength)
damage(opponent, dragon::Dragon{Float64}) = max(0.0, (opponent.level - dragon.strength) / dragon.strength)