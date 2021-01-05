#=
Created on 05/01/2021 20:10:45
Last update: -

@author: Michiel Stock
michielfmstock@gmail.com

Example of some interesting matrices
- Strang matrix
=#

# STRANG MATRIX

struct Strang <: AbstractMatrix{Int}
    n::Int
end

Base.size(S::Strang) = (S.n, S.n)
Base.getindex(S::Strang, i, j) = i==j ? 2 : (abs(i - j) == 1 ?  -1 : 0)

S = Strang(1000)

@time sum(S)

Base.sum(S::Strang) = 2

@time sum(S)

v = randn(1000)

@time S * v

function Base.:*(S::Strang, v::Vector)
    n = length(v)
    @assert size(S, 2) == n
    x = similar(v)
    for i in 1:n
        x[i] = v[i]
        i > 1 && (x[i] += v[i-1])
        i < n && (x[i] += v[i+1])
    end
    return x
end

@time S * v

# Vandermonde matrix

struct Vandermonde{T,VT} <: AbstractMatrix{T}
    α::VT
    m::Int
    Vandermonde(α::AbstractVector{T}, m) where {T} = new{T,typeof(α)}(α,m)
end

Vandermonde(α::Vector{<:Number}) = Vandermonde(α, length(α))

Base.size(V::Vandermonde) = (length(V.α), V.m)
Base.getindex(V::Vandermonde, i, j) = V.α[i]^(j-1)

α = [1, 2, 3, 4]

V = Vandermonde(α, 4)

using LinearAlgebra

LinearAlgebra.det(V::Vandermonde) = ((xi-xj) for (i,xi) in enumerate(V.α), (j, xj) in enumerate(V.α) if i < j) |> prod