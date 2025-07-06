"""
Simple gradient descent in Julia as a performance check
"""

using LinearAlgebra

function gradient_descent(P, q, x₀;
                α=0.01, β=0.8, maxiter=1000, ε=1e-5)
    x = copy(x₀)
    ∇f = x -> P * x + q
    Δx = -∇f(x)
    for iter in 1:maxiter
        x .+= α * Δx
        Δx .=  β .* Δx .- (1-β) .* ∇f(x)
        norm(Δx) < ε && break
    end
    return x
end

P = [10 -1 0;
    -1 1 0;
    0 0 5]

q = [0, -10, 20]

x₀ = zeros(3)

gradient_descent(P, q, x₀)

#=
using BenchmarkTools

@btime gradient_descent($P, $q, $x₀)
=#