#=
Created on 05/01/2021 18:39:18
Last update: -

@author: Michiel Stock
michielfmstock@gmail.com

A very basic implementation of Kronecker.jl
=#

struct Kronecker{T,TA,TB} <: AbstractMatrix{T}
    A::TA  # first matrix
    B::TB  # second matrix
    # constructor
    function Kronecker(A::TA, B::TB) where {TA<:AbstractMatrix,TB<:AbstractMatrix}
        T = promote_type(eltype(A), eltype(B))  # general type
        return new{T,TA,TB}(A, B)
    end
end

Base.eltype(K::Kronecker{T,TA,TB}) where {T,TA,TB} = T
Base.size(K::Kronecker) = size(K.A) .* size(K.B)

function  Base.getindex(K::Kronecker, i, j)
    A, B = K.A, K.B
    n, m = size(A)
    p, q = size(B)
    return A[(i-1)÷p+1,(j-1)÷q+1] * B[(i-1)%p+1,(j-1)%q+1]
end

# syntactic sugar
⊗ = Kronecker

A = rand(Bool, 100, 100)
B = randn(50, 50)

K = A ⊗ B
Kdense = kron(A, B)  # native julia version

Base.inv(K::Kronecker) = Kronecker(inv(K.A), inv(K.B))

@time inv(K)
@time inv(Kdense)


