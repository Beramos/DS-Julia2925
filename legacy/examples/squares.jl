#=
Created on 22/01/2021 14:26:51
Last update: -

@author: Michiel Stock
michielfmstock@gmail.com

Example from the main documentation about interphases.
Illustrates iterator over the squares for integer values.
=#

struct Squares
    count::Int
end

Base.iterate(S::Squares, state=1) = state > S.count ? nothing : (state*state, state+1)

for i in Squares(7)
    println(i)
end

25 in Squares(10)

sum(Squares(1803))

Base.eltype(::Type{Squares}) = Int

Base.length(S::Squares) = S.count

collect(Squares(4))

Base.sum(S::Squares) = (n = S.count; return n*(n+1)*(2n+1)÷6)

sum(Squares(1803))