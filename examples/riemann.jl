#=
Created on 09/01/2021 13:08:20
Last update: -

@author: Michiel Stock
michielfmstock@gmail.com

Integrating for dummies. Compute the Riemann sum **without** making use of a for loop.

Compute the area of a circle.
=#

function riemannsum(f, a, b; n=100)
    dx = (b - a) / n
    return sum(f.(a:dx:b)) * dx
end

riemannsum(sin, 0, 2pi)

riemannsum(x->x*sin(x), 0, 2pi)

4riemannsum(x->(sqrt(1-x^2)), 0, 1, n=1000)
