#=
Created on 31/01/2021 17:57:19
Last update: -

@author: Michiel Stock
michielfmstock@gmail.com

Illustration of performance types on a simple sum.
=#

using BenchmarkTools

function mysum(A)
    total = 0.0
    n, m = size(A)
    for i in 1:n
        for j in 1:m
            total += A[i,j]
        end
    end
    return total
end

function mysum_rowwise(A)
    total = 0.0
    n, m = size(A)
    for j in 1:m
        for i in 1:n
            total += A[i,j]
        end
    end
    return total
end

function mysum_inbounds(A)
    total = 0.0
    n, m = size(A)
    for i in 1:n
        for j in 1:m
            @inbounds total += A[i,j]
        end
    end
    return total
end

function mysum_simd(A)
    total = 0.0
    n, m = size(A)
    @simd for i in 1:n
        @simd for j in 1:m
            total += A[i,j]
        end
    end
    return total
end

A = randn(10000, 10000)

@btime sum($A);  # reference

@btime mysum($A);  # standard implementation

@btime mysum_rowwise($A);  # changing the order of crossing the matrix

@btime mysum_inbounds($A);  # not performing checks

@btime mysum_simd($A);  # making loops independent