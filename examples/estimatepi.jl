#=
Created on 09/01/2021 12:54:49
Last update: -

@author: Michiel Stock
michielfmstock@gmail.com

Estimate pi through Monte Carlo sampling. 
Do this by simuting to throw `n` pebbles in the [-1, 1] x [-1, 1] square
and track the fraction that land in the unit circle.
=#

function estimatepi(n)
    hits = 0
    for i in 1:n
        x = rand()
        y = rand()
        if x^2 + y^2 ≤ 1.0
            hits += 1
        end
    end
    return 4hits/n
end

estimatepi2(n) = 4count(x-> x ≤ 1.0, sum(rand(n, 2).^2, dims=2)) / n